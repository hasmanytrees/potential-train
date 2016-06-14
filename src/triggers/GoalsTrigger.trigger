/*******************************************************************************
    Name             : GoalsTrigger
    Description      : Main Trigger to handle update,edit,delete scenarios on 
                       Goals and Rolls it up Event/Event Location/Campaign level.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  30/10/2014            Created
Sumeet                  29/01/2015            Modified for code re-factoring & 
                                              optimization
*******************************************************************************/

trigger GoalsTrigger on Goals__c (after insert,after update,after delete) 
{
 if(Trigger.isAfter)
 { //Handles Update scenario and rolls up to Event/Event Location/Campaign level.
      if (Trigger.isupdate && Trigger_Methods_Activation__c.getInstance
      ('goalsRollUpOnCampaignObjectafterUpdate')
      .Is_Trigger_Method_Required_In_Update__c)
      {
      GoalsTriggerHandler.goalsRollUpOnCampaignObjectafterUpdate(Trigger.newMap,
        Trigger.oldMap, trigger.new, trigger.old);             
      }
 // Handles delete scenario and rolls upto Event/Event Location/Campaign level.
      else if (Trigger.isDelete && Trigger_Methods_Activation__c.getInstance
      ('performPostDeleteGoalsRollup').Is_Trigger_Method_Required_In_Delete__c) 
      {            
          GoalsTriggerHandler.performPostDeleteGoalsRollup(Trigger.oldMap);             
      }    
//Handles new insert goals record scenario and rolls upto Event/Event Location/Campaign
// level.
      else if (Trigger.isInsert && Trigger_Methods_Activation__c.getInstance
      ('goalsRollUpOnCampaignObjectAfterInsert')
      .Is_Trigger_Method_Required_In_Insert__c)
      {    system.debug('```records are getting inserted');
      goalsTriggerHandler.goalsRollUpOnCampaignObjectAfterInsert(Trigger.newMap,
        trigger.new);                   
      }
 }
    
      
 }