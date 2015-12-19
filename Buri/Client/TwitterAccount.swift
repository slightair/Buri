import Foundation
import OAuthSwift

class TwitterAccount: NSObject, NSCoding {
    let userID: String
    let screenName: String
    let credential: OAuthSwiftCredential

    init(userID: String, screenName: String, credential: OAuthSwiftCredential) {
        self.userID = userID
        self.screenName = screenName
        self.credential = credential
    }

    private struct CodingKeys {
        static func keyFor(name: String) -> String {
            return [base, name].joinWithSeparator(".")
        }

        static let base = NSBundle.mainBundle().bundleIdentifier!
        static let userID = CodingKeys.keyFor("userID")
        static let screenName = CodingKeys.keyFor("screenName")
        static let credential = CodingKeys.keyFor("credential")
    }

    required init?(coder decoder: NSCoder) {
        self.userID = decoder.decodeObjectForKey(CodingKeys.userID) as? String ?? String()
        self.screenName = decoder.decodeObjectForKey(CodingKeys.screenName) as? String ?? String()
        self.credential = decoder.decodeObjectForKey(CodingKeys.credential) as? OAuthSwiftCredential ?? OAuthSwiftCredential(consumer_key: TwitterTokens.ConsumerKey, consumer_secret: TwitterTokens.ConsumerSecret)
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.userID, forKey: CodingKeys.userID)
        coder.encodeObject(self.screenName, forKey: CodingKeys.screenName)
        coder.encodeObject(self.credential, forKey: CodingKeys.credential)
    }
}
