public class PropertyUtility {
    public static void newListedProperties(){
        //List<Property__c> newPropList = [SELECT Name, Broker__r.Email__c, CreatedDate FROM Property__c WHERE CreatedDate >= LAST_N_DAYS:30];
        //List<Property__c> newPropList = [SELECT Name, Broker__r.Email__c, CreatedDate FROM Property__c];
		List<Property__c> newPropList = [SELECT Name, Broker__r.Email__c, Days_On_Market__c FROM Property__c WHERE Date_Listed__c = LAST_N_DAYS:30];
		System.debug('newPropList ====> ' + newPropList);
        for(Property__c prop : newPropList){     
            // Concatenate the property name, broker's email, and days on market
            String propEmail = prop.Name + ':' + prop.Broker__r.Email__c;
            
            // Print the concatenated string to the debug log
            System.debug('propEmail =====> ' + propEmail);
        }
    }
}