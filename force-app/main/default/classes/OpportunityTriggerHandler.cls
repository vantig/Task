public with sharing class OpportunityTriggerHandler implements ITrigger {
  public void bulkBefore() {
    if (Trigger.isInsert) {
      List<Web_Order__c> orders = new List<Web_Order__c>();
      for (sobject op : Trigger.new) {
        orders.add(copyWebOrder((Opportunity) op));
      }
      insert orders;
    }
  }

  public void bulkAfter() {
  }

  public Web_Order__c copyWebOrder(Opportunity op) {
    Web_Order__c wo = new Web_Order__c();

    List<String> opportunityFields = new List<String>();
    List<String> WebOrderFields = new List<String>();

    Map<String, Schema.FieldSet> OpportunityFs = Schema.SObjectType.Opportunity.fieldSets.getMap();

    for (Schema.FieldSet fs : OpportunityFs.values()) {
      for (Schema.FieldSetMember fsm : fs.getFields()) {
        opportunityFields.add(fsm.getFieldPath());
      }
    }
    Map<String, Schema.FieldSet> WebOrdercFs = Schema.SObjectType.Web_Order__c.fieldSets.getMap();

    for (Schema.FieldSet fs : WebOrdercFs) {
      for (Schema.FieldSetMember fsm : fs.getFields()) {
        opportunityFields.add(fsm.get('getSObjectField'));
      }
    }

    for (String field : opportunityFields) {
      wo.WebOrderFields[opportunityFields.indexOf(field)] = op.field;
    }

    return wo;
  }
}
