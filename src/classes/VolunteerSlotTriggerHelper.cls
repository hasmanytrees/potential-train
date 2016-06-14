/*****************************************************************************
    Name             : VolunteerSlotTriggerHelper
    Description      : Trigger Helper class used to handle the scenario of 
                       checking Duplicate Volunteer Slot                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014         Created
Subhojit              29/01/2015         Modified for code re-factoring & 
                                         optimization
******************************************************************************/
public with Sharing class VolunteerSlotTriggerHelper{

    public static Integer iReckCheck=0;  //Variable to prevent recursion

    /**
    * Method name  : checkDuplicateVolunteer
    * Description  :This method is used for assigning Volunteer Slots as 
    *                mentioned in the Initial Requested Slots Field
    * Return Type  : List<Volunteer_Shift__c>,Map<Id,Volunteer_Slot__c> ,
                     Map<Id,Volunteer_Slot__c>,boolean
    * Parameter    : void
    **/   
    
    public static void checkDuplicateVolunteer(List<Volunteer_Slot__c> 
    lstNewVolunteerSlot,Map<Id,Volunteer_Slot__c> mapNewVSlot,
    Map<Id,Volunteer_Slot__c> mapOldVSlot,boolean bIsUpdate){

        
      Map<Id,Volunteer_Slot__c>  mapFinalVSlot=new Map<Id,Volunteer_Slot__c>();
        
        //This condition checks for the null value in Map
        if(mapOldVSlot <> null)
        {
            for(Id oVSlotIdVar: mapOldVSlot.keySet()){
       // Filtering out volunteer slots with blank,Declined,Completed Status 
       //from Validation list
            if((mapOldVSlot.get(oVSlotIdVar).Volunteer__c 
            !=mapNewVSlot.get(oVSlotIdVar).Volunteer__c)&&
            (mapNewVSlot.get(oVSlotIdVar).Status__c!=null)
            &&((mapNewVSlot.get(oVSlotIdVar).Status__c!='Declined')
            &&(!mapNewVSlot.get(oVSlotIdVar).Status__c.contains('Cancelled'))))
            mapFinalVSlot.put(oVSlotIdVar,mapNewVSlot.get(oVSlotIdVar));
            }
        }
        
        if(!bIsUpdate)
  VolunteerSlotValidationHelper.checkForDuplicateVolunteer(lstNewVolunteerSlot); 
  //Initiating Volunteer Slot Duplicate Check helper for insert scenario.
        else
        VolunteerSlotValidationHelper.checkForDuplicateVolunteer
        (mapFinalVSlot.values()); 
        //Initiating Volunteer Slot Duplicate Check helper for update scenario.
        iReckCheck++;
    }
    
    /**
    * Method name  : updateDateTime
    * Description  :This method is used to update date time fields on volunteer 
    *                Slot based on Volunteer Shift.
    * Return Type  : List<Volunteer_Shift__c>,Map<Id,Volunteer_Slot__c> 
                    ,Map<Id,Volunteer_Slot__c>,boolean
    * Parameter    : void
    **/ 
    
   public static void updateDateTime(List<Volunteer_Slot__c> lstVolunteerSlot){

        Set<Id> setVShiftId=new Set<Id>();
        Map<Id,String> mapIdStartDateString =new Map<Id,String>();
        Map<Id,String> mapIdEndDateString =new Map<Id,String>();
        for(Volunteer_Slot__c oVolunteerSlotVar: lstVolunteerSlot)
        setVShiftId.add(oVolunteerSlotVar.Volunteer_Shift__c);
      List<Volunteer_Shift__c> lstVolunteerShift=new List<Volunteer_Shift__c>();
        lstVolunteerShift=[select Id,Date__c,End_Time__c,Start_Time__c
        from Volunteer_Shift__c where Id IN :setVShiftId];
        if(lstVolunteerShift.size()>0){
            
            for(Volunteer_Shift__c oVolunteerShiftVar: lstVolunteerShift){
                
                if((oVolunteerShiftVar.Date__c!=null)&&
                (oVolunteerShiftVar.Start_Time__c!=null)&&
                (oVolunteerShiftVar.End_Time__c!=null)){
                    mapIdStartDateString.put(oVolunteerShiftVar.Id,
                    oVolunteerShiftVar.Start_Time__c);
                    
                    mapIdEndDateString.put(oVolunteerShiftVar.Id,
                    oVolunteerShiftVar.End_Time__c);
                }
            }
            
        }
        System.debug(lstVolunteerSlot);
        for(Volunteer_Slot__c oVolunteerSlotVar: lstVolunteerSlot){
            Integer iMOnth=oVolunteerSlotVar.Date__c.month();
            Integer iDay=oVolunteerSlotVar.Date__c.Day();
            Integer iYear=oVolunteerSlotVar.Date__c.Year();
            String sDate=String.valueOF(iMOnth)+'/'+String.valueOF(iDay)+'/'+
            String.valueOf(iYear);
            string sDateTime = '' ;
            if(mapIdStartDateString.get(oVolunteerSlotVar.Volunteer_Shift__c)
            !=null){
                sDateTime = String.valueof(Datetime.parse
                (sDate+' '+mapIdStartDateString.get
                (oVolunteerSlotVar.Volunteer_Shift__c)));
                oVolunteerSlotVar.Volunteer_Slot_Start_Date__c = 
                Datetime.valueOf(sDateTime);
            }
            if(mapIdEndDateString.get(oVolunteerSlotVar.Volunteer_Shift__c)
            !=null){
                sDateTime = String.valueof
                (Datetime.parse(sDate+' '+mapIdEndDateString
                .get(oVolunteerSlotVar.Volunteer_Shift__c)));
                oVolunteerSlotVar.Volunteer_Slot_End_Date__c
                = Datetime.valueOf(sDateTime);
            }
                            
        }
        iReckCheck++;
    }


}