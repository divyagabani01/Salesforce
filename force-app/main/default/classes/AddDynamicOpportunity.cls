public class AddDynamicOpportunity {
 @AuraEnabled(cacheable=true)
	@future
      public static void InsertOppRecord(String jsonString) {
        System.debug('jsonString ===>' + jsonString);
        OpportunityWrapper opportunity;
    
        try {
            // Deserialize the JSON string into the wrapper class
            opportunity = (OpportunityWrapper) JSON.deserialize(jsonString, OpportunityWrapper.class);
        } catch (Exception e) {
            System.debug('Deserialization error: ' + e.getMessage());
            throw new AuraHandledException('Error deserializing JSON string');
        }
    
        Opportunity opp = new Opportunity();
        opp.Name = opportunity.Name;
        opp.Amount = opportunity.Amount;
        opp.CloseDate = opportunity.CloseDate;
        opp.Probability = opportunity.Probability;
        opp.StageName = opportunity.StageName;
    
        System.debug('opp' + opp);
    
        try {
            // Insert Account record
            insert opp;
        
            //return acc;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            throw new AuraHandledException('Unable to create Account and Contacts');
        }
    }

    
  @AuraEnabled
    @future
    public static void updateOpportunityRecord(String jsonString) {
        System.debug('jsonString =====> ' + jsonString);

        UpdateOpportunityWrapper OpportunityWrapper;
        try {
            OpportunityWrapper = (UpdateOpportunityWrapper) JSON.deserialize(jsonString, UpdateOpportunityWrapper.class);
        } catch (Exception ex) {
            System.debug('Error in deserialization: ' + ex.getMessage());
            throw new AuraHandledException('Invalid JSON format or structure.');
        }

        if (String.isBlank(OpportunityWrapper.Id)) {
            throw new AuraHandledException('Account Id is required for updating the record.');
        }

        Opportunity opp;
        try {
            opp = [SELECT Id, Name, Amount, CloseDate, Probability,StageName FROM Opportunity WHERE Id = :OpportunityWrapper.Id LIMIT 1];
        } catch (Exception ex) {
            System.debug('Error retrieving Account: ' + ex.getMessage());
            throw new AuraHandledException('Error retrieving the Account record.');
        }

        // Only update the record if necessary
        if (opp.Name != OpportunityWrapper.Name ||
            opp.Amount != OpportunityWrapper.Amount ||
            opp.CloseDate != OpportunityWrapper.CloseDate ||
            opp.Probability != OpportunityWrapper.Probability || opp.StageName != OpportunityWrapper.StageName) {
            
            opp.Name = OpportunityWrapper.Name;
            opp.Amount = OpportunityWrapper.Amount;
            opp.CloseDate = OpportunityWrapper.CloseDate;
            opp.Probability = OpportunityWrapper.Probability;
            opp.StageName = OpportunityWrapper.StageName;
			System.debug('Oppo ' + opp);
            try {
                update opp; // Perform a single DML operation
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
    public static void deleteOpportunityRecord(Id opportunityId) {
        System.debug('opportunityId' + opportunityId);
			List<Opportunity> oppRecordsToDelete = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];
        if(!oppRecordsToDelete.isEmpty()){
            delete oppRecordsToDelete;
        }
            List<Opportunity> recordsToDelete = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];
            System.debug('recordsToDelete ======>' + recordsToDelete);
          try {
                delete recordsToDelete;
            } catch (Exception e) {
                System.debug('Error deleting records: ' + e.getMessage());
                throw new AuraHandledException('Error deleting records: ' + e.getMessage());
            }
    }
    

    
    
    public class UpdateOpportunityWrapper {
        public String Id { get; set; }
        public String Name { get; set; }
        public Decimal Amount { get; set; }
          public Date CloseDate { get; set; }
          public Decimal Probability { get; set; }
          public String StageName { get; set; }
    }

}