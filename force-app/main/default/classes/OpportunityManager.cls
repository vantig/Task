@RestResource(UrlMapping='/Opportunity/*')
global with sharing class OpportunityManager {
    @HttpGet
    global static List<Opportunity> getOpportunities() {

        return [
                SELECT Id,External_Id__c
                FROM Opportunity
                WHERE External_Id__c != NULL
        ];

    }
    @HttpPut
    global static void upsertOpportunity(String json) {
        JSONtoOpportunities result = JSONtoOpportunities.parse(json);
        insert JSONtoOpportunitiesHelper.newAccounts;
        List<Opportunity>opportunitiesUpdate;
        List<Opportunity>opportunitiesInsert;
        List<String>newSids = new List<String>();
        for (Opportunity opp : result.opportunities) {
            newSids.add(opp.x_sid__c);
        }
        Map<String, Opportunity> oldSids = new Map<String, Opportunity>();
        for (Opportunity opp : [SELECT x_sid__c FROM Opportunity WHERE x_sid__c IN :newSids]) {
            oldSids.put(opp.x_sid__c, opp);
        }
        for (Opportunity opp : result.opportunities) {
            if (opp.AccountId == null) {
                opp.AccountId = JSONtoOpportunitiesHelper.newAccounts.remove(0).Id;
            }
            if (oldSids.containsKey(opp.x_sid__c)) {
                opp.Id = oldSids.get(opp.x_sid__c).Id;
                opportunitiesUpdate.add(opp);
            } else {
                opportunitiesInsert.add(opp);
            }

        }
        insert opportunitiesInsert;
        update opportunitiesUpdate;


    }
    @HttpDelete
    global static void deleteOpportunity() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        delete thisCase;
    }

}