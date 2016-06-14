/*****************************************************************************************
    Name             : AccountTrigger
    Description      : Main Account Trigger to handle various logic                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
Apurva                  16/10/2015            Changes made for COR0001428
Apurva                  03/12/2015            Changes made for COR0001584
Apurva                  18/12/2015            Added switch conditions 
******************************************************************************************/
trigger AccountTrigger on Account (after insert,before insert,after update) {
    
    if((Trigger.isBefore)&&(Trigger.isInsert))
    {
        if(Trigger_Methods_Activation__c.getInstance('onInsertUpdateAssignOwner').Is_Trigger_Method_Required_In_Insert__c)
        {
       // Assigning Account owner based on business Rule
          AccountTriggerHandler.onInsertUpdateAssignOwner(Trigger.New);    
        }
        if(Trigger_Methods_Activation__c.getInstance('onInsertSetLastCorrespondenceDate').Is_Trigger_Method_Required_In_Insert__c)
        {
          AccountTriggerHandler.setLastCorrespondenceDate (Trigger.New);     
        }
    }
    if((Trigger.isAfter)&&(Trigger.isInsert))
    { 
        if(Trigger_Methods_Activation__c.getInstance('addCommPrefRule').Is_Trigger_Method_Required_In_Insert__c)
        {
        // Inserting default Communication Preferences
        //AccountTriggerHandler.addCommPrefRule(Trigger.newMap.keySet());  
          AccountTriggerHandler.addCommPrefRule(Trigger.new);  
        }
    }
    
    if(((Trigger.IsInsert)||(Trigger.isUpdate))&&(Trigger.isAfter))
    {
        if(Trigger_Methods_Activation__c.getInstance('followAndUnfollowHandler').Is_Trigger_Method_Required_In_Insert__c 
        || Trigger_Methods_Activation__c.getInstance('followAndUnfollowHandler').Is_Trigger_Method_Required_In_Update__c)
        {
        // Initiate handler class to handle follow and unfollow record for account owner 
          AccountTriggerHandler.followAndUnfollowHandler(Trigger.newMap,Trigger.oldMap);  
        }
        if(Trigger.isUpdate&&Trigger_Methods_Activation__c.getInstance('updateVolunteerSlotEmail').Is_Trigger_Method_Required_In_Update__c)
        {
          AccountTriggerHandler.updateVolunteerSlotEmail(Trigger.newMap,Trigger.OldMap); 
        }   
        //Apurva - code added for COR0001428   
        if((Trigger.isUpdate &&Trigger_Methods_Activation__c.getInstance('createAccountOwnerHistory').Is_Trigger_Method_Required_In_Update__c)
        ||(Trigger.IsInsert &&Trigger_Methods_Activation__c.getInstance('createAccountOwnerHistory').Is_Trigger_Method_Required_In_Insert__c))
          AccountTriggerHandler.createAccountOwnerHistory(Trigger.newMap,Trigger.OldMap);  
    }
    
    if((Trigger.isAfter)&&(Trigger.isUpdate)&&(!Utility.bRecursive))
    {
        if(Trigger_Methods_Activation__c.getInstance('getOldNewJSON').Is_Trigger_Method_Required_In_Update__c)
        {
          AccountTriggerHandler.getOldNewJSON(Trigger.OldMap,Trigger.NewMap);
        }
        if(Trigger_Methods_Activation__c.getInstance('changeAccCorrespondingSBCComm').Is_Trigger_Method_Required_In_Update__c)
        {
          AccountTriggerHandler.changeCorrespondingSBCCommunications(Trigger.OldMap,Trigger.NewMap);
        }
        if(Trigger_Methods_Activation__c.getInstance('updateAccountToCI').Is_Trigger_Method_Required_In_Update__c)
        {
         AccountTriggerHandler.updateAccountToCI(Trigger.OldMAp,Trigger.newMap);
        }
        
        if(Trigger_Methods_Activation__c.getInstance('changeAccCorrespondingSBCStat').Is_Trigger_Method_Required_In_Update__c)
        {
          AccountTriggerHandler.changeCorrespondingSBCStatus(Trigger.OldMAp,Trigger.newMap);
        }
    }
 
 //Apurva- Changes made for COR0001584
    if(trigger.isDelete && trigger.isBefore){
      if(Trigger_Methods_Activation__c.getInstance('checkAccountDeletion').Is_Trigger_Method_Required_In_Delete__c){


        AccountTriggerHandler.checkAccountDeletionValidation(Trigger.Old);
      }
    } 

}