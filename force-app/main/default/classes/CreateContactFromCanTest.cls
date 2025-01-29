@IsTest
public class CreateContactFromCanTest {
		@testSetup
        static void setupTestData(){
			// Create 'Recruiting' Account
        Account recruitingAcct = new Account(Name = 'Recruiting');
        insert recruitingAcct;

         	List<Candidate__c> candidateList =  new List<Candidate__c>();
            for(Integer i = 0;i<2;i++){
                candidateList.add(new Candidate__c(First_Name__c = 'Pihu' + i,Last_Name__c ='Savani'+i,Email__c='abc+'+i+'@gmail.com'));
            }   
			
			insert candidateList;
			System.debug('candidateList ===>' + candidateList);
        }
		@IsTest
    static void CreateContactFromCan(){
        List<Candidate__c> candsFromTrigger = [Select Id,First_Name__c,Last_Name__c,Email__c from Candidate__c];
        Test.startTest();
        	CreateContactFromCan.createContact(candsFromTrigger);
        Test.stopTest();
    }
}