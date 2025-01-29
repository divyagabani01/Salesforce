public class OpportunityStageWiseTaskBatchClass implements Database.Batchable<SObject>, Database.Stateful {
    Map<String, Integer> OpportunityMap = new Map<String, Integer>();

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query for the get all opportunity
        String query = 'SELECT Id, Name, StageName FROM Opportunity WHERE StageName != NULL';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        //Get all opportunity data and set as stagewise opportunity using map
        for (Opportunity opp : scope) {
            if (!OpportunityMap.containsKey(opp.StageName)) {
                OpportunityMap.put(opp.StageName, 1);
            } else {
                OpportunityMap.put(opp.StageName, OpportunityMap.get(opp.StageName) + 1);
            }
        }
    }

    public void finish(Database.BatchableContext BC) {
        List<Task> TaskList = new List<Task>();
		//Create new task stage wise name and also add opportunity count 
        for (String stage : OpportunityMap.keySet()) {
            Integer count = OpportunityMap.get(stage);
            String title = count > 1 ? 'opportunities' : 'opportunity';
            String countStr = String.valueOf(count);
            Task task = new Task();
            task.Subject = stage + ' - Opportunity';
            task.Description = 'There is a total count of ' + countStr + ' ' + title + ' in the ' + stage + ' stage.';
			task.ActivityDate = Date.today();
            task.Opportunity_Count__c = countStr; 
            TaskList.add(task);
        }
        if (!TaskList.isEmpty()) {
            insert TaskList;
        }
    }
}