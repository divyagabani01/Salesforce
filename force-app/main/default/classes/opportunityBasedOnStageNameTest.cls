@IsTest
public class opportunityBasedOnStageNameTest {
		@testSetup
        static void setupTestData() { 
            List<Opportunity> opportunity = new List<Opportunity>();
            for (Integer i = 0; i < 3; i++) {
                if(i<1){
                	opportunity.add(new Opportunity(Name = 'Test Account ' + i,StageName = 'Stage' + i,CloseDate = System.Today()));    
                }else{
                    opportunity.add(new Opportunity(Name = 'Test Account ' + i,StageName = 'Stage' + 1,CloseDate = System.Today()));
                }
                
            }
            insert opportunity;
        }
	@IsTest
    static void opportunityBasedOnStageName(){
        List<Opportunity> OpportunityList = [Select Name,StageName,CloseDate FROM Opportunity];
				Test.startTest();
                	opportunityBasedOnStageName.getStageWiseOpportunity(OpportunityList);
					List<Opportunity> OpportunityList1 = [Select Name,StageName,CloseDate FROM Opportunity where StageName = null];
        			opportunityBasedOnStageName.getStageWiseOpportunity(OpportunityList1);
				Test.stopTest();
    }
}