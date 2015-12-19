import Foundation
import KeychainAccess
import Result

class TwitterAccountStore {
    static let sharedStore = TwitterAccountStore()
    private static let keyChainServiceName = [NSBundle.mainBundle().bundleIdentifier!, "twitter-account"].joinWithSeparator(".")

    let keychain = Keychain(service: keyChainServiceName)

    func loadAcccounts() -> [TwitterAccount] {
        var accounts: [TwitterAccount] = []
        for key in keychain.allKeys() {
            guard let data = try? self.keychain.getData(key) else {
                continue
            }
            guard let account = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? TwitterAccount else {
                continue
            }
            accounts.append(account)
        }
        return accounts
    }

    func addAccount(account: TwitterAccount) {
        let appName = NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"]!
        let label = "\(appName) TwitterAccount (\(account.screenName))"

        try! keychain
            .label(label)
            .set(NSKeyedArchiver.archivedDataWithRootObject(account), key: account.userID)
    }
}
