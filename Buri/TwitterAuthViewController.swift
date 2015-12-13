import WebKit
import OAuthSwift

class TwitterAuthViewController: NSViewController, OAuthSwiftURLHandlerType {
    @IBOutlet weak var webView: WebView!

    func handle(url: NSURL) {
        func presentAuthWebPage() {
            if let parentViewController = self.parentViewController {
                parentViewController.presentViewControllerAsSheet(self)
            }

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
}
