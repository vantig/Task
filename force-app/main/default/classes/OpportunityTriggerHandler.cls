public with sharing class OpportunityTriggerHandler implements ITrigger {
  public void bulkBefore() {
    if (Trigger.isInsert) {
      List<Web_Order__c> orders = new List<Web_Order__c>();

      for (Integer i = 0; i < Trigger.new.size(); i++) {
        orders.add(WebOrderHelper.createWebOrder((Opportunity) Trigger.new[i]));
        JunctionOpportunityWebOrderHelper.newOpportunities.add(
          (Opportunity) Trigger.new[i]
        );
        JunctionOpportunityWebOrderHelper.newWebOrders.add(orders[i]);
      }
      insert orders;
    } else if (Trigger.isUpdate) {
      updateRelatedWebOrders((List<Opportunity>) Trigger.new);
    } else if (Trigger.isDelete) {
      deleteRelatedWebOrders((List<Opportunity>) Trigger.old);
    }
  }

  public void bulkAfter() {
    if (Trigger.isInsert) {
      insert JunctionOpportunityWebOrderHelper.createNewJunctions();
    }
  }

  public void deleteRelatedWebOrders(List<Opportunity> opl) {
    List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(opl);

    if (junctions == null) {
      return;
    }

    List<Web_Order__c> webOrders = WebOrderHelper.getRelatedWebOrders(junctions);

    delete webOrders;
  }

  private void updateRelatedWebOrders(List<Opportunity> opl) {
    List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(opl);

    if (junctions == null) {
      return;
    }

    List<Web_Order__c> webOrders = WebOrderHelper.getRelatedWebOrders(
      junctions
    );

    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();

    Map<Id, Web_Order__c> webOrderMap = new Map<Id, Web_Order__c>();

    for (Opportunity op : opl) {
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

  private void copyOpportunity(Opportunity op, Web_Order__c wo) {
    List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsfromFS();

    List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsfromFS();

    for (integer i = 0; i < opportunityFields.size(); i++) {
      wo.put(webOrderFields[i], op.get(opportunityFields[i]));
    }
  }

  
}
