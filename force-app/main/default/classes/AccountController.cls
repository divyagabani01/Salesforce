public class AccountController {
    // Wrapper class to hold account, opportunities, and contacts
    public class AccountWrapper {
        public Account account { get; set; }
        public List<Opportunity> opportunities { get; set; }
        public List<Contact> contacts { get; set; }

        public AccountWrapper(Account account, List<Opportunity> opportunities, List<Contact> contacts) {
            this.account = account;
            this.opportunities = opportunities;
            this.contacts = contacts;
			System.debug('account' + account);
            System.debug('opportunities' + opportunities);
            System.debug('contacts' + contacts);
        }
    }

    // List to hold account wrappers
    public List<AccountWrapper> accountWrapperList { get; set; }

    // Constructor to initialize and populate the account wrapper list
    public AccountController() {
        accountWrapperList = new List<AccountWrapper>();
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities), (SELECT Id, Name, Email FROM Contacts) FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity)
                          AND Id IN (SELECT AccountId FROM Contact)];

        for (Account account : accounts) {
            List<Opportunity> opps = account.Opportunities;
            List<Contact> conts = account.Contacts;
            accountWrapperList.add(new AccountWrapper(account, opps, conts));
        }
    }
}