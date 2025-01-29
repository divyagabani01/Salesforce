public class opportunityBasedOnStageName {
    public static Map<String,List<String>> getStageWiseOpportunity(List<Opportunity> OpportunityList){
        Map<String,List<String>> opportunityMap = new Map<String,List<String>>();
		//List<Opportunity> OpportunityList = [Select Name,StageName,CloseDate FROM Opportunity];
        for(Opportunity opp : OpportunityList){ 
            if(!opportunityMap.containsKey(opp.StageName)){
                opportunityMap.put(opp.StageName,new List<String>{opp.Name});
            }else{
                opportunityMap.get(opp.StageName).add(opp.Name);
            }
        }
		System.debug('opportunityMap ======>' + opportunityMap);
        if(!opportunityMap.isEmpty()){
            return opportunityMap;
        }
        return null;    
    }
}