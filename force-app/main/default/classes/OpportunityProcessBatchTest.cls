@isTest
public class OpportunityProcessBatchTest {
    
    @testSetup
    static void setup() {
        List<String> CountryList = new List<String>{'Afghanistan','Canada','Mexico','India'};
            List<Opportunity> opportunities = new List<Opportunity>();
            for(Integer i =0;i < 200; i++){
        		opportunities.add(new Opportunity(Name = 'Opportunity' + i , StageName = 'Closed Won', Country__c = i < 4 ? CountryList[i] : i >=4 && i < 50 ? CountryList[3] : i > 50 && i < 100 ? CountryList[2] : CountryList[1] , Is_Short_Country_Inserted__c = false, CloseDate = Date.today(),Country_Short_Name__c = null));        
            }
        
       System.debug('opportunities =====>' + opportunities);
        insert opportunities;
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        // Execute the batch job
		System.debug('Start');
		Database.executeBatch(new OpportunityProcessBatch(), 50);
        Test.stopTest();
        
    }
    
}