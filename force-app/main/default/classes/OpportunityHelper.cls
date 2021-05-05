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
  public static Opportunity createOpportunity(Web_Order__c wo) {
    Opportunity op = new Opportunity();

    List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsfromFS();

    List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsfromFS();

    for (integer i = 0; i < opportunityFields.size(); i++) {
      op.put(opportunityFields[i], wo.get(webOrderFields[i]));
    }

    return op;
  }
  public static List<Opportunity> getRelatedOpportunites(
    List<JunctionOpportunityWebOrder__c> junctions
  ) {
    List<Id> IdOpportunites = new List<Id>();

    for (JunctionOpportunityWebOrder__c jun : junctions) {
      IdOpportunites.add(jun.Opportunity__c);
    }

    List<String> OpportunitesFields = getOpportunityFieldsfromFS();

    String query = 'SELECT ';
    for (String field : OpportunitesFields) {
      query += field + ', ';
    }

    query += 'Id FROM Opportunity WHERE Id IN:IdOpportunites';

    return Database.Query(query);
  }
  public static List<Opportunity> getRelatedOpportunites(
    List<Web_Order__c> wol
  ) {
    List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
      wol
    );

    if (junctions == null) {
      return new List<Opportunity>();
    }

    List<Opportunity> opportunites = OpportunityHelper.getRelatedOpportunites(
      junctions
    );
    return opportunites;
  }
}