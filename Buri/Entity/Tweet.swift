import Foundation
import Himotoki
import Mustache

struct Tweet {
    let id: Int64
    let screenName: String
    let userProfileImageURL: NSURL
    let text: String
}

extension Tweet: Decodable {
    static func decode(e: Extractor) throws -> Tweet {
        return try Tweet(
            id: e <| "id",
            screenName: e <| ["user", "screen_name"],
            userProfileImageURL: NSURL(string: e <| ["user", "profile_image_url_https"])!,
            text: e <| "text"
        )
    }
}

extension Tweet: MustacheBoxable {
    var mustacheBox: MustacheBox {
        return Box([
            "id": String(id),
            "screen_name": screenName,
            "user_profile_image_url": userProfileImageURL,
            "text": text,
            ])
    }
}
