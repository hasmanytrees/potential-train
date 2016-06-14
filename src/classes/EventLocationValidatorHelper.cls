public without Sharing class EventLocationValidatorHelper{

    /*
    **********************************************************************
    Name             : EventLocationValidatorHelper
    Description      : Helper class used for Validating the Venue if that has 
                       been added by any other Event Location and assingning 
                       of Event Owner as Location Owner.                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer           Date              Description
    ---------------------------------------------------------------------------
    Sumeet              26/01/2014       Created
    Sumeet              02/02/2015       Modified for code re-factoring 
                                         optimization which includes proper 
                                         commenting and alignment as well.
    *************************************************************************/

    /**
    * Method name  : checkIfEventUsedBefore
    * Description  : Use this method to validate if the Venue has been used by 
    *                any other event location for the same time and then throws 
                    an error. 
    * Return Type  : void
    * Parameter    : List<Campaign> listNewCampaign,boolean bIsUpdate,
    Map<Id,Campaign> mapNewCampaign
    **/ 
    
    public static void  checkIfEventUsedBefore(List<Campaign> lstNewCampaign,
    boolean bIsUpdate,Map<Id,Campaign> mapNewCampaign){

        Set<id> setVenueId=new Set<Id>();
        Map<Id,Campaign> mapCampaignVenue=new Map<Id,Campaign>();
        Map<Id,List<Campaign>> mapVenuecampaign=new Map<Id,List<Campaign>>();
        for(Campaign oCampaignVar: lstNewCampaign) 
        setVenueId.add(oCampaignVar.Venue__c);
        
     //Loop is executed to retrieve the list of campaigns related to this venue
        for(Id venueIdVar: setVenueId) {  
            List<Campaign> lstCampaignVar=new List<Campaign>();
            for(Campaign oCampaignVar: lstNewCampaign) {
                if(oCampaignVar.Venue__c==venueIdVar){
                    lstCampaignVar.add(oCampaignVar);
                    
                }
            }
            mapVenuecampaign.put(venueIdVar,lstCampaignVar);
        }  
        Schema.DescribeSObjectResult campaignSchema = 
        Schema.SObjectType.Campaign; 
        Map<Id,Schema.RecordTypeInfo> mapRecordById = 
        campaignSchema.getRecordTypeInfosById();
        Map<String,Schema.RecordTypeInfo> mapRecordtypeByName = 
        campaignSchema.getRecordTypeInfosByName();        
        id eventLocationRecordTypeId = 
     mapRecordtypeByName.get(System.Label.EventLocationName).getRecordTypeId();    
        List<Campaign> lstCampaign=new List<Campaign>(); 
        
        //Condition checks which basically checks for the event locations which 
        //are not included.
        if(!bIsUpdate)
        lstCampaign=[select Id,Name,StartDate,EndDate,Venue__c from Campaign
        where recordtypeId=:eventLocationRecordTypeId and Venue__c IN
        :setVenueId and StartDate!=null and EndDate!=null and 
        Override_Venue_Conflict__c=false]; 
        else
        lstCampaign=[select Id,Name,StartDate,EndDate,Venue__c from Campaign 
        where recordtypeId=:eventLocationRecordTypeId and Venue__c IN 
        :setVenueId and Id NOT IN :mapNewCampaign.keySet() and StartDate!=null
        and EndDate!=null and Override_Venue_Conflict__c=false];  
        
        //Loop is executed which identifies the start and end dates values and
        //put them together with the campaign map which is then put them in 
        //separate maps.
        for(Campaign oCampaignVar: lstCampaign){ 
            
            for(Campaign oCampaignNewVar :
            mapVenuecampaign.get(oCampaignVar.Venue__c )){
                
                if((oCampaignNewVar.StartDate!=null)&&
            ((oCampaignNewVar.StartDate <=oCampaignVar.StartDate.addDays(14))&&
            (oCampaignNewVar.StartDate>=oCampaignVar.StartDate))||
            ((oCampaignNewVar.StartDate>=oCampaignVar.StartDate.addDays(-14))&&
            (oCampaignNewVar.StartDate<=oCampaignVar.StartDate)))
                mapCampaignVenue.put(oCampaignVar.Venue__c,oCampaignVar);
                
                else if((oCampaignNewVar.EndDate!=null)&&
                ((oCampaignNewVar.EndDate>=oCampaignVar.EndDate.addDays(14))&&
                (oCampaignNewVar.EndDate<=oCampaignVar.EndDate))||
                ((oCampaignNewVar.EndDate>=oCampaignVar.EndDate.addDays(-14))&&
                (oCampaignNewVar.EndDate<=oCampaignVar.EndDate)))   
                mapCampaignVenue.put(oCampaignVar.Venue__c,oCampaignVar);
                
                else if((oCampaignNewVar.EndDate!=null)&&
                (oCampaignNewVar.StartDate!=null)&&
                (oCampaignNewVar.StartDate!=null)&&
                (oCampaignNewVar.StartDate<=oCampaignVar.StartDate)&&
                (oCampaignNewVar.EndDate>=oCampaignVar.EndDate))   
                mapCampaignVenue.put(oCampaignVar.Venue__c,oCampaignVar); 
                
                else  if((oCampaignNewVar.StartDate!=null)&&
                (oCampaignNewVar.EndDate!=null)&&
                ((oCampaignNewVar.StartDate<=oCampaignVar.EndDate.addDays(14))
                &&(oCampaignNewVar.StartDate>=oCampaignVar.EndDate))||
                ((oCampaignNewVar.StartDate>=oCampaignVar.EndDate.addDays(-14))
                &&(oCampaignNewVar.StartDate<=oCampaignVar.EndDate)))
                mapCampaignVenue.put(oCampaignVar.Venue__c,oCampaignVar);    
                
                else if((oCampaignNewVar.EndDate!=null)&&
                (oCampaignNewVar.StartDate!=null)&&
                ((oCampaignNewVar.EndDate>=oCampaignVar.StartDate.addDays(14))
                &&(oCampaignNewVar.EndDate<=oCampaignVar.StartDate))||
                ((oCampaignNewVar.EndDate>=oCampaignVar.StartDate.addDays(-14))
                &&(oCampaignNewVar.EndDate<=oCampaignVar.StartDate)))   
                mapCampaignVenue.put(oCampaignVar.Venue__c,oCampaignVar);       
                
            } 
        }
        
        //Condition which checks for the campaign list and the new Campaign List
        //is then checked for raising the map if the id is present in the map 
        //created above.
        if(lstCampaign.size()>0){
            
            for(Campaign oCampaignVar: lstNewCampaign){
                
                if(mapCampaignVenue.get(oCampaignVar.Venue__c)!=null){
                    try
                    {
                        Trigger.New.get(0).addError
   ('The Venue is occupied for entered time duration for Event Location : <a href="/'
   +mapCampaignVenue.get(oCampaignVar.Venue__c).Id+'">'
   +mapCampaignVenue.get(oCampaignVar.Venue__c).Name+'</a>',false);
                    } 
                    catch(Exception ex)
                    {
      
                    }
                    
                }
            }
        }

    }

    public static void updateDateTime(List<campaign> lstCampaign){

        for(Campaign oCampaignVar: lstCampaign){
            
            if( oCampaignVar.StartDate!=null){ 
                Integer iStartMOnth=oCampaignVar.StartDate.month();
                Integer iStartDay=oCampaignVar.StartDate.Day();
                Integer iStartYear=oCampaignVar.StartDate.Year();
                String sStartDate=String.valueOF(iStartMOnth)+'/'+
                String.valueOF(iStartDay)+'/'+String.valueOf(iStartYear);
                if(oCampaignVar.EVE_Start_Time__c!=null){
                    oCampaignVar.EVE_Start_Datetime__c = 
                Datetime.parse(sStartDate+' '+oCampaignVar.EVE_Start_Time__c);
                }
            }  
            if( oCampaignVar.EndDate!=null){ 
                Integer iEndMOnth=oCampaignVar.EndDate.month();
                Integer iEndDay=oCampaignVar.EndDate.Day();
                Integer iEndYear=oCampaignVar.EndDate.Year();
                String sEndDate=String.valueOF(iEndMOnth)+'/'+
                String.valueOF(iEndDay)+'/'+String.valueOf(iEndYear);
                if(oCampaignVar.EVE_End_Time__c!=null){
                    oCampaignVar.EVE_End_Datetime__c = 
                    Datetime.parse(sEndDate+' '+oCampaignVar.EVE_End_Time__c);
                }
            }
        } 
    }

    public static void updateVolunteerCoordinatorLookup(Map<String,Campaign> 
    mapVCNameEventLocation){

        Map<Id, User> mapUser=new Map<Id,User>();
        List<Campaign> lstCampaign=new List<Campaign>();
        try{
           mapUser=new Map<Id,User>([select Id,Name,Email,Phone from User where
           Name IN :mapVCNameEventLocation.keySet()]);
            
            for(Id userIdVar: mapUser.KeySet()){
                
                if(mapUser.get(userIdVar)!=null){
                    
                    Campaign oCampaignVar = 
                    mapVCNameEventLocation.get(mapUser.get
                    (userIdVar).Name.toUpperCase());
                    
                    oCampaignVar.Published_Volunteer_Coordinator_Lookup__c =
                    userIdVar;
                    lstCampaign.add(oCampaignVar);
                }               
            }            
        }
        catch(Exception ex)
        {      
           
        }
    }    

}