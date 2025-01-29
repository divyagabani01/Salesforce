public class getResumeAccountLink {

    @AuraEnabled
    public static String executeLogic(Id recordId) {
        // Custom logic using the Record ID
        System.debug('Record ID: ' + recordId);
        
        // Query to retrieve the list of OmniScriptSavedSession records
        List<OmniScriptSavedSession> saveSession = [SELECT Id, Name, ResumeUrl, RelatedName, RelatedRecordIdentifier 
                                                    FROM OmniScriptSavedSession 
                                                    WHERE RelatedRecordIdentifier = :recordId];
        
        // Debug the retrieved sessions
        System.debug('saveSession ::: ' + saveSession);
        String resumeUrl; 
        // Check if any records are returned
        if (saveSession != null && !saveSession.isEmpty()) {
        resumeUrl = saveSession[0].ResumeUrl;
        
        

        } else {
            // Return a default message or empty string if no records found
            resumeUrl = 'False';
        }
        return resumeUrl;
		
    }
}