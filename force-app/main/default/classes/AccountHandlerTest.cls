@IsTest
public class AccountHandlerTest {
	@testSetup
        static void setupTestData() {
            Integer counter = 1;
			Integer num = 5;
               List<Account>  addAccounts = new List<Account>();
                while(counter <= num){
                    Account store = new Account();
                    store.Name = 'Acme Incs' + counter;
                    store.AccountNumber = 'A000'+counter;
                    addAccounts.add(store);
                    counter++;
                }
                System.debug('Size of Account List: ' + addAccounts.size() );
                System.debug('Elements in Account List: ' + addAccounts);
                //insert all of the accounts in the list
                insert addAccounts;
        }
	@IsTest
    static void testAccountHandler(){
        Test.startTest();
             AccountHandler.insertAccount(10);
        Test.stopTest();
	}

}