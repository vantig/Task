public interface ITrigger {
  void onBeforeInsert();
  void onBeforeUpdate();
  void onBeforeDelete();
  void onAfterInsert();
}