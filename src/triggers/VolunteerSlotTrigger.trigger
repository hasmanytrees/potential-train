/*****************************************************************************
Name             : VolunteerSlotTrigger 
Description      : Main Volunteer Slot Trigger to handle various logic                 
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014         Created
Subhojit              29/01/2015         Modified for code re-factoring & 
                                         optimization
******************************************************************************/
trigger VolunteerSlotTrigger on Volunteer_Slot__c(before insert,before update){

  if(!Utility.bVSlotStopCancel){
    List<Volunteer_Slot__c> listNew = new List<Volunteer_Slot__c>();
    
    if((Trigger.isBefore)&&(VolunteerSlotTriggerHelper.iReckCheck==0))
    {
        for(Volunteer_Slot__c vRefVar: Trigger.new)
        {            
            // Considering only Slots with Status not Cancelled
      if(vRefVar.Status__c <> null && !vRefVar.Status__c.contains('Cancelled'))
            {
                listNew.add(vRefVar);
            }
        }   
        if(listNew.size() > 0)
        {
      if(Trigger_Methods_Activation__c.getInstance('checkForDuplicateVolunteer')
            .Is_Trigger_Method_Required_In_Insert__c || 
            Trigger_Methods_Activation__c.getInstance
         ('checkForDuplicateVolunteer').Is_Trigger_Method_Required_In_Update__c)
      VolunteerSlotTriggerHandler.checkForDuplicateVolunteer(listNew,
      Trigger.newMap,Trigger.oldMap,Trigger.isUpdate); 
      // Initiating Handler class to check for Duplicate Volunteer
            
            if(Trigger_Methods_Activation__c.getInstance
            ('updateDatetimeSlot').Is_Trigger_Method_Required_In_Insert__c ||
            Trigger_Methods_Activation__c.getInstance
            ('updateDatetimeSlot').Is_Trigger_Method_Required_In_Update__c)
            VolunteerSlotTriggerHandler.updateDatetimeSlot(Trigger.New);
            
            //VolunteerSlotTriggerHandler.populateFieldsOnSlot(Trigger.New);
        
        }
    }    
  }
}