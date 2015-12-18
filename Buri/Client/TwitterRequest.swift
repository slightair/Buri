import Foundation
import APIKit
import OAuthSwift

protocol TwitterRequest: RequestType {
    var TwitterCredential: OAuthSwiftCredential! { get set }
}

extension TwitterRequest {
    var baseURL: NSURL {
        return NSURL(string: "https://api.twitter.com")!
    }

    func OAuthSwiftRequestMethod(method: String) -> OAuthSwiftHTTPRequest.Method {
        switch method {
        case "POST":
            return .POST
        case "PUT":
            return .PUT
        case "DELETE":
            return .DELETE
        case "PATCH":
            return .PATCH
        case "HEAD":
            return .HEAD
        default:
            return .GET
        }
    }

    func paramerters(URL: NSURL) -> [String: AnyObject] {
        let URLComponents = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false)
        var parameters: [String: AnyObject] = [:]
        if let components = URLComponents, queryItems = components.queryItems {
            for queryItem in queryItems {
                parameters[queryItem.name] = queryItem.value
            }
        }
        return parameters
    }

    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        let headers = TwitterCredential?.makeHeaders(URLRequest.URL!,
            method: self.OAuthSwiftRequestMethod(URLRequest.HTTPMethod),
            parameters: self.paramerters(URLRequest.URL!))

        for (field, value) in headers! {
            URLRequest.setValue(value, forHTTPHeaderField: field)
        }

        return URLRequest
    }
}
