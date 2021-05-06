public with sharing class WebOrderTriggerHandler implements ITrigger {
  public void onBeforeInsert() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER;
      List<Opportunity> opportunities = new List<Opportunity>();

      for (Integer i = 0; i < Trigger.new.size(); i++) {
        opportunities.add(
          OpportunityHelper.createOpportunity((Web_Order__c) Trigger.new[i])
        );
        JunctionOpportunityWebOrderHelper.newWebOrders.add(
          (Web_Order__c) Trigger.new[i]
        );
        JunctionOpportunityWebOrderHelper.newOpportunities.add(opportunities[i]);
      }
      insert opportunities;
    }
  }

  public void onBeforeUpdate() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER;
      List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
        (List<Web_Order__c>) Trigger.new
      );
      List<Opportunity> opportunities = OpportunityHelper.getRelatedOpportunities(
        (List<Web_Order__c>) Trigger.new
      );
      Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();

      Map<Id, Web_Order__c> webOrderMap = new Map<Id, Web_Order__c>();

      for (Opportunity op : opportunities) {
        opportunityMap.put(op.Id, op);
      }

      for (Web_Order__c wo : (List<Web_Order__c>) Trigger.new) {
        webOrderMap.put(wo.Id, wo);
      }

      for (JunctionOpportunityWebOrder__c jun : junctions) {
        copyWebOrder(
          webOrderMap.get(jun.Web_Order__c),
          opportunityMap.get(jun.Opportunity__c)
        );
      }
      update opportunities;
    }
  }

  public void onBeforeDelete() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER;
      delete OpportunityHelper.getRelatedOpportunities(
        (List<Web_Order__c>) Trigger.old
      );
    }
  }
  public void onAfterInsert() {
    if (
      JunctionOpportunityWebOrderHelper.currentTrigger ==
      JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER
    ) {
      insert JunctionOpportunityWebOrderHelper.createNewJunctions();
    }
  }

  private void copyWebOrder(Web_Order__c wo, Opportunity op) {
    List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsFromFS();

    List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsFromFS();

    for (Integer i = 0; i < opportunityFields.size(); i++) {
      op.put(opportunityFields[i], wo.get(webOrderFields[i]));
    }
  }
}