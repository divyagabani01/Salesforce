public class DeleteDuplicateContacts {
    public static void removeDuplicateContacts() {
        // Map to track unique contacts by email or name
        Map<String, Contact> uniqueContacts = new Map<String, Contact>();

        // Lists to track records to delete
        List<Contact> contactsToDelete = new List<Contact>();
        List<Task> tasksToDelete = new List<Task>();
        List<Event> eventsToDelete = new List<Event>();

        // Query all contacts with their related tasks and events
        List<Contact> allContacts = [
            SELECT Id, Name, Email, LastName,FirstName,
                   (SELECT Id FROM Tasks), 
                   (SELECT Id FROM Events) 
            FROM Contact Where LastName Like 'Kankotiya'
        ];
		system.debug('allContacts ++++' + allContacts);
        // Process contacts to identify duplicates
        for (Contact con : allContacts) {
            String uniqueKey = con.Email != null ? con.Email : con.Name; // Use email as the key if available, otherwise use name
            if (!uniqueContacts.containsKey(con.Name)) {
                uniqueContacts.put(con.Name, con);
            } else {
                // Collect the duplicate contact for deletion
                contactsToDelete.add(con);

                // Add related tasks and events to delete lists
                tasksToDelete.addAll(con.Tasks);
                eventsToDelete.addAll(con.Events);
            }
        }

        // Delete related tasks
        if (!tasksToDelete.isEmpty()) {
            try {
                delete tasksToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting tasks: ' + e.getMessage());
            }
        }

        // Delete related events
        if (!eventsToDelete.isEmpty()) {
            try {
                delete eventsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting events: ' + e.getMessage());
            }
        }

        // Delete duplicate contacts
        if (!contactsToDelete.isEmpty()) {
            try {
				system.debug('contactsToDelete ' + contactsToDelete);
                delete contactsToDelete;
            } catch (DmlException e) {
                System.debug('Error deleting duplicate contacts: ' + e.getMessage());
            }
        }

        // Additional cleanup: Remove contacts with "(Copy)" in their name
        List<Contact> contactsWithCopy = [SELECT Id FROM Contact WHERE Name LIKE '%(Kankotiya)%'];
        if (!contactsWithCopy.isEmpty()) {
            try {
                delete contactsWithCopy;
            } catch (DmlException e) {
                System.debug('Error deleting contacts with "(Copy)" in their name: ' + e.getMessage());
            }
        }
    }
}