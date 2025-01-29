@IsTest
public class UpdateContactTest {
    @testSetup
        static void setupTestData() { 
			List<Loan_Application__c> LoanApplicationList = new List<Loan_Application__c>();
            for(Integer i = 0;i < 5; i++){
                LoanApplicationList.add(new Loan_Application__c(LastName__c = 'Kukadiya',FirstName__c = 'Nisha',Date_Of_Birth__c = System.Today(),Mobile_Number__c = '789654123'+i));
            }
			insert LoanApplicationList;
        }
    @IsTest 
    static void UpdateContact(){
         Test.startTest();
                UpdateContact.getContact();
          Test.stopTest();
	
    }
}