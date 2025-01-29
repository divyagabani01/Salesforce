public with sharing class GetOpportunities {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> searchOpportunity(String searchText, Integer pageNumber, Integer pageSize) {
        Integer offset = (pageNumber - 1) * pageSize;
        if(String.isBlank(searchText)){
            return [
            SELECT Id, Name, Amount, Probability, StageName, CloseDate
            FROM Opportunity
            ORDER BY CloseDate DESC
            LIMIT :pageSize
            OFFSET :offset
        ];
        }
        return [
            SELECT Id, Name, Amount, Probability, StageName, CloseDate
            FROM Opportunity
            WHERE Name LIKE :('%' + searchText + '%')
            ORDER BY CloseDate DESC
            LIMIT :pageSize
            OFFSET :offset
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalSearchOpportunities(String searchText) {
        if(String.isBlank(searchText)){
			return [SELECT COUNT() FROM Opportunity];
		}
        return [SELECT COUNT() FROM Opportunity WHERE Name LIKE :('%' + searchText + '%')];
    }
}