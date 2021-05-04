public with sharing class OpportunityHelper {
  public static List<String> getOpportunityFieldsfromFS() {
    List<String> opportunityFields = new List<String>();
    Map<String, Schema.FieldSet> opportunityFs = Schema.SObjectType.Opportunity.fieldSets.getMap();

    for (Schema.FieldSet fs : opportunityFs.values()) {
      for (Schema.FieldSetMember fsm : fs.getFields()) {
        opportunityFields.add(fsm.getFieldPath());
      }
    }

    return opportunityFields;
  }
}
