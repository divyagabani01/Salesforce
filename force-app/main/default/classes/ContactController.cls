public with sharing class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        try {
            // Simulate an error by throwing an AuraHandledException
            throw new AuraHandledException('Simulated error for testing');
            
            // Normally, this query would be used:
            // return [SELECT FirstName, LastName, Email FROM Contact];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving contacts: ' + e.getMessage());
        }
    }
}
