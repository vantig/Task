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

    Map<String, Schema.FieldSet> Fs1 = Schema.SObjectType.Opportunity.fieldSets.getMap();
    Map<String, Schema.FieldSet> Fs2 = Schema.SObjectType.Web_Order__c.fieldSets.getMap();
    system.debug(Fs1);
    system.debug(Fs2);

    wo.Close_Date__c = date.today();
    wo.Name = 'test wo';
    wo.Stage__c = 'Closed Won';

    return wo;
    // for (Schema.FieldSet fs : FsMap.values()) {
    //   for (SObject var : fs) {
    //   }
    // }
  }
}
