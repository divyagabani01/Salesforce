@IsTest
public 	class OlderAccountsUtilityTest {
		@testSetup
        static void setupTestData(){
        		List<Account> account = new List<Account>();
                for(Integer i =0 ; i<3;i++){
                        account.add(new Account(Description = 'Heritage Account' + i,Name='account'+i));
                }
                insert account;
        }
		@IsTest
        static void OlderAccountsUtility(){
            Test.startTest();
                OlderAccountsUtility.updateOlderAccounts();
            Test.stopTest();
        }
}