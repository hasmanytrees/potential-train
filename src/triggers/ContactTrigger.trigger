/*****************************************************************************************
    Name             : Contact Trigger
    Description      : Main Contact Trigger to handle various logic                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Apurva                17/08/2015            Created
******************************************************************************************/
trigger ContactTrigger on Contact (before insert,before update) {
  if((Trigger.isBefore)&&((Trigger.isInsert)||(Trigger.isUpdate))){
    if(Trigger_Methods_Activation__c.getInstance('checkPrimaryContact').Is_Trigger_Method_Required_In_Insert__c 
       || Trigger_Methods_Activation__c.getInstance('checkPrimaryContact').Is_Trigger_Method_Required_In_Update__c){  
         ContactTriggerHandler.onInsertUpdateCheckPrimaryContact(Trigger.new); 
    }
  }
}