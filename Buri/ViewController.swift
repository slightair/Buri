import Cocoa

class ViewController: NSViewController {
    var twitterAuthViewController = TwitterAuthViewController.defaultViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChildViewController(self.twitterAuthViewController);

        self.twitterAuthViewController.authenticate { result in
            switch result {
            case .Success(let credential, let parameters):
                print(credential)
                print(parameters)

                let request = GetHomeTimelineRequest(credential: credential)
                Twitter.sendRequest(request) { result in
                    switch result {
                    case .Success(let result):
                        print(result)
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
