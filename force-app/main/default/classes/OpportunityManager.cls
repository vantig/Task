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
    global static String  upsertOpportunity() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        JSONtoOpportunities result = JSONtoOpportunities.parse(requestString);

        /*   List<Opportunity>opportunitiesUpdate=new List<Opportunity>();
           List<Opportunity>opportunitiesInsert=new List<Opportunity>();
           List<String>newSids = new List<String>();
           for (Opportunity opp : result.opportunities) {
               newSids.add(opp.External_Id__c);
           }

           Map<String, Opportunity> oldSids = new Map<String, Opportunity>();
           for (Opportunity opp : [SELECT External_Id__c FROM Opportunity WHERE External_Id__c IN :newSids]) {
               oldSids.put(opp.External_Id__c, opp);
           }*/


        //jsonResponse = '{ "firstName": "Test", "lastName": "Case 2", "email": "testuser2@acorp.com" }';

       // String jsonResponse = JSON.serialize(Database.upsert(result.opportunities, Opportunity.External_Id__c.getDescribe().getSobjectField(), false)) ;

       // String jsonResponse= JSON.serialize(Database.upsert(result.opportunities, Opportunity.External_Id__c.getDescribe().getSobjectField(), false));
upsert result.opportunities  Opportunity.External_Id__c;
        List<Opportunity>insertedOpportunitiesWithRelatedAccount = [SELECT External_Id__c FROM Opportunity WHERE External_Id__c IN :JSONtoOpportunitiesHelper.namesOfRelatedAccounts.keySet()];

        System.debug(insertedOpportunitiesWithRelatedAccount + 'insertedOpportunitiesWithRelatedAccount');


        AccountHelper accHelper = new AccountHelper(new List<String>(new Set<String>(JSONtoOpportunitiesHelper.namesOfRelatedAccounts.values())));

        accHelper.reQueryByNames();

        for (Opportunity opp : insertedOpportunitiesWithRelatedAccount) {

            opp.AccountId = accHelper.getAccount(JSONtoOpportunitiesHelper.namesOfRelatedAccounts.get(opp.External_Id__c)).Id;

        }

        Database.update(insertedOpportunitiesWithRelatedAccount, false) ;


//        RestResponse response = new RestResponse();
//        response.statusCode = 200;
//        System.debug(jsonResponse + ' jsonResponse' + '\n');
//        response.responseBody = Blob.valueOf(jsonResponse);
//
//        response.addHeader('Content-Type', 'application/json');
//        RestContext.response = response;

        return '';
    }
    @HttpDelete
    global static void deleteOpportunity() {
        RestRequest request = RestContext.request;
        String oppId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Opportunity opp = [SELECT External_Id__c FROM Opportunity WHERE External_Id__c = :oppId];
        delete opp;
    }

}