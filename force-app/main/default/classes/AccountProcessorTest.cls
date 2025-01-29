@IsTest
public class AccountProcessorTest {
	@TestSetup
    static void loadTestData(){
        List<Account> InsertAccount = new List<Account>();
		List<Contact> InsertContact = new List<Contact>();
        for(Integer i = 0;i<5;i++){
            InsertAccount.add(new Account(Name = 'Testing - ' + i));
        }
        if(!InsertAccount.isEmpty()){
            insert InsertAccount;
			
			 for(Account acc : InsertAccount){
				Integer ContactCount = acc.Name  == 'Testing - 0' ? 1 : 2;
                 for(Integer i = 0; i< 2;i++){
                     InsertContact.add(new Contact(LastName = 'Testing' + i,AccountId = acc.Id));
                 }
        	}
        }
        if(!InsertContact.isEmpty()){
            insert InsertContact;
        }
    }
	@IsTest
    static void testCountContacts(){
        List<Account> getAccounts = [Select Id from Account];
        Set<Id> accountIds = new Set<Id>();
        for(Account acc: getAccounts){
            if(acc.Id != null){
                accountIds.add(acc.Id);
            }
        }
		
		Test.startTest();
        	AccountProcessor.countContacts(accountIds);
		Test.stopTest();

    }
}