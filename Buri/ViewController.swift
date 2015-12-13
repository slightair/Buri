import Cocoa
import OAuthSwift

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let oauthswift = OAuth1Swift(
            consumerKey: TwitterTokens.ConsumerKey,
            consumerSecret: TwitterTokens.ConsumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "buri://oauth-callback/twitter")!, success: { credential, response, parameters in
//                print(credential)
            }, failure: { error in
                fatalError(error.localizedDescription)
            }
        )
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
