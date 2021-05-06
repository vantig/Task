@isTest
public class TestOpportunityTriggerHandler {
  @isTest
  public static void CreateOpportunity() {
    Opportunity Opp = new Opportunity();
    Opp.Name = 'test' + date.today();
    Opp.CloseDate = date.today();
    Opp.StageName = 'Prospecting';
    insert Opp;
  }
}
