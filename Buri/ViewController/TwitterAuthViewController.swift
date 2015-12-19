import WebKit
import OAuthSwift
import Result

class TwitterAuthViewController: NSViewController, OAuthSwiftURLHandlerType {
    @IBOutlet weak var webView: WebView!

    static let errorDomain = [NSBundle.mainBundle().bundleIdentifier!, "TwitterAuthViewControllerError"].joinWithSeparator(".")

    static func defaultViewController() -> TwitterAuthViewController {
        return NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("TwitterAuth") as! TwitterAuthViewController
    }

    func handle(url: NSURL) {
        func presentAuthWebPage() {
            self.parentViewController?.presentViewControllerAsSheet(self)

            let request = NSURLRequest(URL: url)
            self.webView.mainFrame.loadRequest(request)
        }

        if NSThread.isMainThread() {
            presentAuthWebPage()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                presentAuthWebPage()
            }
        }
    }

    func authenticate(handler: (Result<TwitterAccount, NSError>) -> Void) {
        let oauthswift = OAuth1Swift(
            consumerKey: TwitterTokens.ConsumerKey,
            consumerSecret: TwitterTokens.ConsumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token"
        )
        oauthswift.authorize_url_handler = self
        oauthswift.authorizeWithCallbackURL( NSURL(string: "buri://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                self.parentViewController?.dismissViewController(self)

                guard let userID = parameters["user_id"], screenName = parameters["screen_name"] else {
                    let error = NSError(domain: TwitterAuthViewController.errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid response"])
                    handler(.Failure(error))
                    return
                }

                let newAccount = TwitterAccount(userID: userID, screenName: screenName, credential: credential)
                handler(.Success(newAccount))
            },
            failure: { error in
                self.parentViewController?.dismissViewController(self)

                handler(.Failure(error))
            }
        )
    }
}
