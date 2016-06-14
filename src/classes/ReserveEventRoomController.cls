/*******************************************************************************
    Name             : ReserveEventRoomController
    Description      : This class is used as visual force controller for page 
                    ReserveEventRoom page  which is used to book room
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                        optimization
*******************************************************************************/
public with Sharing class ReserveEventRoomController
{
    public FilterListHandler filterListHandler{get;set;}
    public List<RoomWrapper> lstRoomWrapper{get;set;}
    public String sEventId{get;set;}
    public String sEventName{get;set;}
    public String sVenueId{get;set;}
    public String sVenueName{get;set;}
    List<Venue__c> lstVenueVar{get;set;}
    public Datetime dtStart;
    public Datetime dtEnd;
    public List<schema.fieldSetMember> lstFieldSetMember{get;set;}
    public boolean bTaggAll{get;set;}
    public String sRecordId{get;set;}
    public boolean bDisbaleButtons{get;set;}
    Map<String,RoomWrapper> mapbSelectedRecord{get;set;}
    public boolean bButtonDisabled{get;set;}
    //Basic constructor used to initiate class variable and read input
    //  URL parameters
    public ReserveEventRoomController()
    {
        String sStartDate;
        String sEndDate;
        boolean bCheck=false;
        try{
            //getting and setting start and end date from URL parameters
            sStartDate=ApexPages.currentPage().getParameters().get
            ('sDate')+' 00:01 AM';  
            //Getting Start Date
            sEndDate=ApexPages.currentPage().getParameters().get
            ('eDate')+' 00:01 PM';    
            //Getting end Date
            dtStart=Utility.formatDate(sStartDate).addHours(3);
            dtEnd=Utility.formatDate(sEndDate).addHours(4);
        }
        catch(Exception ex){
            ApexPages.Message myMsg2 = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.label.NoDateFound); 
            // No Date found for Venue Search.Please specify Start & End Date 
            //at Event Location.
            ApexPages.addMessage(myMsg2);
            bButtonDisabled=true;
        } 
        //Checking if venue is added to event Location or not
        if(!bCheck){ 
            try{
                filterListHandler=new FilterListHandler ();
                filterListHandler.valueTypeMap=new Map<String,STring>();
                lstVenueVar=new List<Venue__c>();
                lstRoomWrapper=new List<RoomWrapper>();
                //Getting Venue Name and Event Location Id from URL
                sEventId=ApexPages.currentPage().getParameters().get('eId');
                if(sEventId!=null)
                sEventId=String.escapeSingleQuotes(sEventId);
                sEventName=ApexPages.currentPage().getParameters().get('eName');
                if(sEventName!=null)
                sEventName=String.escapeSingleQuotes(sEventName);
                sVenueId=ApexPages.currentPage().getParameters().get('vId');
                if(sVenueId!=null)
                sEventName=String.escapeSingleQuotes(sVenueId);  
                sVenueName=ApexPages.currentPage().getParameters().get('vName');   
                if(sVenueName!=null)
                sEventName=String.escapeSingleQuotes(sVenueName);   
                mapbSelectedRecord=new Map<String,RoomWrapper>();
                if(sVenueId=='')
                {
                    //If no Venue is sent in URL
                    String sMessage=System.label.NoVenueAssociated;
                    sMessage+='<a href="/'+sEventId+'">'+sEventName+'</a>';
                    sMessage+= ' .'+System.label.AddVenueToBook;
                    //Please add a Venue to book room
                    ApexPages.Message myMsg2 = new ApexPages.Message
                    (ApexPages.Severity.ERROR,sMessage); 
                    // Validation Block
                    ApexPages.addMessage(myMsg2);
                    bButtonDisabled=true;
                }
                else
                {
                    bDisbaleButtons=false;
                    setFieldList();
                    setvalueTypeMap(); 
                    lstFieldSetMember=Utility.getFieldDetails
                    (new Venue__c(),'reserveRoomVf');
                    search();
                }
                bTaggAll=false;
            }
            catch(Exception ex){
                ApexPages.Message myMsg2 = new 
                ApexPages.Message
                (ApexPages.Severity.ERROR,System.label.NoDateFound);
                //No Date found for Venue Search.Please specify Start & End Date
                //at Event Location.
             
                bButtonDisabled=true;
            }
        }   
    }
    /**
    * Method name  : search
    * Description  : This method is used to Set search filter values type
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void setvalueTypeMap()
    {
        filterListHandler.valueTypeMap.put('Name','Quote Need');
        filterListHandler.valueTypeMap.put('Comment__c','Quote Need');
    }
    /**
    * Method name  : search
    * Description  : This method is add various filter option
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void setFieldList()
    {
        filterListHandler.fieldList.add(new selectOption('-None-','-None-'));
        filterListHandler.fieldList.add(new selectOption('Name','Room Name'));
        filterListHandler.fieldList.add(new selectOption
        ('Capacity__c','Room Capacity'));
        filterListHandler.fieldList.add(new selectOption
        ('Comment__c','Comment'));
    }
    /**
    * Method name  : search
    * Description  : This method is called to make initial search to find room 
    *                on page load
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void search()
    {
       
        List<Event_Room__c> lstReservedRoom = new List<Event_Room__c>();
        lstReservedRoom=[select Id,Name,Venue__c,
        Venue__r.Name,Campaign__r.StartDate,Campaign__r.EndDate from 
        Event_Room__c where Campaign__r.EndDate >:dtStart.date() 
        and Venue__r.Venue__c=:sVenueId ];  
        //Getting All Event Room Records for the same venue
        DateTime dtNow=Datetime.now();
        lstReservedRoom=checkAvailability(lstReservedRoom); 
        //Checking if venue is already booked by other Event Location
        String sQuery=String.escapeSingleQuotes(Utility.getQueryUsingFieldSet
        (lstFieldSetMember));   
        sQuery+='Id,Name from Venue__c where ';
        if(filterListHandler.compControllerRef!=null)
        {
            filterListHandler.compControllerRef.formQuery();
            sQuery+=filterListHandler.compControllerRef.query; 
            //Getting query from visual force component
        }
        sQuery+=' Id!=null AND Venue__c=\''+String.escapeSingleQuotes
        (sVenueId)+'\' AND RecordTypeId=\''+Utility.getRecordTypeMap
        ('Venue__c').get(System.label.Room)+'\' AND isDeleted=false';
      
        try{
            lstVenueVar=(List<Venue__c>)Database.query(sQuery);
        }
        catch(Exception ex){
            ApexPages.Message myMsg2 = new ApexPages.Message
            (ApexPages.Severity.ERROR,System.label.FilterError);  
            // Error Occurred while searching Rooms.Please check filter criteria
            ApexPages.addMessage(myMsg2);
        }
        //Forming final Room list to show on  page
        for(Integer iIndexVar=0;iIndexVar<lstReservedRoom.size();iIndexVar++)
        {
            for(Integer iVenueIndexVar=0;iVenueIndexVar<lstVenueVar.size
            ();iVenueIndexVar++)
            {   
                if(lstVenueVar[iVenueIndexVar].Id==
                        lstReservedRoom[iIndexVar].Venue__c)
                {
                    lstVenueVar.remove(iVenueIndexVar);         
                    //Removing already occupying venue
                                    
                }      
            } 
        }
        lstRoomWrapper.clear();
        Integer iUniqueId=0;
        //Forming RoomWrapper map
        for(Venue__c oVenueVar:lstVenueVar)
        {
            lstRoomWrapper.add(new RoomWrapper(oVenueVar));
            mapbSelectedRecord.put(String.valueOf(iUniqueId),
            new RoomWrapper(oVenueVar));
            
            iUniqueId++;
        }
    }
    /**
    * Method name  : Save
    * Description  : This method is called to create new Event Room record with
    *                user selecetd values
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void save()
    {
        tagbSelected();
        List<Event_Room__c> lstEventRoom=new List<Event_Room__c>();
        for(Integer iIndexVar=0;iIndexVar<lstRoomWrapper.size();iIndexVar++)
        {
            if((lstRoomWrapper[iIndexVar].bSelected==true) && 
                    (lstRoomWrapper[iIndexVar].bSaved==false))
            {
                Integer iVenueIndexVar=0;
                for(Event_Room__c oRoomVar: finalCheck()) 
                //Checking for venue again if during the process,room is occupied
                {
                    if(lstRoomWrapper[iIndexVar].oRoom.Id==oRoomVar.Venue__c)
                    {
                        ApexPages.Message myMsg2 = new 
                        ApexPages.Message(ApexPages.Severity.ERROR,
                        lstRoomWrapper[iIndexVar]
                        .oRoom.Name+' is no longer available for use.');
                        // Validation Block
                        ApexPages.addMessage(myMsg2);
                        lstRoomWrapper.remove(iIndexVar);
                        iVenueIndexVar++;
                    }
                }
                if(iVenueIndexVar==0)
                {
                    Event_Room__c oEventRoomVar=new Event_Room__c();
                    oEventRoomVar.Name=lstRoomWrapper[iIndexVar].oRoom.Name;
                    oEventRoomVar.Campaign__c=sEventId;
                    oEventRoomVar.Venue__c=lstRoomWrapper[iIndexVar].oRoom.Id;
                    oEventRoomVar.Capacity__c=lstRoomWrapper[iIndexVar].oRoom
                    .Capacity__c;
                    lstEventRoom.add(oEventRoomVar);
                    lstRoomWrapper[iIndexVar].bSaved=true;
                }
            }
        }
        try{
            //Inserting new Event oRoom  Record
            if(lstEventRoom.size()!=0)
            {
                insert lstEventRoom;
                ApexPages.Message myMsg2 = new
                ApexPages.Message(ApexPages.Severity.INFO,
                System.label.ReserveSucces+lstEventRoom.size());  
                // Validation Block
                ApexPages.addMessage(myMsg2);
            }
        }
        catch(Exception e)
        {
            ApexPages.Message myMsg2 = new 
            ApexPages.Message(ApexPages.Severity.ERROR,
            System.label.ErrorOccurred+e);  // Validation Block
            ApexPages.addMessage(myMsg2);
        }
    }
    /**
    * Method name  : Close
    * Description  : This method is called to redirect to event Location on 
    *                close of this page
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public pageReference close()
    {
        return new pageReference('/'+sEventId);
    }
    /**
    * Method name  : taggAll
    * Description  : This method is called to select all oRoom records displayed
    *                as search result
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void taggAll()
    {
        bTaggAll=true;
        for(Integer iIndexVar=0;iIndexVar<lstRoomWrapper.size();iIndexVar++)
        {
            lstRoomWrapper[iIndexVar].bSelected=true;
        }
    }
    /**
    * Method name  : untaggAll
    * Description  : This method is called to unbSelected all oRoom records 
    *                displayed as search result
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    public void untaggAll()
    {
        bTaggAll=false;
        for(Integer iIndexVar=0;iIndexVar<lstRoomWrapper.size();iIndexVar++)
        {
            lstRoomWrapper[iIndexVar].bSelected=false;
        }
    }
    /**
    * Method name  : checkAvailability
    * Description  : This method is called to check if venue related to event 
    *                oRoom is not being used by other event location
    *                
    * Return Type  : List<Event_Room__c>
    * Parameter    : List<Event_Room__c>
    **/  
    public List<Event_Room__c> checkAvailability(List<Event_Room__c> lstRoomVar)
    {
        Integer iIndexVar=0;
        
        List<Event_Room__c> lstBookedRoom=new List<Event_Room__c>();
        for(Event_Room__c oRoomVar:lstRoomVar)
        {
            //Checking various date condition               
            if((oRoomVar.Campaign__r.StartDate > dtStart) &&
                    (oRoomVar.Campaign__r.EndDate <dtEnd))
            {
                lstBookedRoom.add(oRoomVar);
              
            }
            else if((oRoomVar.Campaign__r.StartDate<dtStart )&&
                    (oRoomVar.Campaign__r.EndDate >dtStart))
            {
                lstBookedRoom.add(oRoomVar);
                
            }
            else if ((oRoomVar.Campaign__r.StartDate< dtStart )&&
                    (oRoomVar.Campaign__r.EndDate > dtEnd))
            {
                lstBookedRoom.add(oRoomVar);
                
            }
            else if((oRoomVar.Campaign__r.StartDate > dtStart) &&
                    (oRoomVar.Campaign__r.StartDate <dtEnd)&& 
                    (oRoomVar.Campaign__r.EndDate >dtEnd))
            {
                lstBookedRoom.add(oRoomVar);
                
            }
            else if((oRoomVar.Campaign__r.StartDate >= dtStart) &&
                    (oRoomVar.Campaign__r.StartDate <=dtEnd))
            {
                lstBookedRoom.add(oRoomVar);
                
            }
            iIndexVar++;
        }
       
        return lstBookedRoom;
    }
    /**
    * Method name  : finalCheck
    * Description  : This method is called to check if venue related to event 
    oRoom is not being used by other event location
    *                
    * Return Type  : List<Event_Room__c>
    * Parameter    : void
    **/
    public List<Event_Room__c> finalCheck()
    {
        List<Event_Room__c> lstReservedRoom = new List<Event_Room__c>();
        lstReservedRoom=[select Id,Name,Venue__c,
        Venue__r.Name,Campaign__r.StartDate,Campaign__r.EndDate from 
        Event_Room__c where   Campaign__r.EndDate >:dtStart.date() and 
        Venue__r.Venue__c=:sVenueId ];
        DateTime dtNow=Datetime.now();
        return  lstReservedRoom=checkAvailability(lstReservedRoom);
        return null;
    }
    /**
    * Method name  : tagbSelected
    * Description  : This method is used to handle pagination issue with jQuery 
    *                plugin
    * Return Type  : void
    * Parameter    : void
    **/
    public void tagbSelected()
    {
        List<String> lstbSelectedId=new List<String>();
       
        lstbSelectedId.clear();
        String sRecordIdVar=sRecordId;
        sRecordIdVar=sRecordIdVar.subStringAfter(',');
        Integer iCountVar=sRecordIdVar.countMatches(',');
        for(Integer iIndexVar=0;iIndexVar<iCountVar;iIndexVar++)
        {
            lstbSelectedId.add(sRecordIdVar.subStringBefore(',')
            .deleteWhitespace());
            sRecordIdVar=sRecordIdVar.substringAfter(',');
        }
        
        //Getting bbSelected records fro other Page.It is oprationg loke this 
        //to avoid bug of data table plug in.
        for(String sbSelectedIdVar:lstbSelectedId)
        {
            RoomWrapper roomWrpVar=mapbSelectedRecord.get(sbSelectedIdVar);
            if(roomWrpVar!=null)
            { 
                for(Integer iIndexVar=0;iIndexVar<lstRoomWrapper.size();iIndexVar++)
                {
                    if(lstRoomWrapper[iIndexVar].oRoom.Id==roomWrpVar.oRoom.Id)
                    {
                        lstRoomWrapper[iIndexVar].bSelected=true;
                    }
                }
            } 
        }
    }
}