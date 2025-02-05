public class AddDynamicContacts {
    
    // Main method to insert Account and Contacts
    @AuraEnabled
    public static Account InsertAccountRecord(String jsonString) {
        AccountWrapper account = (AccountWrapper) JSON.deserialize(jsonString, AccountWrapper.class);
        System.debug('jsonString ====== ' + jsonString);
        Account acc = new Account();
        acc.Name = account.Name;
        acc.Phone = account.Phone;
        acc.BillingStreet = account.BillingStreet;
        acc.BillingCity = account.BillingCity;
        acc.BillingState = account.BillingState;
        acc.BillingPostalCode = account.BillingPostalCode;
        acc.BirthofDate__c = account.BirthDate;
        acc.Active__c = account.IsActive;
        acc.Type = account.Type;
        acc.Account_Email__c = account.Email;
        try {
            insert acc; // Insert Account record
            // generateAndAttachPDF(acc.Id);
            // Handle Contacts
            //List<Contact> contactsToInsert = new List<Contact>();
            // for (Integer i = 0; i < account.NumberOfContact; i++) {
            //    Contact con = new Contact();
            //     con.LastName = account.Name + ' ' + (i + 1);
            //    con.AccountId = acc.Id;
            //    contactsToInsert.add(con);
            // }
            // if (!contactsToInsert.isEmpty()) {
            //insert contactsToInsert;
            //System.debug('@@@@contactsToInsert' + contactsToInsert);
            //}
            // Handle Files (serialize file data into JSON and call future method)
            // Handle file uploads
            if (account.files != null && !account.files.isEmpty()) {
                // Serialize files into JSON string
                String filesDataJson = JSON.serialize(account.files);
                // Call future method for asynchronous file upload
                handleFilesInsert(filesDataJson, acc.Id);
            }		return acc;
        } catch (Exception e) {
            System.debug('Error inserting Account or Files: ' + e.getMessage());
            throw new AuraHandledException('Unable to create Account or Files');
        }
    }
    
    public static void generateAndAttachPDF(Id recordId,String title) {
        // Get the PDF content
        PageReference pdfPage = new PageReference('/apex/AxisNanoEKYCDataPDF?id=' + recordId);
        Blob pdfBlob = pdfPage.getContent();
        // Alternatively, 
        //PageReference pdf = Page.YourVisualforcePageName
        
        // potentially add any query string parameters here
        //  pdf.getParameters().put('id',accountId);
        
        // the contents of the report in pdf form
        //  Blob body;
        
        //  try {
        
        // returns the output of the page as a PDF
        //   body = pdf.getContent();
        // } catch (VisualforceException e) {//
        //     body = Blob.valueOf('PDF Get Failed');
        // }
        // pageRef = new PageReference('/apex/Question');
        //pageRef.setRedirect(true);
        //pageRef.getParameters().put('question',nextQuestionId);
        //pageRef.getParameters().put('filter',filter);
        //pageRef.getParameters().put('questionBank',questionBankId);
        System.debug('pdfBlob ====' + pdfBlob);
        // Create ContentVersion (File)
        ContentVersion contentVer = new ContentVersion();
        contentVer.Title = title + '.pdf';
        contentVer.PathOnClient = title + '.pdf';
        contentVer.VersionData = pdfBlob;
        contentVer.ContentLocation = 'S';
        contentVer.FirstPublishLocationId = recordId;
        if(contentVer != null){
            insert contentVer;
        }
        
        
    }
    
    // Future method to handle file insertion asynchronously
    @Future(callout=true)
    public static void handleFilesInsert(String filesDataJson, String accountId) {
        try {
            // Deserialize the JSON string back into a list of FileWrapper objects
            List<AccountWrapper.FileWrapper> files = (List<AccountWrapper.FileWrapper>) JSON.deserialize(filesDataJson, List<AccountWrapper.FileWrapper>.class);
            
            // Prepare ContentVersion records
            List<ContentVersion> contentVersions = new List<ContentVersion>();
            for (AccountWrapper.FileWrapper file : files) {
                ContentVersion contentVersion = new ContentVersion();
                contentVersion.Title = file.Name;
                contentVersion.PathOnClient = file.Name;
                contentVersion.VersionData = EncodingUtil.base64Decode(file.base64Data);
                contentVersion.FirstPublishLocationId   = accountId; // Link to Account
                contentVersion.ParentId__c = accountId;
                contentVersions.add(contentVersion);
            }
            // Insert ContentVersion records
            if (!contentVersions.isEmpty()) {
                insert contentVersions;
                System.debug('accountId' + accountId);
                generateAndAttachPDF(accountId,contentVersions[0].Title);
            }
        } catch (Exception e) {
            System.debug('Error inserting ContentVersion records: ' + e.getMessage());
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