/*******************************************************************************
    Name             : CampaignTrigger
    Description      : Main Trigger to handle multiple scenario on Campaign                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
Shanu                   31/08/2015            Changes made for COR0001387                                                          
*******************************************************************************/


trigger CampaignTrigger on Campaign (after update, after insert,after delete,
before insert,before update) 
{
  CampaignTriggerHandler handler = new CampaignTriggerHandler();
  Boolean bIsCancelledScenario = true;
  Map<Id, Id> mapCampaignOwners = new Map<Id,Id>();
  if(Trigger.New!=null){
  for(Campaign oNewCampaignVar: Trigger.new)
  {
      if(oNewCampaignVar.Status <> System.Label.Cancelled && 
      oNewCampaignVar.Status <> System.Label.Status_Event_Lost && 
      oNewCampaignVar.Status <> System.Label.CampaignStatus_Event_Location)
      {
          bIsCancelledScenario = false;
      }
      if(Trigger.oldMap <> null && Trigger.oldMap.get(oNewCampaignVar.id).OwnerId <> oNewCampaignVar.OwnerId)
      {
          mapCampaignOwners.put(oNewCampaignVar.id, Trigger.oldMap.get(oNewCampaignVar.id).OwnerId);
      }
  }
 } 
   
    if (Trigger.isBefore && !bIsCancelledScenario)
    {
        if(Trigger.isUpdate)
        {
            //Calling Handler class for filtering records and 
            //then call corresponding helper methods in before update scenario
            handler.handleRecordFilteringCriteriaOnBeforeUpdate(Trigger.New, 
            Trigger.Old, Trigger.newMap);
        }
        
        
        //Aug-2015 Shanu- Changes made for COR0001387
        if(Trigger.isInsert)
        {
            handler.assignRMManagerScenario(Trigger.New, Trigger.Old); 
        } 
        
        if(Trigger_Methods_Activation__c.getInstance
        ('assignEstimatedVolunteersNeeded').
        Is_Trigger_Method_Required_In_Insert__c)       
        handler.assignEstimatedVolunteersNeeded(Trigger.New);    
        // preparing list for assigning Estimated Volunteers Needed Scenario
        
        if(Trigger_Methods_Activation__c.getInstance('updateDateTime').
        Is_Trigger_Method_Required_In_Insert__c || 
        Trigger_Methods_Activation__c.getInstance('updateDateTime').
        Is_Trigger_Method_Required_In_Update__c)
        handler.updateDateTime(Trigger.New);
        /*
        if(Trigger_Methods_Activation__c.getInstance
        ('updateVolunteerCoordinatorLookup').
        Is_Trigger_Method_Required_In_Insert__c || 
        Trigger_Methods_Activation__c.getInstance
        ('updateVolunteerCoordinatorLookup').
        Is_Trigger_Method_Required_In_Update__c)
        handler.updateVolunteerCoordinatorLookup
        (Trigger.New,Trigger.OldMap,Trigger.NewMap);*/
        
        
    }
    
    if(Trigger.isAfter)
    {       
        //Calling Handler class for filtering records and 
        //then call corresponding helper methods in post insert scenario
        if(Trigger.isInsert)
        {
           CampaignTriggerHandler.setEventLocationOwner
            (Trigger.newMap); 
         }
        if(Trigger.IsInsert)
        {  
            handler.performPostInsertOperations(Trigger.New, Trigger.newMap);          
                  
        } 
        
        //Calling Handler class for filtering records 
        //and then call corresponding helper methods in post update scenario
        if(Trigger.isUpdate && !bIsCancelledScenario)
        {
            handler.performPostUpdateOperations(Trigger.old, Trigger.New, 
            Trigger.newMap, Trigger.oldMap);
        }
        else if(Trigger.isUpdate && bIsCancelledScenario)
        {
            handler.initiateCancelScenarios(Trigger.old, Trigger.New, 
            Trigger.newMap, Trigger.oldMap);
        }
        
        //Calling Handler class for filtering records and 
        //then call corresponding helper methods in post delete scenario
        if(Trigger.isDelete)
        {   
            //handling after delete scenarios
            handler.performAllDeleteOperations(Trigger.old, Trigger.oldMap); 
            //after delete for Gaols Rollup Scenario sending 
            //old map to CampaignTriggerHandler class
        }
        
        if(mapCampaignOwners.size() > 0)
        {
            if(Trigger_Methods_Activation__c.getInstance('restrictOwnerChange').
            Is_Trigger_Method_Required_In_Insert__c || 
            Trigger_Methods_Activation__c.getInstance('restrictOwnerChange').
            Is_Trigger_Method_Required_In_Update__c)
            {
                TaskTriggerHandler handlerRef = new TaskTriggerHandler();
                handlerRef.restrictOwnerChange(mapCampaignOwners.keyset(),mapCampaignOwners.values());
            }
        }
        
    }
}