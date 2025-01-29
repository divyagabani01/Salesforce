public class LoanApplicationHelper {
        public static String getFinancialYear() {
            Integer currentYear = System.today().year();
            Integer startYear;
            Integer endYear;
        
            if (System.today().month() >= 4) {
                startYear = currentYear;
                endYear = currentYear + 1;
            } else {
                startYear = currentYear - 1;
                endYear = currentYear;
            }
        
            return String.valueOf(startYear).substring(2) + String.valueOf(endYear).substring(2);
        }
    public static void setLoanApplicationNumber(List<Loan_Application__c> loanApplications, Map<Id, Loan_Application__c> oldLoanApplications) {
			List<Loan_Application__c> loanApplicationsUpdatedList = new List<Loan_Application__c>();
            Integer currentYear = System.today().year();
            String financialYear = getFinancialYear();
           for (Loan_Application__c loanApp : loanApplications) {
				 Loan_Application__c oldLoanApp = oldLoanApplications.get(loanApp.Id);
                 if (loanApp.Loan_Application_Status__c == 'In Progress' && oldLoanApp != null && oldLoanApp.Loan_Application_Status__c == 'New') {
                    loanApp.Loan_Application_Number__c = 'APL' + financialYear + String.valueOf(loanApp.Sequence_Namber__c);
                }
            }
    }
	/*@future
	public static void setLoanApplicationNumber(Set<Id> loanApplicationIds) {
            List<Loan_Application__c> loanApplicationsToUpdate = new List<Loan_Application__c>();
			List<Loan_Application__c> loanApplicationsIsNotUpdatedList = new List<Loan_Application__c>();
            Integer currentYear = System.today().year();
            String financialYear = getFinancialYear();
            
            List<Loan_Application__c> loanApplications = [SELECT Id, Sequence_Namber__c, Loan_Application_Number__c,Is_Update_Loan_Aplication_Number__c FROM Loan_Application__c WHERE Id IN :loanApplicationIds];
            	System.debug('loanApplications' + loanApplications);
           for (Loan_Application__c loanApp : loanApplications) {
                if (loanApp.Loan_Application_Number__c == null) {
                    System.debug('loanApp.Sequence_Namber__c' + loanApp.Sequence_Namber__c);
					loanApp.Is_Update_Loan_Aplication_Number__c = true;
                    if(loanApp.Is_Update_Loan_Aplication_Number__c){
                       //String sequenceNumberStr = getPaddedSequenceNumber(Integer.valueOf(loanApp.Sequence_Namber__c), 10);
                        loanApp.Loan_Application_Number__c = 'APL' + financialYear + String.valueOf(loanApp.Sequence_Namber__c);
                        
                        loanApplicationsToUpdate.add(loanApp);
                    }
                   loanApp.Is_Update_Loan_Aplication_Number__c = false;
                   loanApplicationsIsNotUpdatedList.add(loanApp);
                }
            }
    		System.debug('loanApplicationsToUpdate' + loanApplicationsToUpdate);
            if (!loanApplicationsToUpdate.isEmpty()) {
                    try {
                        update loanApplicationsToUpdate;
						
                    } catch (Exception e) {
                        System.debug('Error updating records: ' + e.getMessage());
                        // Handle any errors or exceptions here
                    }
            }
        if(!loanApplicationsIsNotUpdatedList.isEmpty()){
            try {
                     update loanApplicationsIsNotUpdatedList;
                } catch (Exception e) {
                     System.debug('Error updating records: ' + e.getMessage());
                }
        }
    }*/

}