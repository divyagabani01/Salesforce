public with sharing class PicklistHelper {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getPicklist(String objectName, String fieldName) {
        try {
            System.debug('fieldName: ' + fieldName);
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
            Schema.SObjectField sObjectField = sObjectType.getDescribe().fields.getMap().get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = sObjectField.getDescribe();

            // Get the picklist values
            List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
            List<Map<String, String>> picklistValues = new List<Map<String, String>>();

            System.debug('picklistEntries: ' + picklistEntries);
            for (Schema.PicklistEntry entry : picklistEntries) {
                if (entry.isActive()) {
                    picklistValues.add(new Map<String, String>{
                        'label' => entry.getLabel(),
                        'value' => entry.getValue()
                    });
                }
            }

            System.debug('picklistValues: ' + picklistValues);
            return picklistValues;
        } catch (Exception e) {
            System.debug('Error fetching picklist values: ' + e.getMessage());
            throw new AuraHandledException('Unable to fetch picklist values: ' + e.getMessage());
        }
    }
}