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

        /*   List<Opportunity>opportunitiesUpdate=new List<Opportunity>();
           List<Opportunity>opportunitiesInsert=new List<Opportunity>();
           List<String>newSids = new List<String>();
           for (Opportunity opp : result.opportunities) {
               newSids.add(opp.x_sid__c);
           }
           Map<String, Opportunity> oldSids = new Map<String, Opportunity>();
           for (Opportunity opp : [SELECT x_sid__c FROM Opportunity WHERE x_sid__c IN :newSids]) {
               oldSids.put(opp.x_sid__c, opp);
           }*/


        Database.upsert(result.opportunities, false) ;

        List<Opportunity>insertedOpportunitiesWithRelatedAccount= [SELECT x_sid__c FROM Opportunity WHERE x_sid__c IN :JSONtoOpportunitiesHelper.namesOfRelatedAccounts.keySet()];

        List<Account>accounts=new List<Account>();

        AccountHelper accHelper=new AccountHelper(JSONtoOpportunitiesHelper.namesOfRelatedAccounts.values());

        for (Integer i=0;i<insertedOpportunitiesWithRelatedAccount.size();++i){

            accounts.add(accHelper.getAccount(JSONtoOpportunitiesHelper.namesOfRelatedAccounts.get(insertedOpportunitiesWithRelatedAccount[i].x_sid__c)));

        }

        Database.upsert(accounts, false) ;

        for (Integer i=0;i<insertedOpportunitiesWithRelatedAccount.size();++i){

            insertedOpportunitiesWithRelatedAccount[i].AccountId=accounts[i].Id;

        }

        Database.update(insertedOpportunitiesWithRelatedAccount, false) ;

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