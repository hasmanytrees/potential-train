/*****************************************************************************************
    Name             : dc3RelationshipGroupTrigger 
    Description      : Main Relationship Group Trigger to handle various logic                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Ganesh Neelakantan        3/9/2015            Created
Shanu Shroff                  3/19/2015           Modified for code re-factoring & optimization
******************************************************************************************/

trigger dc3RelationshipGroupTrigger on Relationship_Group__c (after delete, after insert, after undelete, after update, before insert, before update){
    if(Trigger_Methods_Activation__c.getInstance
      ('dc3RelationshipTriggerSwitch')
      .Is_Trigger_Method_Required_In_Update__c)
      {
    dupcheck.dc3Trigger triggerTool = new dupcheck.dc3Trigger(trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.isUndelete);
    String errorString = triggerTool.processTrigger(trigger.oldMap, trigger.new);
    if (String.isNotEmpty(errorString)) {
        trigger.new[0].addError(errorString,false); 
    }
    }
}