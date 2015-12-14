import Foundation
import Accounts
import Social
import Result

protocol TwitterAPIRequestType {
    typealias Response

    var baseURL: NSURL { get }
    var method: SLRequestMethod { get }
    var path: String { get }
    var parameters: [NSString: AnyObject] { get }
    var acceptableStatusCodes: Set<Int> { get }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response?
    func errorFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> ErrorType?
}

extension TwitterAPIRequestType {
    var baseURL: NSURL {
        return NSURL(string: "https://api.twitter.com")!
    }

    var parameters: [NSString: AnyObject] {
        return [:]
    }

    var acceptableStatusCodes: Set<Int> {
        return Set(200..<300)
    }

    func errorFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> ErrorType? {
        return NSError(domain: "TwitterAPIErrorDomain", code: 0, userInfo: ["object": object, "URLResponse": URLResponse])
    }

    func buildSLRequest(account: ACAccount) -> SLRequest {
        let URL = path.isEmpty ? baseURL : baseURL.URLByAppendingPathComponent(path)
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: method, URL: URL, parameters: parameters)
        request.account = account

        return request
    }

    func parseData(data: NSData, URLResponse: NSHTTPURLResponse) -> Result<Response, TwitterAPIError> {
        let object: AnyObject
        do {
            object = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        } catch let error as NSError {
            return .Failure(.ResponseBodyDeserializationError(error))
        }

        if !acceptableStatusCodes.contains(URLResponse.statusCode) {
            guard let error = errorFromObject(object, URLResponse: URLResponse) else {
                return .Failure(.InvalidResponseStructure(object))
            }
            return .Failure(.UnacceptableStatusCode(URLResponse.statusCode, error))
        }

        guard let response = responseFromObject(object, URLResponse: URLResponse) else {
            return .Failure(.InvalidResponseStructure(object))
        }

        return .Success(response)
    }
}
