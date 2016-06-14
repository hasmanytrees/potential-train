/****************************************************************************
    Name             : CampaignLocationBORESTService
    Description      : This REST webservice is used to Call to query all Slot 
                        for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014         Created
Subhojit                29/01/2015         Modified for code re-factoring
                                           & optimization
*****************************************************************************/
@RestResource(urlMapping='/events/locations/search/*')
global class CampaignLocationBORESTService
{
    //Constructor
    @HttpGet
    global static void getCampaignLocation() {
        //Setting Default Response code
        RestContext.response.statusCode = 200 ; 
        try{
            String sFilterDate= 
            RestContext.request.params.get(System.Label.filterdatestart);
            String sEventLocationId= 
            RestContext.request.params.get(System.Label.eventlocationid);
            Id recordtypeId=
            Utility.getRecordtype(
            System.Label.Recordtype_EventLocation,
            System.Label.Recordtype_Campaign);
            List<Campaign> lstCampaign=new List<Campaign>();
            
            if((sFilterDate!=null)&&(sEventLocationId==null)){
                //Checking for Event location search beased on 
                //only date parameters.
                //Formating date back to SFDC format
                Date dStartDate=((Datetime)JSON.deserialize(
                '"'+sFilterDate+'"',datetime.class)).date();
                lstCampaign=[select Id,Name,Description,StartDate,EndDate,
                Dress_Code__c,Dress_Code_Details__c,LastModifiedDate,
                Published_Volunteer_Coordinator_Name__c,
                Published_Location_Description__c,Published_Location_Name__c,
                Published_Volunteer_Coordinator_Email__c,
                Primary_Compassion_Contact_Name__c,Partner_Website__c,
                Primary_Compassion_Contact_Cell_Phone__c,
                Venue__r.Id,Venue__r.Name,Venue__r.Address_1__c,
                Venue__r.Address_2__c,Venue__r.Address_3__c,Venue__r.State__c,
                Venue__r.Country__c,Venue__r.Zip_Code__c,
                Venue__r.City__c,Primary_Compassion_Contact_Email__c,
                EVE_End_Datetime__c, EVE_Start_Datetime__c
                from Campaign where Status!=:System.label.Cancelled and 
                Publish_To_Web__c=true and EVE_End_Datetime__c!=null 
                and EVE_End_Datetime__c!=null and  StartDate >=:dStartDate 
                and Venue__c != null
                and recordtypeId=:recordtypeId order by StartDate];
                

            }
            else if((sFilterDate==null)&&(sEventLocationId!=null)){
                //Checking for Event location search beased on only 
                //given Event Location Id parameters. 
                lstCampaign=[select Id,Name,Description,StartDate,EndDate,
                Dress_Code__c,Dress_Code_Details__c,LastModifiedDate,
                Published_Volunteer_Coordinator_Name__c,
                Published_Location_Description__c,Published_Location_Name__c,
                Published_Volunteer_Coordinator_Email__c,
                Primary_Compassion_Contact_Name__c,Partner_Website__c,
                Primary_Compassion_Contact_Cell_Phone__c,
                Venue__r.Id,Venue__r.Name,Venue__r.Address_1__c,
                Venue__r.Address_2__c,Venue__r.Address_3__c,Venue__r.State__c,
                Venue__r.Country__c,Venue__r.Zip_Code__c,
                Venue__r.City__c,Primary_Compassion_Contact_Email__c,
                EVE_End_Datetime__c,EVE_Start_Datetime__c 
                from Campaign where Id=:sEventLocationId 
                and Status!=:System.label.Cancelled 
                and Venue__c != null
                and recordtypeId=:recordtypeId  
                and Publish_To_Web__c=true order by StartDate];
                
                
                
            }
            RestContext.response.addHeader('Content-Type', 'application/json');  
            if(lstCampaign.size()==0){
                if((sFilterDate!=null)&&(sEventLocationId==null))
                //If no Event Location Found with in user given date
                RestContext.response.statusCode = 200 ;         
                else if((sFilterDate==null)&&(sEventLocationId!=null))
                 //If user has provided invalid Evnet location Id
                RestContext.response.statusCode = 404 ;          
                return;

            }else{

                List<Map<String,List<sObject>>> lstOutputMap= 
                new List<Map<String,List<sObject>>>();
                
                for(Campaign oCampaignVar: lstCampaign){
                    
                    Map<String,List<sObject>> mapOutputVar= 
                    new Map<String,List<sObject>>();
                    mapOutputVar.put(
                    'CampaignLocationBOCampaignResponseGroup',
                    new List<sObject>{oCampaignVar});
                    Venue__c oVenueVar=new Venue__c();
                    if(oCampaignVar.Venue__c!=null){
                        //Ganthering Venuw Information
                        oVenueVar.Name=oCampaignVar.Venue__r.Name;
                        oVenueVar.Address_1__c=
                        oCampaignVar.Venue__r.Address_1__c;
                        oVenueVar.Address_2__c=
                        oCampaignVar.Venue__r.Address_2__c;
                        oVenueVar.Address_3__c=
                        oCampaignVar.Venue__r.Address_3__c;
                        oVenueVar.City__c=
                        oCampaignVar.Venue__r.City__c;
                        oVenueVar.State__c=
                        oCampaignVar.Venue__r.State__c;
                        oVenueVar.Zip_Code__c=
                        oCampaignVar.Venue__r.Zip_Code__c;
                        oVenueVar.Country__c=
                        oCampaignVar.Venue__r.Country__c;
                    }
                    mapOutputVar.put('CampaignLocationBOVenueResponseGroup',
                    (oCampaignVar.Venue__r.size()>0)?
                    oCampaignVar.Venue__r:new List<Venue__C>());
                    lstOutputMap.add(mapOutputVar);
                }
                
                //Generating JSON String
                String sResponse=
                JSONHandlerMethods.serializeBulk(lstOutputMap,
                'CampaignLocationBOCampaignResponse');  
                RestContext.response.responseBody = Blob.valueOf(sResponse);
            }     
        }
        catch(Exception ex){
        
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'
            +ex.getStackTraceString(),'CampaignLocationBORESTService'
            ,'Integration'
            ,'CampaignLocationBORESTService','Inbound Call'
            ,URL.getSalesforceBaseUrl().toExternalForm()
            +'/services/apexrest/'+RestContext.request.requestURI+'?'
            +Utility.retrieveRESTParameters(
            RestContext.request.params.keyset()).subStringBeforeLast('&')
            ,UserInfo.getUserId(),'getCampaignLocation');
        } 
    }
}