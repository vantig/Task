public with sharing class WebOrderTriggerHandler implements ITrigger {
  public void onBeforeInsert() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER;
      List<Opportunity> opportunites = new List<Opportunity>();

      for (Integer i = 0; i < Trigger.new.size(); i++) {
        opportunites.add(
          OpportunityHelper.createOpportunity((Web_Order__c) Trigger.new[i])
        );
        JunctionOpportunityWebOrderHelper.newWebOrders.add(
          (Web_Order__c) Trigger.new[i]
        );
        JunctionOpportunityWebOrderHelper.newOpportunities.add(opportunites[i]);
      }
      insert opportunites;
    }
  }

  public void onBeforeUpdate() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER;
      List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
        (List<Web_Order__c>) Trigger.new
      );
      List<Opportunity> opportunites = OpportunityHelper.getRelatedOpportunites(
        (List<Web_Order__c>) Trigger.new
      );
      Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();

      Map<Id, Web_Order__c> webOrderMap = new Map<Id, Web_Order__c>();

      for (Opportunity op : opportunites) {
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
      update opportunites;
    }
  }

  public void onBeforeDelete() {
    if (JunctionOpportunityWebOrderHelper.currentTrigger == null) {
      JunctionOpportunityWebOrderHelper.currentTrigger = JunctionOpportunityWebOrderHelper.WEBORDER_TRIGGER;
      delete OpportunityHelper.getRelatedOpportunites(
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
    List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsfromFS();

    List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsfromFS();

    for (integer i = 0; i < opportunityFields.size(); i++) {
      op.put(opportunityFields[i], wo.get(webOrderFields[i]));
    }
  }
}
