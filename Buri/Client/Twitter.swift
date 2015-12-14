import Foundation
import Accounts
import Result

class Twitter {
    static func sendRequest<T: TwitterAPIRequestType>(account: ACAccount, request: T, handler: (Result<T.Response, TwitterAPIError>) -> Void = {r in}) {
        let slRequest = request.buildSLRequest(account)
        slRequest.performRequestWithHandler { responseData, URLResponse, error in
            let requestResult: Result<(NSData!, NSHTTPURLResponse!), TwitterAPIError>
            if error != nil {
                requestResult = .Failure(.ConnectionError(error))
            } else {
                requestResult = .Success((responseData, URLResponse))
            }

            let result: Result<T.Response, TwitterAPIError> = requestResult.flatMap { data, response in
                request.parseData(data, URLResponse: response)
            }

            handler(result)
        }
    }
}
