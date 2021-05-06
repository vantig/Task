@IsTest
private class TestOpportunityTriggerHandler {
  @testSetup
  static void setup() {
    TestDataFactory.createOpportunitiesTestRecords(1);
    Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
    Integer countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    TestDataFactory.createWebOrdersTestRecords(1);
   
    countOfOpportunities = 0;
    countOfWebOrders = 0;
    countOfOpportunities = [SELECT Id FROM Opportunity].size();
    countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    System.debug(countOfWebOrders);
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
    System.assertEquals(2, countOfWebOrders, 'Insert  WebOrders Faled');
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
      ]
      .size();
    Integer countOfWebOrders = [
        SELECT Name
        FROM Web_Order__c
        WHERE Name = 'updated'
      ]
      .size();
    System.assertEquals(1, countOfOpportunities, 'Update  Opportunities Faled');
    System.assertEquals(1, countOfWebOrders, 'Update  WebOrders Faled');
  }
  @IsTest
  static void testDeleteOpportunityWithRelated() {
    List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
    delete opportunities[0];
    Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
    Integer countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    System.assertEquals(1, countOfOpportunities, 'Delete  Opportunities Faled');
    System.assertEquals(1, countOfWebOrders, 'Delete  WebOrders Faled');
  }
}
