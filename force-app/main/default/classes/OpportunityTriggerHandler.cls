public with sharing class OpportunityTriggerHandler implements ITrigger {
    public void onBeforeInsert() {

    }

    public void onBeforeUpdate() {
        JunctionOpportunityWebOrderHelper.flag = false;

        List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
                (List<Opportunity>) Trigger.new
        );
        List<Web_Order__c> webOrders = WebOrderHelper.getRelatedWebOrders(
                (List<Opportunity>) Trigger.new
        );
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>((List<Opportunity>) Trigger.new);

        Map<Id, Web_Order__c> webOrderMap = new Map<Id, Web_Order__c>(webOrders);

        for (JunctionOpportunityWebOrder__c jun : junctions) {
            copyOpportunity(
                    opportunityMap.get(jun.Opportunity__c),
                    webOrderMap.get(jun.Web_Order__c)
            );
        }
        update webOrders;
        JunctionOpportunityWebOrderHelper.flag = true;
    }
    public void onBeforeDelete() {
        JunctionOpportunityWebOrderHelper.flag = false;

        delete WebOrderHelper.getRelatedWebOrders((List<Opportunity>) Trigger.old);
        JunctionOpportunityWebOrderHelper.flag = true;


    }
    public void onAfterInsert() {


        JunctionOpportunityWebOrderHelper.flag = false;


        System.debug(Trigger.newMap.values());

        List<Opportunity>opportunities = Trigger.newMap.values();
        List<Web_Order__c> orders = new List<Web_Order__c>();

        for (Integer i = 0; i < opportunities.size(); i++) {
            orders.add(WebOrderHelper.createWebOrder((Opportunity) opportunities[i]));
            JunctionOpportunityWebOrderHelper.newOpportunities.add(
                    (Opportunity) opportunities[i]
            );
            JunctionOpportunityWebOrderHelper.newWebOrders.add(orders[i]);
        }
        insert orders;
        insert JunctionOpportunityWebOrderHelper.createNewJunctions();
        JunctionOpportunityWebOrderHelper.flag = true;
    }
    public void onAfterUpdate() {
        JunctionOpportunityWebOrderHelper.flag = true;
    }
    public void onAfterDelete() {
        JunctionOpportunityWebOrderHelper.flag = true;
    }
    private void copyOpportunity(Opportunity op, Web_Order__c wo) {
        List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsFromFS();

        List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsFromFS();

        for (Integer i = 0; i < opportunityFields.size(); i++) {
            wo.put(webOrderFields[i], op.get(opportunityFields[i]));
        }
    }
}