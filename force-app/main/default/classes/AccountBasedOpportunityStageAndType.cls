public class AccountBasedOpportunityStageAndType {
    public static Map<string,List<String>> getOpportunityStageAndype(List<Opportunity> OpportunityList){
		Map<string,List<String>> opportunintyMap = new Map<string,List<String>>();
		
        System.debug(OpportunityList);
        for(Opportunity opp : OpportunityList){
            if(!opportunintyMap.containsKey(opp.StageName + '_' + opp.Type)){
                opportunintyMap.put(opp.StageName + '_' + opp.Type, new List<String>{opp.Account.Name});
            }else{
                opportunintyMap.get(opp.StageName + '_' + opp.Type).add(opp.Account.Name);
            }
		}

		 // Print all accounts based on opportunity stage and type
        /*for(String stageName : opportunintyMap.keySet()) {
            System.debug('Stage: ' + stageName);
            Map<String, List<String>> typeMap = opportunintyMap.get(stageName);
            
            for(String typeName : typeMap.keySet()) {
                System.debug('  Type: ' + typeName);
                List<String> accountNames = typeMap.get(typeName);
                
                for(String accountName : accountNames) {
                    System.debug('    Account: ' + accountName);
                }
            }
        }*/
		System.debug('opportunityMap =========> ' + opportunintyMap);
        if(!opportunintyMap.isEmpty()){
         	return opportunintyMap;
        }else{
        	return null;    
        }
		
	}
}