@IsTest
public class OpportunityTriggerHandlerTest {
		@testSetup
        static void setupTestData() { 
			List<Account> account = new List<Account>();
            for(Integer i = 0;i < 3; i++){
                account.add(new Account(Name = 'Test' + i));
            }
			insert account;
			List<Opportunity> opportunity = new List<Opportunity>();
            for(Account acc:account){
                for (Integer i = 0; i < 3; i++) {
                    if(i<1){
                        opportunity.add(new Opportunity(Name = 'Test Account ' + i,StageName = 'Stage' + i,CloseDate = System.Today(),AccountId = acc.id));    
                    }else{
                        opportunity.add(new Opportunity(Name = 'Test Account ' + i,StageName = 'Stage' + 1,CloseDate = System.Today(),AccountId = acc.id));
                    }
            	}
            }
            
            
            insert opportunity;
        }
		@IsTest
        static void OpportunityTriggerHandler(){
			Set<Id> accountIds = new Set<Id>();
            for (Account acc : [SELECT Id FROM Account]) {
                accountIds.add(acc.Id);
            }
            Test.startTest();
                OpportunityTriggerHandler.updateAccountOpportunityCounts(accountIds);
            Test.stopTest();
        }
}