@IsTest
public class AccountBasedOpportunityStageAndTypeTest {
		@testSetup
        static void setupTestData() {
            // Create test Account records
            Account acc1 = new Account(Name = 'Account 1');
            Account acc2 = new Account(Name = 'Account 2');
            Account acc3 = new Account(Name = 'Account 3');
            insert new List<Account>{ acc1, acc2, acc3 };
    
            // Create test Opportunity records
            Opportunity opp1 = new Opportunity(Name = 'Opportunity 1', StageName = 'Value Proposition', Type = 'Existing Customer - Replacement', AccountId = acc1.Id, CloseDate = Date.today());
            Opportunity opp2 = new Opportunity(Name = 'Opportunity 2', StageName = 'Perception Analysis', Type = 'Existing Customer - Downgrade', AccountId = acc2.Id, CloseDate = Date.today());
            Opportunity opp3 = new Opportunity(Name = 'Opportunity 3', StageName = 'Value Proposition', Type = 'Existing Customer - Downgrade', AccountId = acc3.Id, CloseDate = Date.today());
            Opportunity opp4 = new Opportunity(Name = 'Opportunity 4', StageName = 'Value Proposition', Type = 'Existing Customer - Replacement', AccountId = acc1.Id, CloseDate = Date.today());
            insert new List<Opportunity>{ opp1, opp2, opp3, opp4 };
        }

		@IsTest
        static void testCountContacts(){
			List<Opportunity> OpportunityList = [SELECT Id,Account.Name,StageName,Type FROM Opportunity where StageName != null and Type != null and Account.Name != null];
			System.debug('OpportunityList' + OpportunityList);
            Test.startTest();
               Map<string,List<String>> opportunintyMap = AccountBasedOpportunityStageAndType.getOpportunityStageAndype(OpportunityList);
				System.debug('opportunintyMap ========>' + opportunintyMap);
				List<Opportunity> OpportunityList1 = [SELECT Id,Account.Name,StageName,Type FROM Opportunity where StageName = null];
            	System.debug('OpportunityList1 ========>' + OpportunityList1);
				AccountBasedOpportunityStageAndType.getOpportunityStageAndype(OpportunityList1);
				System.debug('resulat'+ AccountBasedOpportunityStageAndType.getOpportunityStageAndype(OpportunityList1));
                // Using System.assert to check if the result is null
               System.assert(AccountBasedOpportunityStageAndType.getOpportunityStageAndype(OpportunityList1) == null, 'The result should be null');
            Test.stopTest();
    
        }
}