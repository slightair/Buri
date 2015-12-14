import Cocoa
import Accounts
import Social

class ViewController: NSViewController {
    let accountStore = TwitterAccountStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        accountStore.loadAcccounts { result in
            switch result {
            case .Success(let accounts):
                let account = accounts.first! as ACAccount

                let request = GetHomeTimelineRequest()
                Twitter.sendRequest(account, request: request) { result in
                    switch result {
                    case .Success(let tweets):
                        for tweet in tweets {
                            print(tweet.text)
                        }
                    case .Failure(let error):
                        print(error)
                    }
                }
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
