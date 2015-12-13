import Cocoa
import Accounts
import Social

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, completion: { granted, error in
            if granted {
                if let accounts = accountStore.accountsWithAccountType(accountType) {
                    print(accounts)

                    let account = accounts.first as! ACAccount
                    let timelineURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!
                    let params: [NSString: AnyObject] = [:]
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: timelineURL, parameters: params)
                    request.account = account
                    request.performRequestWithHandler { responseData, response, error in
                        let timeline = try! NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(rawValue: 0))
                        print(timeline)
                    }
                }
            }
        })
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
