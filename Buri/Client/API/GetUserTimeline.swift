import Foundation
import APIKit
import OAuthSwift
import Himotoki

struct GetUserTimelineRequest: TwitterRequest {
    typealias Response = [Tweet]

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "/1.1/statuses/user_timeline.json"
    }

    var TwitterCredential: OAuthSwiftCredential!

    init(credential: OAuthSwiftCredential) {
        TwitterCredential = credential
    }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let array = object as? [[String: AnyObject]] else {
            return nil
        }

        guard let tweets: [Tweet] = try! decodeArray(array) else {
            return nil
        }

        return tweets
    }
}
