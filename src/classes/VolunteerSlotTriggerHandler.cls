/*****************************************************************************
    Name             : VolunteerSlotTriggerHandler
    Description      : Trigger Handler class used to handle the scenario of 
                       checking for duplicate volunteer in volunteer Slots.               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit             30/10/2014          Created
Subhojit             29/01/2015          Modified for code re-factoring &
                                         optimization
******************************************************************************/
public with Sharing class VolunteerSlotTriggerHandler
{
    public VolunteerSlotTriggerHandler()
    {
        //Basic Constructor for VolunteerSlotTriggerHandler;
    }
    /**
    * Method name  : checkForDuplicateVolunteer
    * Description  :This method is used for checking same Volunteer addition 
    *               for more than one slot.
    * Return Type  : List<Volunteer_Shift__c>,Map<Id,Volunteer_Slot__c> ,
                     Map<Id,Volunteer_Slot__c>,boolean
    * Parameter    : void
    **/   
    
    public static void checkForDuplicateVolunteer(List<Volunteer_Slot__c> 
    lstNewVolunteerSlot,Map<Id,Volunteer_Slot__c> mapNewVSlot,
    Map<Id,Volunteer_Slot__c> mapOldVSlot,boolean bIsUpdate)
    {
        VolunteerSlotTriggerHelper.checkDuplicateVolunteer(lstNewVolunteerSlot,
        mapNewVSlot,mapOldVSlot,bIsUpdate);  
        //Initiating helper class to check for Duplicate volunteer
    }
    
    public static void updateDatetimeSlot(List<Volunteer_Slot__c>
    lstVolunteerSlot){
    
   List<Volunteer_Slot__c> lstVolunteerSlotFinal=new List<Volunteer_Slot__c>(); 
    
    for(Volunteer_Slot__c oVSlotVar: lstVolunteerSlot){
    
       if(oVSlotVar.Status__c!=null){
      
          if(oVSlotVar.Date__c!=null)
            lstVolunteerSlotFinal.add(oVSlotVar);
      }
      system.debug(oVSlotVar.Date__c);
    }
    if(lstVolunteerSlotFinal.size()>0)
         VolunteerSlotTriggerHelper.updateDateTime(lstVolunteerSlotFinal);
    }
    
}