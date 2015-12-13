import Cocoa
import OAuthSwift

class ViewController: NSViewController {
    var twitterAuthViewController: TwitterAuthViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.twitterAuthViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("TwitterAuth") as? TwitterAuthViewController
        self.addChildViewController(self.twitterAuthViewController);

        let oauthswift = OAuth1Swift(
            consumerKey: TwitterTokens.ConsumerKey,
            consumerSecret: TwitterTokens.ConsumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token"
        )
        oauthswift.authorize_url_handler = self.twitterAuthViewController
        oauthswift.authorizeWithCallbackURL( NSURL(string: "buri://oauth-callback/twitter")!, success: { credential, response, parameters in
                self.dismissViewController(self.twitterAuthViewController)
                print(credential)
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
