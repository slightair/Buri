import Foundation
import Himotoki

struct Tweet: Decodable {
    let id: Int64
    let text: String

    static func decode(e: Extractor) throws -> Tweet {
        return try Tweet(
            id: e <| "id",
            text: e <| "text"
        )
    }
}
