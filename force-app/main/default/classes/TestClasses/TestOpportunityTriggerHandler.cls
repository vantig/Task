@IsTest
private class TestOpportunityTriggerHandler {
  @testSetup
  static void setup() {
    TestDataFactory.createOpportunitiesTestRecords(1);
    TestDataFactory.createWebOrdersTestRecords(1);
  }
  // @IsTest
  // static void testCreateOpportunity() {
  //   Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
  //   System.assertEquals(2, countOfOpportunities, 'Insert Opportunities Faled');
  // }
  @IsTest
  static void testCreateOpportunityWithRelated() {
    Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
    Integer countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    System.assertEquals(2, countOfOpportunities, 'Insert  Opportunities Faled');
    System.assertEquals(2, countOfWebOrders, 'Insert  Opportunities Faled');
  }
  @IsTest
  static void testUpdateOpportunityWithRelated() {
    List<Opportunity> opportunities = [SELECT Name FROM Opportunity];
    opportunities[0].Name = 'updated';
    update opportunities[0];
    Integer countOfOpportunities = [
      SELECT Name
      FROM Opportunity
      WHERE Name = 'updated'
    ].size();
    Integer countOfWebOrders = [
      SELECT Name
      FROM Web_Order__c
      WHERE Name = 'updated'
    ].size();
    System.assertEquals(1, countOfOpportunities, 'Update  Opportunities Faled');
    System.assertEquals(1, countOfWebOrders, 'Update  Opportunities Faled');
  }
  @IsTest
  static void testDeleteOpportunityWithRelated() {
    List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
    delete opportunities[0];
    Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
    Integer countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    System.assertEquals(1, countOfOpportunities, 'Delete  Opportunities Faled');
    System.assertEquals(1, countOfWebOrders, 'Delete  Opportunities Faled');
  }
}
