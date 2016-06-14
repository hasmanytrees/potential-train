/*******************************************************************************
    Name             : LeadTrigger
    Description      : Main Lead Trigger to handle various scenario                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Subhojit                29/01/2015       Modified for code re-factoring &
                                         optimization
*******************************************************************************/

trigger LeadTrigger on Lead (after insert,after update) {

    if(Trigger.isAfter){
    
        LeadTriggerHandler.performPostDMLScenarios(Trigger.New, Trigger.Old, Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    }

}