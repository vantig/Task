public with sharing class OpportunityTriggerHandler implements ITrigger {
  public void bulkBefore() {
    if (Trigger.isInsert) {
      List<Web_Order__c> orders = new List<Web_Order__c>();

      for (Integer i = 0; i < Trigger.new.size(); i++) {
        orders.add(createWebOrder((Opportunity) Trigger.new[i]));
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
      List<JunctionOpportunityWebOrder__c> junctions = new List<JunctionOpportunityWebOrder__c>();

      for (Integer i = 0; i < Trigger.new.size(); i++) {
        JunctionOpportunityWebOrder__c jun = new JunctionOpportunityWebOrder__c();
        jun.Opportunity__c = JunctionOpportunityWebOrderHelper.newOpportunities[
            i
          ]
          .Id;
        jun.Web_Order__c = JunctionOpportunityWebOrderHelper.newWebOrders[i].Id;
        junctions.add(jun);
      }
      insert junctions;
    }
  }

  public void deleteRelatedWebOrders(List<Opportunity> opl) {
    List<JunctionOpportunityWebOrder__c> junctions = [
      SELECT Opportunity__c, Web_Order__c
      FROM JunctionOpportunityWebOrder__c
      WHERE Opportunity__c IN :opl
    ];

    if (junctions == null) {
      return;
    }

    List<Id> IdWebOrders = new List<Id>();

    for (JunctionOpportunityWebOrder__c jun : junctions) {
      idWebOrders.add(jun.Web_Order__c);
    }

    List<Web_Order__c> webOrders = [
      SELECT Id
      FROM Web_Order__c
      WHERE Id IN :idWebOrders
    ];

    delete webOrders;
  }

  private void updateRelatedWebOrders(List<Opportunity> opl) {
    List<JunctionOpportunityWebOrder__c> junctions = [
      SELECT Opportunity__c, Web_Order__c
      FROM JunctionOpportunityWebOrder__c
      WHERE Opportunity__c IN :opl
    ];

    List<Id> IdWebOrders = new List<Id>();

    for (JunctionOpportunityWebOrder__c jun : junctions) {
      idWebOrders.add(jun.Web_Order__c);
    }

    List<String> webOrderFields = getWebOrderFieldsfromFS();

    String query = 'SELECT ';
    for (String field : webOrderFields) {
      query += field + ', ';
    }

    query += 'Id FROM Web_Order__c WHERE Id IN:IdWebOrders';

    List<Web_Order__c> webOrders = Database.Query(query);

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
  public List<String> getOpportunityFieldsfromFS() {
    List<String> opportunityFields = new List<String>();
    Map<String, Schema.FieldSet> OpportunityFs = Schema.SObjectType.Opportunity.fieldSets.getMap();

    for (Schema.FieldSet fs : OpportunityFs.values()) {
      for (Schema.FieldSetMember fsm : fs.getFields()) {
        opportunityFields.add(fsm.getFieldPath());
      }
    }

    return opportunityFields;
  }

  public List<String> getWebOrderFieldsfromFS() {
    List<String> webOrderFields = new List<String>();

    Map<String, Schema.FieldSet> WebOrderFs = Schema.SObjectType.Web_Order__c.fieldSets.getMap();

    for (Schema.FieldSet fs : WebOrderFs.values()) {
      for (Schema.FieldSetMember fsm : fs.getFields()) {
        webOrderFields.add(fsm.getFieldPath());
      }
    }

    return webOrderFields;
  }

  private void copyOpportunity(Opportunity op, Web_Order__c wo) {
    List<String> opportunityFields = getOpportunityFieldsfromFS();

    List<String> webOrderFields = getWebOrderFieldsfromFS();

    for (integer i = 0; i < opportunityFields.size(); i++) {
      wo.put(webOrderFields[i], op.get(opportunityFields[i]));
    }
  }

  public Web_Order__c createWebOrder(Opportunity op) {
    Web_Order__c wo = new Web_Order__c();

    List<String> opportunityFields = getOpportunityFieldsfromFS();

    List<String> webOrderFields = getWebOrderFieldsfromFS();

    for (integer i = 0; i < opportunityFields.size(); i++) {
      wo.put(webOrderFields[i], op.get(opportunityFields[i]));
    }

    return wo;
  }
}
