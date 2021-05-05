public with sharing class OpportunityTriggerHandler implements ITrigger {
  public void onBeforeInsert() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.OPPORTUNITY_TRIGGER;
      List<Web_Order__c> orders = new List<Web_Order__c>();

      for (Integer i = 0; i < Trigger.new.size(); i++) {
        orders.add(WebOrderHelper.createWebOrder((Opportunity) Trigger.new[i]));
        JunctionOpportunityWebOrderHelper.newOpportunities.add(
          (Opportunity) Trigger.new[i]
        );
        JunctionOpportunityWebOrderHelper.newWebOrders.add(orders[i]);
      }
      insert orders;
    }
  }
  public void onBeforeUpdate() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.OPPORTUNITY_TRIGGER;
      List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
        (List<Opportunity>) Trigger.new
      );
      List<Web_Order__c> webOrders = WebOrderHelper.getRelatedWebOrders(
        (List<Opportunity>) Trigger.new
      );
      Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();

      Map<Id, Web_Order__c> webOrderMap = new Map<Id, Web_Order__c>();

      for (Opportunity op : (List<Opportunity>) Trigger.new) {
        opportunityMap.put(op.Id, op);
      }

      for (Web_Order__c wo : webOrders) {
        webOrderMap.put(wo.Id, wo);
      }

      for (JunctionOpportunityWebOrder__c jun : junctions) {
        copyOpportunity(
          opportunityMap.get(jun.Opportunity__c),
          webOrderMap.get(jun.Web_Order__c)
        );
      }
      update webOrders;
    }
  }
  public void onBeforeDelete() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.OPPORTUNITY_TRIGGER;
      delete WebOrderHelper.getRelatedWebOrders(
        (List<Opportunity>) Trigger.old
      );
    }
  }
  public void onAfterInsert() {
    if (
      JunctionOpportunityWebOrderHelper.currentTrigger ==
      JunctionOpportunityWebOrderHelper.OPPORTUNITY_TRIGGER
    ) {
      insert JunctionOpportunityWebOrderHelper.createNewJunctions();
    }
  }

  private void copyOpportunity(Opportunity op, Web_Order__c wo) {
    List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsfromFS();

    List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsfromFS();

    for (integer i = 0; i < opportunityFields.size(); i++) {
      wo.put(webOrderFields[i], op.get(opportunityFields[i]));
    }
  }
}
