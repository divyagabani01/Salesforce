public class getPicklist {
 @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues(String objectName, String fieldName) {
        try {
            // Get the field describe
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
            Schema.SObjectField sObjectField = sObjectType.getDescribe().fields.getMap().get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = sObjectField.getDescribe();
				
            // Get the picklist values
            List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
            List<String> picklistValues = new List<String>();
			system.debug('picklistEntries ====' + picklistEntries);
            for (Schema.PicklistEntry entry : picklistEntries) {
                if (entry.isActive()) {
                    picklistValues.add(entry.getLabel()); // Or use getValue() for API names
                }
            }
            return picklistValues;
        } catch (Exception e) {
            System.debug('Error fetching picklist values: ' + e.getMessage());
            throw new AuraHandledException('Unable to fetch picklist values: ' + e.getMessage());
        }
    }
}