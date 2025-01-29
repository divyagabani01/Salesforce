@IsTest
public class NewAccountsTest {
		@testSetup
        static void setupTestData(){
        		List<Account> account = new List<Account>();
            for(Integer i =0 ; i<3;i++){
                	account.add(new Account(Name = 'account' + i));
            }
			insert account;
        }
    	@IsTest
    static void NewAccounts(){
        	Test.startTest();
        		NewAccounts.sObjectsInsert(3);
        	Test.StopTest();
    }
}