import Foundation
import Social
import Himotoki

struct GetUserTimelineRequest: TwitterAPIRequestType {
    typealias Response = [Tweet]

    var method: SLRequestMethod {
        return .GET
    }

    var path: String {
        return "/1.1/statuses/user_timeline.json"
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
