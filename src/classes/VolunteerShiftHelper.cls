/******************************************************************************
    Name             : VolunteerShiftHelper
    Description      : Trigger Helper class used to handle the scenario of auto 
    follow and unfollow account for account Owner                   
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring &
 optimization
*******************************************************************************/

public without Sharing class VolunteerShiftHelper
{
    
    /**
    * Method name  : createVolunteerSlots
    * Description  :This method is used for assigning Volunteer Slots as 
    *                mentioned in the Initial Requested Slots Field
    * Return Type  : List<Volunteer_Shift__c>
    * Parameter    : void
    **/   
    
    public static void createVolunteerSlots(List<Volunteer_Shift__c>
    lstNewVolunteerShift)
    {
     List<Volunteer_Slot__c> lstTotalVolunteer = new List<Volunteer_Slot__c>();
        
        for(Volunteer_Shift__c oVolunteerReferenceVar: lstNewVolunteerShift)
        {
           if(oVolunteerReferenceVar.Initial_Number_Of_Slots_Requested__c <> 0)
            {
                Integer iRequiredSlots;
                for(iRequiredSlots = 0; iRequiredSlots <
                oVolunteerReferenceVar.Initial_Number_Of_Slots_Requested__c; 
                iRequiredSlots++)
                {
                 // Creating Empty Slots with Status Available based on Initial 
                 //Number of Slot Requested field and adding them to List
                Volunteer_Slot__c oSlotReferenceVar = new Volunteer_Slot__c();
               oSlotReferenceVar.Volunteer_Shift__c = oVolunteerReferenceVar.id;
                oSlotReferenceVar.Status__c = System.label.VolunteerSlotStatus;
                lstTotalVolunteer.add(oSlotReferenceVar);
                }
            }
            
        }
        
        
        if(lstTotalVolunteer <> NULL && lstTotalVolunteer.size() > 0)
        {
            try
            {
                insert lstTotalVolunteer;   //Inserting Volunteer Slots
            }
            catch(Exception ex)
            {
                String sRelatedRecordIds = '';
                for(Volunteer_Slot__c oVolunteerSlotVar : lstTotalVolunteer)
                {
                    sRelatedRecordIds += oVolunteerSlotVar.id ;
                }
                //Creating a new Error Log record whenever any exception is 
                //encountered while performing DML Operation
                Utility.insertErrorLogApplication(ex
                .getMessage()+'\n'+ex.getStackTraceString(),
                'Volunteer Slots',String.valueOf(sRelatedRecordIds),
                'VolunteerShiftHelper','createVolunteerSlots','Application',
                UserInfo.getUserId(), String.valueOf(lstTotalVolunteer),null);
                
            }
        }
    }
    
   /**
    * Method name  : updateVolunteerSlots
    * Description  :This method is used for update Volunteer Slots datetime 
    *               fields
    * Return Type  : Map<Id,Volunteer_Shift__c>
    * Parameter    : void
    **/    
    
    public static void updateVolunteerSlots(Map<Id,Volunteer_Shift__c>
    mapNewVShift){
   
     List<Volunteer_Slot__c> lstVolunteerSlot=new  List<Volunteer_Slot__c>();
     lstVolunteerSlot=[select Id,Volunteer_Role__c ,Volunteer_Shift__c 
     from Volunteer_Slot__c where Volunteer_Shift__c IN :mapNewVShift.keySet()];
   
     
     if(lstVolunteerSlot.size()>0)
       update lstVolunteerSlot;
   
   }  
    
}