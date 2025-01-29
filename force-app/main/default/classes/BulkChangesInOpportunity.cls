public class BulkChangesInOpportunity {
    public static void bulkChanges(){
        List<Opportunity> oppList = new List<Opportunity>();

        for(Opportunity opp : [Select Id,Name,StageName from Opportunity where StageName = 'Value Proposition']){
            opp.StageName = 'Closed Won';
			oppList.add(opp);
        }
        if(!oppList.isEmpty()){
            update oppList;
        }
    }
}