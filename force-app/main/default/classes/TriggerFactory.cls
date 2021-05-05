public with sharing class TriggerFactory {
  public static void createHandler(Schema.sObjectType soType) {
    ITrigger handler = getHandler(soType);

    if (handler == null) {
      throw new TriggerException(
        'No Trigger Handler registered for Object Type: ' + soType
      );
    }

    execute(handler);
  }

  private static void execute(ITrigger handler) {
    if (Trigger.isBefore && Trigger.isInsert) {
      handler.onBeforeInsert();
    } else if (Trigger.isBefore && Trigger.isUpdate) {
      handler.onBeforeUpdate();
    } else if (Trigger.isBefore && Trigger.isDelete) {
      handler.onBeforeDelete();
    } else if (Trigger.isAfter && Trigger.isInsert) {
      handler.onAfterInsert();
    }
  }

  private static ITrigger getHandler(Schema.sObjectType soType) {
    if (soType == Opportunity.sObjectType) {
      return new OpportunityTriggerHandler();
    }
    if (soType == Web_Order__c.sObjectType) {
      return new WebOrderTriggerHandler();
    }
    return null;
  }
}