public class UpdateColorNameWiseColorValue {
    public static void setValueColorWise(){
        Map<String,Decimal> StaticValueMap = new Map<String,Decimal>();
		List<Account> updateAccountList = new List<Account>();
		Map<String,List<Id>> accountIdMap = new Map<String,List<Id>>();
        //Staticvalue__c StaticRecords = [Select Color_Name__c,Color_Value__c from Staticvalue__c];
        //System.debug('Static Records ======>' + StaticRecords);
        for(Staticvalue__c staticList : [Select Color_Name__c,Color_Value__c from Staticvalue__c]){
            if(!StaticValueMap.containsKey(staticList.Color_Name__c)){
				StaticValueMap.put(staticList.Color_Name__c,staticList.Color_Value__c);
            }
			
        }
    	System.debug('StaticValueMap =====> ' + StaticValueMap);
        if(!StaticValueMap.isEmpty()){
            for(Account acc : [Select Color_Name__c,Color_Value__c from Account]){
                if(StaticValueMap.containsKey(acc.Color_Name__c)){
                    acc.Color_Value__c = StaticValueMap.get(acc.Color_Name__c);
					updateAccountList.add(acc);
                }
                if(!accountIdMap.containsKey(acc.Color_Name__c)){
                    accountIdMap.put(acc.Color_Name__c,new List<Id>{acc.Id});
                }else{
                    if(accountIdMap.containsKey(acc.Color_Name__c)){
                        accountIdMap.get(acc.Color_Name__c).add(acc.Id);
                    }
                }
            }            	
        }
		System.debug('ids ======> ' + accountIdMap);
		List<Staticvalue__c> updateStaticList = new List<Staticvalue__c>();
        if(!accountIdMap.isEmpty()){
            for(Staticvalue__c staticRecords : [Select Color_Name__c,Account_Id__c from Staticvalue__c]){
				staticRecords.Account_Id__c = String.join(accountIdMap.get(staticRecords.Color_Name__c),',');
				updateStaticList.add(staticRecords);
			}
            
        }
        try{
			System.debug('updateAccountList =======> ' + updateAccountList);
			System.debug('updateStaticList =======> ' + updateStaticList);
            update updateAccountList;
			update updateStaticList;
        }catch(Exception e){
            System.debug('Error Message ======> ' + e.getMessage());
        }
    
    }
}