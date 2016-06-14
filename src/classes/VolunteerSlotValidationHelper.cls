/*****************************************************************************
    Name             : VolunteerSlotValidationHelper
    Description      : This helper class is used to check for duplicate 
                       volunteer addition in Volunteer Slot                
    Modification Log : 
---------------------------------------------------------------------------
Developer             Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014        Created
Subhojit              29/01/2015        Modified for code re-factoring & 
                                        optimization
******************************************************************************/
public with Sharing class VolunteerSlotValidationHelper{

    /**
    * Method name  : checkForDuplicateVolunteer
    * Description  :This method is used to check for duplicate volunteer 
    *               addition in Volunteer Slot  
    * Return Type  : List<Volunteer_Slot__c>
    * Parameter    : void
    **/   
    public static void checkForDuplicateVolunteer(List<Volunteer_Slot__c> 
    lstlVolunteerSlot){


        Set<Id> setVolunteerShiftId=new Set<Id>();
     Map<Id,Volunteer_Slot__c> mapVolunteerSlot=new Map<Id,Volunteer_Slot__c>();
        List<Volunteer_Slot__c> lstError=new List<Volunteer_Slot__c>();
        for(Volunteer_Slot__c oVolunteerSlotVar: lstlVolunteerSlot)
        setVolunteerShiftId.add(oVolunteerSlotVar.Volunteer_Shift__c);  
        // Finding related Volunteer shift Ids        
        
        List<Volunteer_Slot__c> lstExistingVolunteerSlot = 
        new List<Volunteer_Slot__c>();
        String sStatusParameter = '%' + System.Label.Cancelled + '%';
        
        //Querying for Existing volunteer slots for related volunteer shift
        lstExistingVolunteerSlot=[select Id,Name,Volunteer__c,Status__c from 
        Volunteer_Slot__c where Volunteer_Shift__c IN :setVolunteerShiftId and 
        Volunteer__c!=null
        and (Status__c!= :System.Label.Volunteer_Slot_Declined and 
        (NOT Status__c Like :sStatusParameter))];
        
        

        for(Volunteer_Slot__c oSlotVar: lstExistingVolunteerSlot)
            mapVolunteerSlot.put(oSlotVar.Volunteer__c,oSlotVar);       
            // Creating volunteer slot Map
        
        for(Volunteer_Slot__c oSlotVar:lstlVolunteerSlot){
            
            //Checking if new Volunteers exists in Existing Volunteer Slot map
            if(mapVolunteerSlot.get(oSlotVar.Volunteer__c)!=null)
                lstError.add(oSlotVar);
        }
        
        //Throwing error for Duplicate Volunteer 
        if(lstError.size()>0)
            lstError.get(0).addError(System.Label.DuplicateVolunteerError);   
            //This Volunteer is already added under related Volunteer shift

    }

}