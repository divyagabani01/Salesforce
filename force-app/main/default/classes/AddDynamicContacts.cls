public class AddDynamicContacts {
	@future
    @AuraEnabled(cacheable=true)
      public static void InsertAccountRecord(String jsonString) {
        System.debug('jsonString ===>' + jsonString);
        AccountWrapper account;
    
        try {
            // Deserialize the JSON string into the wrapper class
            account = (AccountWrapper) JSON.deserialize(jsonString, AccountWrapper.class);
        } catch (Exception e) {
            System.debug('Deserialization error: ' + e.getMessage());
            throw new AuraHandledException('Error deserializing JSON string');
        }
    
        Account acc = new Account();
        acc.Name = account.Name;
        acc.BillingStreet = account.BillingStreet;
        acc.BillingCity = account.BillingCity;
        acc.BillingState = account.BillingState;
        acc.Phone = account.Phone;
        acc.BillingPostalCode = account.BillingPostalCode;
        acc.number_of_contact_field__c = account.NumberOfContact;
    
        System.debug('acc' + acc);
    
        try {
            // Insert Account record
            insert acc;
            if(acc.Id != ''){
                 // Bulkify and handle dynamic contacts
            List<Contact> contactsToInsert = new List<Contact>();
            for (Integer i = 0; i < account.NumberOfContact; i++) {
                Contact con = new Contact();
                con.LastName = account.Name + ' ' + (i + 1);
                con.AccountId = acc.Id;
                contactsToInsert.add(con); 
            }
    
            if (!contactsToInsert.isEmpty()) {
                insert contactsToInsert;
            }
			}
           
    
            //return acc;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            throw new AuraHandledException('Unable to create Account and Contacts');
        }
    }

    
  @AuraEnabled
    @future
    public static void updateAccountRecord(String jsonString) {
        System.debug('jsonString =====> ' + jsonString);

        UpdateAccountWrapper accountWrapper;
        try {
            accountWrapper = (UpdateAccountWrapper) JSON.deserialize(jsonString, UpdateAccountWrapper.class);
        } catch (Exception ex) {
            System.debug('Error in deserialization: ' + ex.getMessage());
            throw new AuraHandledException('Invalid JSON format or structure.');
        }

        if (String.isBlank(accountWrapper.Id)) {
            throw new AuraHandledException('Account Id is required for updating the record.');
        }

        Account acc;
        try {
            acc = [SELECT Id, Name, Type, Phone, Website,Active__c FROM Account WHERE Id = :accountWrapper.Id LIMIT 1];
        } catch (Exception ex) {
            System.debug('Error retrieving Account: ' + ex.getMessage());
            throw new AuraHandledException('Error retrieving the Account record.');
        }

        // Only update the record if necessary
        if (acc.Name != accountWrapper.Name ||
            acc.Type != accountWrapper.Type ||
            acc.Phone != accountWrapper.Phone ||
            acc.Website != accountWrapper.Website || acc.Active__c != accountWrapper.Active) {
            
            acc.Name = accountWrapper.Name;
            acc.Type = accountWrapper.Type;
            acc.Phone = accountWrapper.Phone;
            acc.Website = accountWrapper.Website;
                acc.Active__c = accountWrapper.Active;
			System.debug('Account ' + acc);
            try {
                update acc; // Perform a single DML operation
            } catch (DmlException dmlEx) {
                System.debug('DML Exception occurred: ' + dmlEx.getMessage());
                throw new AuraHandledException('Unable to update the Account record: ' + dmlEx.getMessage());
            } catch (Exception ex) {
                System.debug('General Exception occurred: ' + ex.getMessage());
                throw new AuraHandledException('An unexpected error occurred while updating the Account.');
            }
        }
    }

    @AuraEnabled
    public static void deleteAccountRecord(Id accountId) {
        System.debug('accountId' + accountId);
			List<Opportunity> oppRecordsToDelete = [SELECT Id,AccountId FROM Opportunity WHERE AccountId = :accountId];
        if(!oppRecordsToDelete.isEmpty()){
            delete oppRecordsToDelete;
        }
            List<Account> recordsToDelete = [SELECT Id FROM Account WHERE Id = :accountId];
            System.debug('recordsToDelete ======>' + recordsToDelete);
          try {
                delete recordsToDelete;
            } catch (Exception e) {
                System.debug('Error deleting records: ' + e.getMessage());
                throw new AuraHandledException('Error deleting records: ' + e.getMessage());
            }
    }
    
     @AuraEnabled
    public static void ActiveAccount(Id accountId,String Active) {
        System.debug('accountId' + accountId);
        	Account acc = new Account();
        	acc.Id = accountId;
        	acc.Active__c = Active;
        	System.debug('ACc ' + acc);
          try {
                update acc;
            } catch (Exception e) {
                System.debug('Error deleting records: ' + e.getMessage());
                throw new AuraHandledException('Error deleting records: ' + e.getMessage());
            }
    }
    
    
    public class UpdateAccountWrapper {
        public String Id { get; set; }
        public String Name { get; set; }
        public String Phone { get; set; }
        public String Website { get; set; }
        public String Type { get; set; }
        public String Active { get; set; }
    }


    public static void AddDynamicContact(Integer NumberOfContact, String AccountName, String AccountId) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= NumberOfContact; i++) {
            Contact con = new Contact();
            con.LastName = AccountName + i;
            con.AccountId = AccountId;
            contacts.add(con);
        }
        try {
            // Insert all contacts in a single DML statement
            insert contacts;
            System.debug('Inserted Contact Record ======> ' + contacts);
        } catch (DmlException e) {
            System.debug('The following exception has occurred while inserting contacts: ' + e.getMessage());
            throw new AuraHandledException('Unable to create Contacts');
        }
    }

	 public static void InsertContactRecord(String LastName) {
  		Contact con = new Contact();
			con.LastName = LastName;
              try {
            // Insert all contacts in a single DML statement
            insert con;
            System.debug('Inserted Contact Record ======> ' + con);
        } catch (DmlException e) {
            System.debug('The following exception has occurred while inserting contacts: ' + e.getMessage());
            throw new AuraHandledException('Unable to create Contacts');
        }
    }
}