import Cocoa
import WebKit
import Result
import Mustache

class ViewController: NSViewController {
    @IBOutlet weak var webView: WebView!

    var twitterAuthViewController = TwitterAuthViewController.defaultViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChildViewController(self.twitterAuthViewController);
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        loadContents()
    }

    func loadContents() {
        let accounts = TwitterAccountStore.sharedStore.loadAcccounts()

        if let account = accounts.first {
            loadTimeline(account)
        } else {
            self.addNewAccount { result in
                switch result {
                case .Success(let account):
                    self.loadTimeline(account)
                case .Failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func addNewAccount(handler: (Result<TwitterAccount, NSError>) -> Void) {
        self.twitterAuthViewController.authenticate { result in
            switch result {
            case .Success(let account):
                TwitterAccountStore.sharedStore.addAccount(account)
                handler(.Success(account))
            case .Failure(let error):
                handler(.Failure(error))
            }
        }
    }

    func loadTimeline(account: TwitterAccount) {
        let request = GetHomeTimelineRequest(credential: account.credential)
        Twitter.sendRequest(request) { result in
            switch result {
            case .Success(let result):
                self.updateTimeline(result)
            case .Failure(let error):
                print(error)
            }
        }
    }

    func updateTimeline(tweets: [Tweet]) {
        let template = try? Template(named: "layout")
        if let renderedHTML = try? template?.render(Box(["tweets": Box(tweets)])) {
            self.webView.mainFrame.loadHTMLString(renderedHTML, baseURL: NSBundle.mainBundle().resourceURL)
        }
    }
}
