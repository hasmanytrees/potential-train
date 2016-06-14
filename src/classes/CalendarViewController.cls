/***************************************************************************
    Name             : CalendarViewController
    Description      : Page Controller for Calender_View page           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                                & optimization
*****************************************************************************/
public without sharing  class CalendarViewController {

    public Boolean bIncludeMyEvents {get;set;}
    //Object of the internal class which holds details for each event 
    //like startDate,endDate etc.
    public transient list<CalEvent> lstEvents {get;set;}     
  
    public String sOrgServer{get;set;}
    public List<SelectOption> lstFilter{get;set;}
  
    public String sSelectedFilter{get;set;}
    //The calendar plugin is expecting dates is a certain format. 
    //We can use this string to get it formatted correctly
    Final String sDtFormat = 'EEE, d MMM yyyy HH:mm:ss';    
    //storing date format
    public campaign oCampOwner{get;set;}   
    public Campaign oEventFilter{get;set;}
    public Campaign oEventLocationFilter{get;set;}
    public Campaign oCampaignFilter{get;set;}
    public List<SelectOption> lstUnselectedSelectOption{get;set;}
    public List<SelectOption> lstSelectedSelectOption{get;set;}
    
    public Deliverable__c oDeliverableFilter{get;set;}
    Map<String,Id> mapRecordTypeCampiagn{get;set;}
    Map<String,Id> mapRecordTypeDeliverable{get;set;} 
    public boolean bShowDeliverable{get;set;}  
    public boolean bShowEvent{get;set;}  
    public boolean bShowEventLocation{get;set;}  
    public boolean bShowCampaign{get;set;}    
    public boolean bShowBasicFilter{get;set;} 
    public boolean bShowCampaignGrid{get;set;}    
    public boolean bShowEventGrid{get;set;} 
    public boolean bShowMeetingGrid{get;set;}
    public boolean bShowFilter{get;set;}
    public boolean bShowInitial{get;set;}
    public String sVenueState{get;set;} 
    public String sEventId{get;set;}
      
    //These final variables have been added which is used primarily to override 
    //the FLS.
    //for those profiles where create permission has not been provided.
    private final Id campaignId = System.label.DummyCampaignId;
    private transient Schema.DescribeSObjectResult delierableTabId = 
    Schema.SObjectType.Deliverable__c;
    private final Id deliverableId = delierableTabId.getKeyPrefix() + 
    System.label.DummyDeliverableId;
        
    /**
    * Method name  : Constructor
    * Description  : This method  calls the init method
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public CalendarViewController() {
    
        init();
    }
    
    /**
    * Method name  : init
    * Description  : This method  fired to instantiate member variables
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    private void init(){

        //Default showing my listEvents to on
        bIncludeMyEvents = true;
        //Getting the server Instance Id 
        sOrgServer = System.URL.getSalesforceBaseUrl().getHost().remove('-api')
        .subStringBefore('.');      
        
        //below line fetch the pick list values using describe call for Campaign
        //Type and Channel.
        Schema.DescribeFieldResult fieldResult = Campaign.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        oCampOwner=new Campaign();
       
        lstFilter=new List<SelectOption>();
        lstFilter.add(new SelectOption('','-None-'));
        
        
        fieldResult = Campaign.EVE_Channel__c.getDescribe();
        mapRecordTypeCampiagn = 
        Utility.getRecordTypeMap(System.label.CampaignObject);
        mapRecordTypeDeliverable = 
        Utility.getRecordTypeMap(System.label.Deliverable_Object);
        sSelectedFilter='';
       
        sSelectedFilter=ApexPages.CurrentPage().getParameters().get('type');
        
        if(sSelectedFilter.contains('Event')){
            lstFilter.add(new SelectOption(System.label.Recordtype_Event,
            System.label.Recordtype_Event));
           lstFilter.add(new SelectOption(System.label.Recordtype_EventLocation,
            System.label.Recordtype_EventLocation));
            bShowEventGrid=true;
            
        }
        else if(sSelectedFilter.contains(System.Label.Filter_Condition)){
            bShowCampaignGrid=false;
        }
        else{
            
            lstFilter.add(new SelectOption(System.label.DeliverableObject,
            System.label.DeliverableObject));
            lstFilter.add(new SelectOption(System.label.Recordtype_Campaign,
            System.label.Recordtype_Campaign)); 
            bShowCampaignGrid=true;
        }
        
        bShowBasicFilter=true;
        oEventFilter=
        new Campaign(recordTypeId = 
        mapRecordTypeCampiagn.get(System.label.Recordtype_Event));
        oEventLocationFilter=
        new Campaign(recordTypeId = 
        mapRecordTypeCampiagn.get(System.label.Recordtype_EventLocation));
        oCampaignFilter = 
        new Campaign(recordTypeId = 
        mapRecordTypeCampiagn.get(System.label.Recordtype_Campaign), 
        id = campaignId);
       
        oDeliverableFilter=new Deliverable__C(id= deliverableId,
        RecordTypeId = 
        mapRecordTypeDeliverable.get(System.label.CampaignDeliverable));
        
        if(ApexPages.CurrentPage().getParameters().get('eventId')!=null){
            sEventId=ApexPages.CurrentPage().getParameters().get('eventId');
            bShowFilter=false;
            if(sSelectedFilter.contains(System.Label.Filter_Condition))
            sSelectedFilter='Campaign Meeting';
            else
            sSelectedFilter='Event and Event Location';
            
        }
        else
        bShowFilter=true; 
        bShowInitial=true;
        lstUnselectedSelectOption=new List<selectOption>();
        lstSelectedSelectOption=new List<selectOption>();

   for(String picklistVar:System.label.CampaignDeliverableRecordtype.split(','))
       lstUnselectedSelectOption.add(new SelectOption(picklistVar,picklistVar));

    }
    /**
    * Method name  : pageLoad
    * Description  : This method loads the actual data for calender 
    *                
    * Return Type  : PageReference
    * Parameter    : void
    **/  
    public PageReference pageLoad() {
        lstEvents = new list<CalEvent>();
        Date dLast30Days=System.today().addDays(-30);
        
        //Get Deliverables details for Calendar
        if(( sSelectedFilter!=null)&&
        (sSelectedFilter.contains(System.Label.Object_Deliverable)))  {
            String sQueryDeliverable='select Id, Name,Campaign__c, Drop_Date__c,CreatedDate,Type__c from Deliverable__c where recordtypeId= \''+mapRecordTypeDeliverable.get(System.label.CampaignDeliverable)+'\' and';
            
            //Forming Query computing filters   
             if(lstSelectedSelectOption.size()>0)
            {
                
               List<String> lstType=new List<String>();
               for(SelectOption selectedTypeVar: lstSelectedSelectOption)
                 lstType.add(selectedTypeVar.getValue());
             
            sQueryDeliverable+=' Type__c IN :lstType and ';
            }
            
            if(oDeliverableFilter.Drop_Date__C!=null)
            {
                Date dtDropDate=oDeliverableFilter.Drop_Date__c;
                sQueryDeliverable+=' Drop_Date__c>=:dtDropDate and ';
                
            }
           if(!bShowInitial) 
            sQueryDeliverable+=' Id!=null and Drop_Date__c!=null and Status__c!=\'+ :System.Label.Cancelled +\' and Status__c!=\'+ :System.Label.Draft +\'  limit 5000';
           else{
              
              sQueryDeliverable+=' Id!=null and Drop_Date__c!=null and Status__c!=\'+ :System.Label.Cancelled +\' and Status__c!=\'+ :System.Label.Draft +\' and Drop_Date__c>=:dLast30Days limit 5000'; 
              
              
              }           
           
            
            //Querying Deliverable and forming data in necessary format
            
            for(Deliverable__c camp :
            (List<Deliverable__c>)Database.query(sQueryDeliverable))
            {
                
                Integer i=0;
                DateTime dttStartDueDT;
                DateTime dttEndDueDT;
                if(camp.Drop_Date__c!=null)
                {
                    //Defaulting Start and end date  
                    dttStartDueDT=DateTime.newInstance(camp.Drop_Date__c,
                    Time.newInstance(13,0,0,0));
                    dttEndDueDT = DateTime.newInstance(camp.Drop_Date__c,
                    Time.newInstance(17,0,0,0));
                    
                    i++;
                }
                
                if(i==1)            
                {                        
                    //Setting values in event list
                    CalEvent campEvent = new CalEvent();                        
                    campEvent.sTitle = String.escapeSingleQuotes(camp.Name);   
                    campEvent.bAllDay=true;         
                    campEvent.sStartString = dttStartDueDT.format(sDtFormat);   
                    campEvent.sEndString = dttEndDueDT.format(sDtFormat);           
                    campEvent.sUrl = '/' + camp.Id;            
                    campEvent.sClassName = 'event-deliverable';              
                          
                    lstEvents.add(campEvent);
                }       
            }
        }
        
        
        
        
        //Getting Campaign Details for Calender
        
        if(( sSelectedFilter!=null)&&(sSelectedFilter.contains('Campaign'))&&
        (!sSelectedFilter.contains(System.Label.Filter_Condition)))  {   
            String sQueryCampaign='select Id, Name,StartDate,EndDate,Launch_Date__c,Type,CreatedDate,Date_Of_Submission__c from Campaign where recordtypeId= \''+mapRecordTypeCampiagn.get(System.label.Recordtype_Campaign)+'\' and';
            
            
            //Forming query based on filter
            if(oCampaignFilter.EndDate!=null){
                
                Date dtEndDate= oCampaignFilter.EndDate;
                sQueryCampaign+=' EndDate<=:dtEndDate and ';
                
            }
            
            if(oCampaignFilter.Launch_Date__c !=null)
            {
                Date dtLaunchDate= oCampaignFilter.Launch_Date__c;
                sQueryCampaign+=' Launch_Date__c>=:dtLaunchDate and ';
                
            }
            
            if(oCampaignFilter.Type!=null)
            {
                
                sQueryCampaign+=' Type=\''+oCampaignFilter.Type+'\' and ';
                
            }
            
            
            if(oCampaignFilter.Date_Of_Submission__c!=null)
            {
                
                
                Datetime dttCreatedDate = 
                Datetime.newInstance(oCampaignFilter.Date_Of_Submission__c,
                Time.newInstance(0,0,0,0));
                Datetime dttCreatedDateEndRange=dttCreatedDate.addDays(120);
                sQueryCampaign+=
' CreatedDate>=:dttCreatedDate and CreatedDate<= :dttCreatedDateEndRange and';
                
            }
           if(!bShowInitial) 
            sQueryCampaign+=' Id!=null and Date_Of_Submission__c!=null and EndDate!=null and Status!=\'+ :System.Label.Cancelled + \' and Status!=\'+ :System.Label.Draft + \' limit 5000';
        
           else{
              sQueryCampaign+=' Id!=null and Date_Of_Submission__c!=null and EndDate!=null and Status!=\'+ :System.Label.Cancelled + \' and Status!=\'+ :System.Label.Draft + \' and Date_Of_Submission__c>=:dLast30Days limit 5000';
             
            }
           
            
            
            
            //Querying Campaign based on filter
            for(Campaign camp : (List<Campaign>)Database.query(sQueryCampaign))
            {
                
            Integer i=0;
            DateTime dttStartDueDT;
            DateTime dttEndDueDT;
            if((camp.Date_Of_Submission__c!=null)&&(camp.EndDate!=null))
            {
            //Setting default 9 AM to 5 PM time as Campaign record type data 
            //does not have time..
            dttStartDueDT =
    Datetime.newInstance(camp.Date_Of_Submission__c,Time.newInstance(9,0,0,0));
    dttEndDueDT =Datetime.newInstance(camp.EndDate,Time.newInstance(17,0,0,0));
            i++;
            }
            if(i==1)            
            {                        
                    CalEvent campEvent = new CalEvent();                        
                    campEvent.sTitle  = String.escapeSingleQuotes(camp.Name);            
                    campEvent.sStartString = dttStartDueDT.format(sDtFormat);   
                    campEvent.sEndString = dttEndDueDT.format(sDtFormat);           
                    campEvent.sUrl = '/' + camp.Id;     
                    campEvent.bAllDay =true;       
                    campEvent.sClassName = 'event-campaign';                  
                       
                    lstEvents.add(campEvent);
                }       
            }   
            
        }
        //Getting Details for Event Location 
        if(( sSelectedFilter!=null)&&(sSelectedFilter.contains('Location')))  {  
            String sQueryEventLocation='select Id, Name,StartDate,EndDate,Type,State__c,EVE_Start_Time__c,EVE_End_Time__c from Campaign  where recordtypeId= \''+mapRecordTypeCampiagn.get(System.label.Recordtype_EventLocation)+'\' and';
            
            
            //Forming query based on filter
            
            
            if(oEventLocationFilter.StartDate !=null)
            {
                Date dtStartDate=oEventLocationFilter.StartDate ;
                sQueryEventLocation+=' StartDate>=:dtStartDate and ';
                
            }
            
            if(oEventLocationFilter.EndDate!=null)
            {
                Date dtEndDate=oEventLocationFilter.EndDate ;
                sQueryEventLocation+=' EndDate<=:dtEndDate and ';
                
            }
            
            
            if((sVenueState!='')&&(sVenueState!=null))
            {
                
                sQueryEventLocation+=' State__c=:sVenueState and ';
                
            }
            if((sEventId!='')&&(sEventId!=null))
            {
                
                sQueryEventLocation+=' Event__c=:sEventId and ';
            }
           if(!bShowInitial) 
            sQueryEventLocation+=' Id!=null and StartDate!=null and EndDate!=null and EVE_Start_Time__c!=null and EVE_End_Time__c!=null and status!=\'Cancelled\' and Status!=\'Location Lost\' and Status!=\'Draft\' limit 5000';
           else
             sQueryEventLocation+=' Id!=null and StartDate!=null and EndDate!=null and EVE_Start_Time__c!=null and EVE_End_Time__c!=null and status!=\'Cancelled\' and Status!=\'Location Lost\' and Status!=\'Draft\' and StartDate>=:dLast30Days limit 5000';
                      
           
            
            
            
            //Querying Event Location based on formed query
            
        for(Campaign camp : (List<Campaign>)Database.query(sQueryEventLocation))
            {
                
                Integer i=0;
                DateTime dttStartDueDT;
                DateTime dttEndDueDT;
                if((camp.StartDate!=null)&&(camp.EndDate!=null))
                {
                    //Setting Start and End date for calender view
                      Integer iEndMOnth=camp.StartDate.month();
                       Integer iEndDay=camp.StartDate.Day();
                       Integer iEndYear=camp.StartDate.Year();
                       String sStartDate=String.valueOF(iEndMOnth)+'/'+
                       String.valueOF(iEndDay)+'/'+String.valueOf(iEndYear);
                    sStartDate=sStartDate+' '+ Camp.EVE_Start_Time__c;
                    dttStartDueDT=DateTime.parse(sStartDate);
                    
                    iEndMOnth=camp.EndDate.month();
                    iEndDay=camp.EndDate.Day();
                    iEndYear=camp.EndDate.Year();
                    String sEndDate=String.valueOF(iEndMOnth)+'/'+
                    String.valueOF(iEndDay)+'/'+String.valueOf(iEndYear);
                    
                    
                    sEndDate=sEndDate+' '+ Camp.EVE_End_Time__c;
                    dttEndDueDT = DateTime.parse(sEndDate);
                  
                    
                    i++;
                }
                if(i==1)            
                {                        
                    CalEvent campEvent = new CalEvent();                        
                    campEvent.sTitle = String.escapeSingleQuotes(camp.Name);           
                    campEvent.sStartString = dttStartDueDT.format(sDtFormat);   
                    campEvent.sEndString  = dttEndDueDT.format(sDtFormat);           
                    campEvent.sUrl  = '/' + camp.Id;   
                          
                    campEvent.sClassName = 'event-eventlocation';              
                             
                    lstEvents.add(campEvent);
                }       
            }   
            
            
        }    
        // Getting details for Event
        if(( sSelectedFilter!=null)&&(sSelectedFilter.contains('Event'))&&
        ((!(sSelectedFilter.contains('Location')))||
        (sSelectedFilter.contains('and'))))  { 
            String sQueryEvent='select Id, Name,StartDate,EndDate,Type,EVE_Channel__c from Campaign where recordtypeId= \''+mapRecordTypeCampiagn.get(System.label.Recordtype_Event)+'\' and';
            
            //Forming Query based on filter
            if(oEventFilter.StartDate !=null)
            {
                Date dtStartDueDT=oEventFilter.StartDate;
                sQueryEvent+=' StartDate>=:dtStartDueDT and ';
                
            }
            
            if(oEventFilter.EndDate!=null)
            {
                Date dtEndDate=oEventFilter.EndDate;
                sQueryEvent+=' EndDate<=:dtEndDate and ';
                
            }
            
            
            if(oEventFilter.Type!=null)
            {
                
                sQueryEvent+=' Type=\''+oEventFilter.Type+'\' and ';
                
            }
            
            if(oEventFilter.EVE_Channel__c!=null)
            {
                
                sQueryEvent+=' EVE_Channel__c=\''+
                oEventFilter.EVE_Channel__c+'\' and ';
                
            }
            
            if((sEventId!='')&&(sEventId!=null))
            {
                
                sQueryEvent+=' Id=:sEventId and ';
            }
          if(!bShowInitial)  
            sQueryEvent+=' Id!=null and StartDate!=null and EndDate!=null and Status!=\'+ :System.Label.Cancelled + \' and Status!=\'+ :System.Label.Event_Lost + \' and Status!=\'+ :System.Label.Draft +\' limit 5000';           
            else
             sQueryEvent+=' Id!=null and StartDate!=null and EndDate!=null and Status!=\'+ :System.Label.Cancelled + \' and Status!=\'+ :System.Label.Event_Lost + \' and Status!=\'+ :System.Label.Draft +\' and StartDate>=:dLast30Days limit 5000';

          
            
            
            
            //Querying Event record typed Campaign based on filter
            
            for(Campaign camp : (List<Campaign>)Database.query(sQueryEvent))
            {
                
                Integer i=0;
                DateTime dttStartDueDT;
                DateTime dttEndDueDT;
                if((camp.StartDate!=null)&&(camp.EndDate!=null))
                {
                    //
dttStartDueDT = Datetime.newInstance(camp.StartDate,Time.newInstance(9,0,0,0));
dttEndDueDT=Datetime.newInstance(camp.EndDate,Time.newInstance(17,0,0,0));
i++;
                }
                if(i==1)            
                {                        
                    CalEvent campEvent = new CalEvent();                        
                    campEvent.sTitle = String.escapeSingleQuotes(camp.Name);            
                    campEvent.sStartString = dttStartDueDT.format(sDtFormat);   
                    campEvent.sEndString = dttEndDueDT.format(sDtFormat);           
                    campEvent.sUrl = '/' + camp.Id;            
                    campEvent.sClassName = 'event-event';              
                              
                    lstEvents.add(campEvent);
                }       
            }   
            
        }
        
        if((sSelectedFilter!=null)&&
        (sSelectedFilter.contains(System.Label.Filter_Condition)) ) {
            
            String sQueryMeeting=
    'select Id,subject, StartDateTime,EndDateTime from Event where whatId=\''+
    sEventId+'\'';
            bShowMeetingGrid=true;
            for(Event eventVar: (List<Event>)Database.query(sQueryMeeting))
            {
                
                Integer i=0;
                DateTime dttStartDueDT;
                DateTime dttEndDueDT;
                if((eventVar.StartDateTime!=null)&&(eventVar.EndDateTime!=null))
                {
        //Setting default 9 AM to 5 PM time as Campaign with Record type Event 
        //record type data does not have time.
                    dttEndDueDT = eventVar.EndDateTime;
                    dttStartDueDT=eventVar.StartDateTime;
                    i++;
                }
                if(i==1)            
                {                        
                    CalEvent campEvent = new CalEvent();                        
                    campEvent.sTitle = eventVar.Subject;            
                    campEvent.sStartString = dttStartDueDT.format(sDtFormat);   
                    campEvent.sEndString = dttEndDueDT.format(sDtFormat);           
                    campEvent.sUrl = '/' + eventVar.Id;            
                    campEvent.sClassName = 'event-meeting';              
                        
                    lstEvents.add(campEvent);
                }       
            }   
            
        }
        
        

        
      
        return null;
    }
    
    public PageReference toggleMyEvents() {
        if(bIncludeMyEvents){
            bIncludeMyEvents = false;
        }
        else{
            bIncludeMyEvents = true;
        }
        pageload();
        return null;
    }
    
    /**
    * Method name  : showHideFilter
    * Description  : This method  handles visibility of different component 
                    on UI based on selected filter.
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public void showHideFilter(){
        PageReference pg= pageLoad();
        if(sSelectedFilter==System.Label.Object_Deliverable){

            bShowDeliverable=true; //Show Deliverable colour Legend 
            bShowEvent=false; // Don't show Colour Legend of Event 
            bShowEventLocation=false;
            // Don't show Colour Legend of Event Location
            bShowCampaign= false;  // Don't show Colour Legend of Campaign 
            //Don't show basic filter drop down.
            //Instead show customized list of fields as filter on UI.
            bShowBasicFilter= false;  
            oEventFilter=new Campaign();
            oEventLocationFilter=new Campaign();
            oCampaignFilter=new Campaign();
         

        }
        else if(sSelectedFilter=='Event'){

            
            bShowDeliverable=false;  
            bShowEvent=true;  
            bShowEventLocation=false;
            bShowCampaign= false;  
            bShowBasicFilter= false;
           
            oEventLocationFilter=new Campaign();
            oCampaignFilter=new Campaign();
            oDeliverableFilter=new Deliverable__C();


        }
        else if(sSelectedFilter=='Event Location'){

            
            bShowDeliverable=false;  
            bShowEvent=false;  
            bShowEventLocation=true;
            bShowCampaign= false;  
            bShowBasicFilter= false;
            oEventFilter=new Campaign();
         
            oCampaignFilter=new Campaign();
            oDeliverableFilter=new Deliverable__C();

        }
        else if(sSelectedFilter=='Campaign'){

            
            bShowDeliverable=false;  
            bShowEvent=false;  
            bShowEventLocation=false;
            bShowCampaign= false;  
            bShowBasicFilter= false;
            oEventFilter=new Campaign();
            oEventLocationFilter=new Campaign();
         
            oDeliverableFilter=new Deliverable__C();
            bShowCampaign=true;
        }
        else if(sSelectedFilter==System.Label.Filter_Condition){

            
            bShowDeliverable=false;  
            bShowEvent=false;  
            bShowEventLocation=false;
            bShowCampaign= false;  
            bShowBasicFilter= false;
            oEventFilter=new Campaign();
            oEventLocationFilter=new Campaign();
          
            oDeliverableFilter=new Deliverable__C();
            bShowMeetingGrid=true;
            bShowCampaignGrid=false;
        }





    }
    /**
    * Method name  : applyFilter
    * Description  : This method  calls the PageLoad() which controls query and 
    *                forming records to display.
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public void applyFilter(){
        bShowInitial=false;
        PageReference pg= pageLoad();
    } 
    /**
    * Method name  : reset
    * Description  : Method to reset all instantiate variable and filters 
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public PageReference reset() {        
        init();
        bShowDeliverable=false;  
        bShowEvent=false;  
        bShowEventLocation=false;
        bShowCampaign= false;  
        bShowBasicFilter= true;
        bShowInitial=true;
        pageLoad();
        return null;
    }
    
    /**
    * Wrapper Class Name  : CalEvent
    * Description  : Wrapper Class for holding the Calender Event Details for 
    *                displaying to User
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    //Wrapper Class to hold value to display on Calender UI.
    public class CalEvent{
    
        public String sTitle {get;set;}
        public Boolean bAllDay {get;set;}
        public String sStartString {get;set;}
        public String sEndString {get;set;}
        public String sUrl {get;set;}
        public String sClassName {get;set;}
    }
    
}