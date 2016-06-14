/*****************************************************************************************
    Name             : SBCCommunicationTrigger
    Description      : Main SBCCommunication Trigger to handle various logic                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D               30/07/2014            Created
Apurva                 21/12/2015            Added Switch conditions
******************************************************************************************/
trigger SBCCommunicationTrigger on SBC_Communications__c (before insert, before update, after insert, after update) {
    
    
    if(Utility.bToCheckSupporterStatus && Trigger.isBefore)
    {
        SBCCommunicationTriggerHandler oSBCComHandler = new SBCCommunicationTriggerHandler () ; 
        if(Trigger_Methods_Activation__c.getInstance('onBeforeInsertSBCCom').Is_Trigger_Method_Required_In_Insert__c
        ||Trigger_Methods_Activation__c.getInstance('onBeforeInsertSBCCom').Is_Trigger_Method_Required_In_Update__c){
          oSBCComHandler.onBeforeInsertSBCCom (Trigger.New, Trigger.isInsert , Trigger.OldMap , Trigger.NewMap ) ; 
        }
        
        if(Trigger_Methods_Activation__c.getInstance('setFinalDeliveryPreferenceSBC').Is_Trigger_Method_Required_In_Insert__c
        ||Trigger_Methods_Activation__c.getInstance('setFinalDeliveryPreferenceSBC').Is_Trigger_Method_Required_In_Update__c){
            SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce(Trigger.New);
        }
        if(Trigger_Methods_Activation__c.getInstance('updateSBCLanguage').Is_Trigger_Method_Required_In_Insert__c
        ||Trigger_Methods_Activation__c.getInstance('updateSBCLanguage').Is_Trigger_Method_Required_In_Update__c){
          SBCCommunicationTriggerHandler.updateSBCLanguage(Trigger.New , Trigger.IsInsert );  
        }      
    }
    
    if(Utility.bToCheckSupporterStatus && Trigger.isAfter)
    { 
        if(Trigger_Methods_Activation__c.getInstance('sendSBCComToExternalSystem').Is_Trigger_Method_Required_In_Insert__c
        ||Trigger_Methods_Activation__c.getInstance('sendSBCComToExternalSystem').Is_Trigger_Method_Required_In_Update__c){
          SBCCommunicationTriggerHandler.sendSBCComToExternalSystem( Trigger.New , Trigger.OldMap, Utility.bToCheckSupporterStatus) ; 
        
        }
    }        
    if(Trigger.isAfter){
        if(Trigger_Methods_Activation__c.getInstance('setSBCLastCorrespondenceDate').Is_Trigger_Method_Required_In_Insert__c
        ||Trigger_Methods_Activation__c.getInstance('setSBCLastCorrespondenceDate').Is_Trigger_Method_Required_In_Update__c){
           SBCCommunicationTriggerHandler.setLastCorrespondenceDate(Trigger.NewMap,Trigger.OldMap,Trigger.New);
        }
        if(Trigger_Methods_Activation__c.getInstance('UpdateInappropriateCorrespondenceSBC').Is_Trigger_Method_Required_In_Insert__c
        ||Trigger_Methods_Activation__c.getInstance('UpdateInappropriateCorrespondenceSBC').Is_Trigger_Method_Required_In_Update__c){
          SBCCommunicationTriggerHandler.UpdateInappropriateCorrespondence (Trigger.NewMap,Trigger.OldMap,Trigger.New);
      }
    }
}