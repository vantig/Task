@IsTest
public class TestOpportunityTriggerHandler {
    @IsTest
    public static void CreateOpportunity() {
        Opportunity Opp = new Opportunity();
        Opp.Name = 'test' + Date.today();
        Opp.CloseDate = Date.today();
        Opp.StageName = 'Prospecting';
        insert Opp;
       // System.assertEquals();
    }
}