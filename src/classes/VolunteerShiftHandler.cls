/******************************************************************************
    Name             : VolunteerShiftHandler
    Description      : Trigger handler class used to handle the scenario of 
                       creation of Volunteer Slot record automatically               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014            Created
Subhojit              29/01/2015            Modified for code re-factoring & 
                                              optimization
******************************************************************************/
public with Sharing class VolunteerShiftHandler
{
    public VolunteerShiftHandler()
    {
        // Basic Constructor for VolunteerShiftHandler;
    }
    
    /**
    * Method name  : createVolunteerSlotsAsRequested
    * Description  :Use this method for calling helper which creates Volunteer 
                    Slots as requested in Volunteer Shift creation
    *                
    * Return Type  : List<Volunteer_Shift__c>
    * Parameter    : void
    **/  
    public static void createVolunteerSlotsAsRequested(List<Volunteer_Shift__c> 
    lstNewVolunteerShift)
    {
        VolunteerShiftHelper.createVolunteerSlots(lstNewVolunteerShift); 
        // Calling Helper Class to create auto Volunteer Slot creation
    }
     public static void  updateVolunteerSlotField(Map<Id,Volunteer_Shift__c> 
     mapNewShift,Map<Id,Volunteer_Shift__c> mapOldShift){
    
     Map<Id,Volunteer_Shift__c> mapShiftFinal=new Map<Id,Volunteer_Shift__c>();
       for(Id shiftIdVar : mapNewShift.keySet()){
       
          if((mapNewShift.get(shiftIdVar )
          .Date__c!= mapOldShift.get(shiftIdVar ).Date__c)
             ||(mapNewShift.get(shiftIdVar )
             .End_Time__c != mapOldShift.get(shiftIdVar )
             .End_Time__c)||
             (mapNewShift.get(shiftIdVar ).Start_Time__c != 
             mapOldShift.get(shiftIdVar ).Start_Time__c))
             mapShiftFinal.put(shiftIdVar,mapNewShift.get(shiftIdVar ));
        
       }
     if(mapShiftFinal.size()>0)
       VolunteerShiftHelper.updateVolunteerSlots(mapShiftFinal);
    
    }
    
}