/******************************************************************************
    Name             : VolunteerShiftTrigger 
    Description      : Main Volunteer Shift Trigger to handle various logic                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                         optimization
******************************************************************************/
trigger VolunteerShiftTrigger on Volunteer_Shift__c (after insert,after update) 
{

    if(Trigger.isInsert && 
 Trigger_Methods_Activation__c.getInstance('createVolunteerSlotsAsRequested')
    .Is_Trigger_Method_Required_In_Insert__c)
    {
        VolunteerShiftHandler.createVolunteerSlotsAsRequested(Trigger.new); 
        // Initiate handler class to create Volunteer Slot based on Initial 
        //Number Of Slot requested
    }
   if((Trigger.IsUpdate)&&(Trigger_Methods_Activation__c.getInstance('updateVolunteerSlotField')
    .Is_Trigger_Method_Required_In_Update__c)&&(!Utility.bVShiftStopCancel))
  VolunteerShiftHandler.updateVolunteerSlotField(Trigger.NewMap,Trigger.oldMap);
   
}