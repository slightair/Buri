import WebKit
import OAuthSwift
import Result

class TwitterAuthViewController: NSViewController, OAuthSwiftURLHandlerType {
    @IBOutlet weak var webView: WebView!

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

    func authenticate(handler: (Result<(OAuthSwiftCredential, [String: String]), NSError>) -> Void) {
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
                handler(.Success((credential, parameters)))
            },
            failure: { error in
                handler(.Failure(error))
            }
        )
    }
}
