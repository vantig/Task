public with sharing class JunctionOpportunityWebOrderHelper {
  public static List<Web_Order__c> newWebOrders;
  public static List<Opportunity> newOpportunities;
  static {
    newWebOrders = new List<Web_Order__c>();
    newOpportunities = new List<Opportunity>();
  }
}
