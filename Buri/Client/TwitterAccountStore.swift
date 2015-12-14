import Foundation
import Accounts
import Result

class TwitterAccountStore {
    let accountStore = ACAccountStore()
    let accountType: ACAccountType

    init() {
        accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    }

    func loadAcccounts(handler: (Result<[ACAccount], NSError>) -> Void) {
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, completion: { granted, error in
            guard granted else {
                handler(.Failure(error))
                return
            }

            let accounts = self.accountStore.accountsWithAccountType(self.accountType) as! [ACAccount]
            handler(.Success(accounts))
        })
    }
}
