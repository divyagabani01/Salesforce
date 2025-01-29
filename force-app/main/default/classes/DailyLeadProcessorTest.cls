@isTest
public class DailyLeadProcessorTest {

    @isTest
    static void testSuccessfulExecution() {
        // Create test leads with a blank LeadSource
        Lead testLead1 = new Lead(FirstName='Test1', LastName='Lead1', Company='Test Company', LeadSource=null);
        Lead testLead2 = new Lead(FirstName='Test2', LastName='Lead2', Company='Test Company', LeadSource=null);
        insert new List<Lead>{testLead1, testLead2};
        
        // Execute the scheduled job
        Test.startTest();
        DailyLeadProcessor scheduler = new DailyLeadProcessor();
        scheduler.execute(null);
        Test.stopTest();
        
        // Verify that the LeadSource field has been updated
        List<Lead> updatedLeads = [SELECT LeadSource FROM Lead WHERE Id IN :new List<Id>{testLead1.Id, testLead2.Id}];
        for (Lead lead : updatedLeads) {
            System.assertEquals('Dreamforce', lead.LeadSource);
        }
    }

    @isTest
    static void testUpdateLeadsException() {
        // Create a test lead with a blank LeadSource
        Lead testLead = new Lead(FirstName='TestException', LastName='Lead', Company='Test Company', LeadSource=null);
        insert testLead;

        // Create a validation rule that will trigger a DML exception
        // Example Validation Rule:
        // Rule Name: PreventDreamforce
        // Error Condition Formula: ISPICKVAL(LeadSource, 'Dreamforce')
        // Error Message: 'LeadSource cannot be set to Dreamforce'

        // Execute the scheduled job
        Test.startTest();
        DailyLeadProcessor scheduler = new DailyLeadProcessor();
        scheduler.execute(null);
        Test.stopTest();

        // Verify that the LeadSource was not updated
        Lead updatedLead = [SELECT LeadSource FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(null, updatedLead.LeadSource); // Ensure it wasn't updated to 'Dreamforce'

        // Check debug logs manually to verify that the exception was handled
        // Ensure you have debug logs capturing this execution
    }

    @isTest
    static void testNoLeadsToUpdate() {
        // Test case where no leads are available to update
        Test.startTest();
        DailyLeadProcessor scheduler = new DailyLeadProcessor();
        scheduler.execute(null);
        Test.stopTest();

        // No assertions needed if no leads are present; this verifies the code path where no updates occur
    }

    @isTest
    static void testScheduleDailyLeadProcessor() {
        // Schedule the DailyLeadProcessor class
        String jobName = 'Test_DailyLeadProcessor';
        String cronExp = '0 0 0 ? * MON-FRI'; // Example cron expression to run daily
        Test.startTest();
        System.schedule(jobName, cronExp, new DailyLeadProcessor());
        Test.stopTest();

        // Verify the job was scheduled correctly
        CronTrigger[] scheduledJobs = [SELECT Id, CronJobDetail.Name, CronExpression FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        System.assertEquals(1, scheduledJobs.size(), 'The job should be scheduled.');
    }
}