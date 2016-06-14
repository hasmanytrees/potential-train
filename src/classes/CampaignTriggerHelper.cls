/*
    ****************************************************************************
    Name             : CampaignTriggerHelper
    Description      : Trigger Helper class used to make calculations and 
                       assignment based on Business Logic provided for the 
                       scenarios like task creation, influencer creation, 
                       RM Manager Assignment, Validations, Goals 
                       and Budget Calculation.                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                  26/01/2014            Created
    Sumeet                  02/02/2015            Modified for code re-factoring 
                                                  & optimization which includes 
                                                  proper commenting and 
                                                  alignment as well
    Shanu                   31/08/2015            Changes made for COR0001387                                                          
    Apurva                  08/10/2015            Changes made for COR0001562 
                                                Also, replaced System.Label.Campaign_Specialist
                                                with System.Label.Event_Specialist
    ***************************************************************************/

public without sharing class CampaignTriggerHelper
{
    
    //Defining all the private class variables to be used in 
    //upcoming methods of this class    
    private List<Task> lstTask = new List<Task>();
    private Map<Id, String> mapTaskRecurssion = new Map<Id, String>();
    private List<DeliverableBasedTaskList__c> lstInitialDeliveryTask = 
    new List<DeliverableBasedTaskList__c>();
    private Set<DeliverableBasedTaskList__c> setFinalDeliveryTask = 
    new Set<DeliverableBasedTaskList__c>();
    private Map<Id, Id> mapUsers = new Map<Id, Id>();
    private Map<String,Id> mapRelatedDeliverable = new Map<String,Id>();
    private Map<Id,String> mapRelatedDeliverableTasks = new Map<Id,String>();
    private List<Id> lstSpecialistId = new List<Id>(); 
    private List<Campaign> lstProgramRollUpCampaign = new List<Campaign>();
    private set<Id> setProgramId = new set<Id>();
    private Set<String> lstCompletedTasks = new Set<String>();
    private List<Campaign> lstCampaign = new List<Campaign>();
    private List<id> lstEventLocationVolunteerCoordinatorUserIds= 
    new List<id>();
    private List<Campaign> lstCampaignEventGoalsRollup = new List<Campaign>();
    private List<Campaign> lstCampaignEventLocationGoalsRollup = 
    new List<Campaign>();
    private set<Id> setActualsCalculationEventEvLocId = new set<Id>();
    private list<Goals__c> lstGoals = new List<Goals__c>();
    private list<campaign> lstCampaignDeletedRec= new list<campaign>();
    private static Integer iExecuteWindow = 0;    
    private Id eventRecordTypeId;
    private Id eventLocationRecordTypeId;   
    private Id campaignRecordTypeId;        
    private Id programRecordTypeId;
    private Map<Id, Date> mapDueDate= new Map<Id, Date>();
    private List<Campaign> lstEventBasedTasks = new List<Campaign>();
    private List<Campaign> lstEventLocationBasedTasks = new List<Campaign>();
    private List<Id> lstEventsId = new List<Id>();
    private List<Campaign> lstCampaignIds = new List<Campaign>();
    private Map<Id, String> mapEventReferenceToEventLocations = 
    new Map<Id, String>();
    //Apurva- New variables - start
    private List<DeliverableBasedTaskList__c> lstInitialDeliverableDeliveryTask = 
    new List<DeliverableBasedTaskList__c>();
    private Set<DeliverableBasedTaskList__c> setFinalDeliverableDeliveryTask = 
    new Set<DeliverableBasedTaskList__c>();
    private Map<Id, Id> mapUsers2 = new Map<Id, Id>();
    //Apurva- New variables - end
    
    /**
    * Method name  : Constructor
    * Description  : Calls method to identify and store record types id and 
    *                set execute Window value
    * Return Type  : void
    * Parameter    : void
    **/ 
    
    //Defining the constructor
    public CampaignTriggerHelper()
    {
        identifyRecordTypes();
        
        //This variable is used for identifying and 
        //restricting recursive execution of the class
        iExecuteWindow = 1;
        
    }
    
     /**
    * Method name  : setEventLocationOwnerFuture
    * Description  : This method is called from the change Event Location Owner 
    *                as same as Event Owner on creation
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign>
    **/  
    
    @future
    public static void setEventLocationOwnerFuture(Set<Id> setEventLocationIds)
    { 
        Utility.bIgnoreTaskOwnerChange = true;
        Set<Id> setEventIds=new Set<Id>();
        List<Campaign> lstEventLocationFinal=new List<Campaign>();
        List<Campaign> lstCampaign=new List<Campaign>();
        Id eventLocationRecordTypeId=Utility.getRecordtype('Event Location',
        'Campaign');
        Map<Id, Id> mapEveLocOwner = new Map<Id, Id>();
        
        //Iteration for finding the event Id list and 
        //corresponding event locations records
        for(Campaign oCampaignVar: [select OwnerId,Event__r.ownerId,Id,Event__c,
        recordTypeId from Campaign where Id IN:setEventLocationIds])
        {        
            if(oCampaignVar.recordTypeId==eventLocationRecordTypeId)
            {
                setEventIds.add(oCampaignVar.Event__c);
                lstEventLocationFinal.add(oCampaignVar);               
            }
        }
        
        //SOQL to retrieve the Event records for the 
        //corresponding Location Records
        lstCampaign=[select Id,OwnerId from Campaign where Id IN :setEventIds ];
        
        //Event Owner Assignment happens if the list is not empty 
        if(lstCampaign.size()>0)
        {
            Map<Id,Id> mapEventOwner=new Map<Id,Id>();
            
            //Iteration for retrieving the Owners from the Campaign records
            for(Campaign oCampiagnVar: lstCampaign)
            {
                mapEventOwner.put(oCampiagnVar.Id,oCampiagnVar.OwnerId);
            }  
            
            //Iterations for assigning the Owner to the Event Location 
            // based on the Event Owner Map
            for(Campaign oNewCampaignVar: lstEventLocationFinal)
            {
                oNewCampaignVar.OwnerId=mapEventOwner.get
                (oNewCampaignVar.Event__c);
                mapEveLocOwner.put(oNewCampaignVar.Id, oNewCampaignVar.OwnerId);
            }
            
        
        try
        {
            update  lstEventLocationFinal; 
            List<Task> lstTaskRecords = [select id, WhatId, Initial_Task_Owner__c from Task where WhatId in :mapEveLocOwner.keyset()];
            for(Task oTaskVar: lstTaskRecords)
            {
                oTaskVar.Initial_Task_Owner__c = mapEveLocOwner.get(oTaskVar.WhatId);
                oTaskVar.OwnerId = mapEveLocOwner.get(oTaskVar.WhatId);
            }
            
            update lstTaskRecords;
            Utility.bIgnoreTaskOwnerChange = false;
        }
        catch(Exception ex)
        {
            //Creating a new Error Log record whenever any exception 
            // is encountered while performing DML Operation
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'User',String.valueOf(setEventIds),
            'CampaignTriggerHelper','setEventLocationOwnerFuture','Application',
            UserInfo.getUserId(),String.valueOf(lstEventLocationFinal),null);
        }
        }
        
    }
    
    
    
    /**
    * Method name  : setEventLocationOwner
    * Description  : This method is called from the change Event Location Owner 
    *                as same as Event Owner on creation
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign>
    **/  
    /*
    public static void setEventLocationOwner(List<Campaign> lstEventLocation)
    { 
        
        Set<Id> setEventIds=new Set<Id>();
        List<Campaign> lstEventLocationFinal=new List<Campaign>();
        List<Campaign> lstCampaign=new List<Campaign>();
        Id eventLocationRecordTypeId=Utility.getRecordtype('Event Location',
        'Campaign');
        
        //Iteration for finding the event Id list and 
        //corresponding event locations records
        for(Campaign oCampaignVar: lstEventLocation)
        {        
            if(oCampaignVar.recordTypeId==eventLocationRecordTypeId)
            {
                setEventIds.add(oCampaignVar.Event__c);
                lstEventLocationFinal.add(oCampaignVar);               
            }
        }
        
       
         lstCampaign=[select Id,OwnerId from Campaign where Id IN :setEventIds ];
        
        //Event Owner Assignment happens if the list is not empty 
        if(lstCampaign.size()>0)
        {
            Map<Id,Id> mapEventOwner=new Map<Id,Id>();
            
            //Iteration for retrieving the Owners from the Campaign records
            for(Campaign oCampiagnVar: lstCampaign)
            {
                mapEventOwner.put(oCampiagnVar.Id,oCampiagnVar.OwnerId);
            }  
            
            //Iterations for assigning the Owner to the Event Location 
            // based on the Event Owner Map
            for(Campaign oNewCampaignVar: lstEventLocationFinal)
            {
                oNewCampaignVar.OwnerId=mapEventOwner.get
                (oNewCampaignVar.Event__c);
            }
           
          }        
    }
    */
    
    
    /**
    * Method name  : identifyRecordTypes
    * Description  : Use this method to assign various Campaign record types  
    *                to class variables
    * Return Type  : void
    * Parameter    : void
    **/  
    
    //This method is used for retrieving and assigning record type id 
    //for Campaign object
    private void identifyRecordTypes()
    {
        Schema.DescribeSObjectResult describeSchemaOfCampaign = 
        Schema.SObjectType.Campaign; 
        
        //Describe call for retrieving the record types 
        //and their corresponding ids in Campaign Object
        Map<Id,Schema.RecordTypeInfo> rtMapById = 
        describeSchemaOfCampaign.getRecordTypeInfosById();
        Map<String,Schema.RecordTypeInfo> rtMapByName = 
        describeSchemaOfCampaign.getRecordTypeInfosByName();
        
        //This is used for assigning the record type id based 
        //on the name of the record type
        eventRecordTypeId = rtMapByName.get(System.Label.Recordtype_Event).
        getRecordTypeId();
        eventLocationRecordTypeId = rtMapByName.get
        (System.Label.Recordtype_EventLocation).getRecordTypeId(); 
        campaignRecordTypeId = rtMapByName.get
        (System.Label.Recordtype_Campaign).getRecordTypeId();      
        programRecordTypeId = rtMapByName.get('Program').getRecordTypeId();
    }
    
    /**
    * Method name  : assignRelationshipManager
    * Description  : Use this method to assign RM Manager to the RM Manager
    *                 field of Campaign record 
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign>
    **/  
    
    //This method is used for assigning the RM Manager while 
    //creation or updating of record
    public void assignRelationshipManager(List<Campaign> lstOldCampaigns, 
    List<Campaign> lstNewCampaigns)
    {
        //This is a list of local variables which are used only in this method
        List<Campaign> lstFinalCampaigns = new List<Campaign>();
        List<Id> lstOwnerId = new List<Id>();
        
        //Checks if the particular scenario is an update scenario
        if(lstOldCampaigns <> null)
        {
            
            //This loop is used for checking and confirming if the Campaign 
            //Owner has been changed for the records and then let it move ahead
            //Otherwise bypasses the complete logic.
            for(Campaign oNewCampaignsVar: lstNewCampaigns)
            {
                for(Campaign oOldCampaignsVar: lstOldCampaigns)
                {
                    if(oNewCampaignsVar.OwnerId <> oOldCampaignsVar.OwnerId)
                    {
                        //The final Campaign List which includes all the 
                        //campaign records where the campaign owner 
                        //has been changed
                        lstFinalCampaigns.add(oNewCampaignsVar);
                        //The owner id list which includes the list 
                        //of all the campaign owner id
                        lstOwnerId.add(oNewCampaignsVar.OwnerId);                      
                    }
                }
            }
        }
        // This includes the insert scenario
        else
        {
            for(Campaign oNewCampaignsVar: lstNewCampaigns)
            {
                lstFinalCampaigns.add(oNewCampaignsVar);
                lstOwnerId.add(oNewCampaignsVar.OwnerId);
            }
        }
        
        //Checks if the final list of campaigns is not empty which signifies 
        //if the owner has been changed for the corresponding records.
        if(lstFinalCampaigns.size() > 0)
        {
            //SOQL is executed over the User record to retrieve 
            //all the user details based on the owner ids
            List<User> lstUsers = 
            [select id, ManagerId from User where id in :lstOwnerId];
            
            if( lstFinalCampaigns <> NULL){
                for(Campaign oCampaignRecordsVar: lstFinalCampaigns)
                {
                    if( lstUsers <> NULL){
                        
                        for(User oUserRecord: lstUsers)
                        {
                            //Checks if the user record id matches with the campaign 
                            // owner id and assigns the user Manager to the 
                            //RM Manager field
                            //Aug-2015 Shanu- Changes made for COR0001387
                            if(oCampaignRecordsVar.OwnerId == oUserRecord.id && 
                            oCampaignRecordsVar.RM_Manager__c == NULL)
                            {
                                oCampaignRecordsVar.RM_Manager__c = 
                                oUserRecord.ManagerId;
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /**
    * Method name  : identifyRecordTypes
    * Description  : Use this method to assign various Campaign record types to 
    *                class variables 
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign>
    **/  
    
    public void autopopulatePublishedVolunteerCoordinator(
    List<Campaign> lstNewCampaigns, List<Campaign> lstOldCampaigns)
    {
        List<Id> lstUserId = new List<Id>();
        for(Campaign oNewCampaignVar : lstNewCampaigns)
        {
            for(Campaign oOldCampaignVar: lstOldCampaigns)
            {
                if(oNewCampaignVar.Volunteer_Coordinator__c <> null && 
                oOldCampaignVar.Volunteer_Coordinator__c <> 
                oNewCampaignVar.Volunteer_Coordinator__c)
                {
                    lstUserId.add(oNewCampaignVar.Volunteer_Coordinator__c);
                    
                }
            }
        }
        if(lstUserId.size() > 0)
        {
            Map<Id, User> mapUserRecords = new Map<Id, User>
            ([select id, Name , Email,Phone from User where id in :lstUserId]);
            if(mapUserRecords <> null)
            {
                for(Campaign oCampaignVar : lstNewCampaigns)
                {
                    if(mapUserRecords.get
                    (oCampaignVar.Volunteer_Coordinator__c) <> null)
                    {
                        oCampaignVar.Published_Volunteer_Coordinator_Name__c = 
                        String.valueOf(mapUserRecords.get
                        (oCampaignVar.Volunteer_Coordinator__c).Name);
                        //Apurva- Added for COR# : COR0001353
                        if(mapUserRecords.get
                        (oCampaignVar.Volunteer_Coordinator__c).Email <> null){
                        oCampaignVar.Published_Volunteer_Coordinator_Email__c = 
                        String.valueOf(mapUserRecords.get
                        (oCampaignVar.Volunteer_Coordinator__c).Email);
                        oCampaignVar.Published_Volunteer_Coordinator_Lookup__c = 
                        mapUserRecords.get(oCampaignVar.Volunteer_Coordinator__c).Id;
                        oCampaignVar.Published_Volunteer_Coordinator_Phone__c =
                        mapUserRecords.get
                        (oCampaignVar.Volunteer_Coordinator__c).Phone;
                        }
                    }
                }
            }
        }
    }        
    
    
    /**
    * Method name  : CheckValidationOnEventLocation
    * Description  : Use this method to check for various Event Location related 
    *                validations 
    * Return Type  : void
    * Parameter    : List<Campaign>, boolean, Map<Id,Campaign>
    **/ 
    
    //This method is used for performing levels of validation on 
    //Event Location Record
    public void CheckValidationOnEventLocation(List<Campaign> lstNewCampaigns,
    boolean bIsBUpdate,Map<Id,Campaign> mapNewCampaign)
    {
        
        List<Campaign> lstCampaign=new List<Campaign>();
        for(Campaign oCampaignVar: lstNewCampaigns)
        {
            //Checks if the provided record is of Event Location Record Type and 
            if((oCampaignVar.recordTypeId==eventLocationRecordTypeId)&&
            (!oCampaignVar.Override_Venue_Conflict__c))
            {
                lstCampaign.add(oCampaignVar);
            }       
            
        }
        
        if(lstCampaign.size()>0)
        {
            //Calls the static method from EventLocationValidatorHelper class 
            //for performing validations
            EventLocationValidatorHelper.checkIfEventUsedBefore(lstCampaign,
            bIsBUpdate,mapNewCampaign);
        }          
    }
    


    /**
    * Method name  : calculateRollUpForRateCalculation
    * Description  : Use this method to calculate the total volunteer slots and 
    *                booked volunteer slots and get the ratio for the same and
    *                populate it across the User record and in the corresponding 
    *                Manager's record. 
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign> 
    **/     
    
    //This method is used for performing roll up for Managers Overall Coverage 
    //Rate calculation
    public void calculateRollUpForRateCalculation(List<Campaign> lstOldCampaign,
    List<Campaign> lstNewCampaigns)
    {    
        
        double dbTotalNumberOfVolunteerSlots = 0;
        double dbTotalBookedVolunteerSlots = 0;
        double dbManagersOverallRegionalCoverageRateCalculation = 0;
        double dbVolunteerCoordinatorCoverageRateCalculation = 0;
        List<Campaign> lstFinalCampaign = new List<Campaign>();
        List<Campaign> lstVolunteerCoordinators = new List<Campaign>();
        
        //This checks if this is an update scenario or delete scenario
        if(lstNewCampaigns <> null)
        {
            for(Campaign oNewCampaignVar: lstNewCampaigns)
            {
                for(Campaign oOldCampaignVar: lstOldCampaign)
                {
                    if((oNewCampaignVar.RecordTypeId == eventLocationRecordTypeId && oOldCampaignVar.Event_Volunteer_Manager__c <> oNewCampaignVar.Event_Volunteer_Manager__c) 
                            || (oNewCampaignVar.RecordTypeId == eventLocationRecordTypeId && oNewCampaignVar.Total_Number_Of_Volunteer_Slots__c <> oOldCampaignVar.Total_Number_Of_Volunteer_Slots__c) 
                            || (oNewCampaignVar.RecordTypeId == eventLocationRecordTypeId && oNewCampaignVar.Booked_Volunteer_Slots__c <> oOldCampaignVar.Booked_Volunteer_Slots__c))
                    {
                        if(oNewCampaignVar.Event_Volunteer_Manager__c <> null)
                        {
                            lstFinalCampaign.add(oNewCampaignVar);
                        }
                        if(oOldCampaignVar.Event_Volunteer_Manager__c <> null)
                        {
                            lstFinalCampaign.add(oOldCampaignVar);
                        }
                    }
                    
                    if((oNewCampaignVar.RecordTypeId == eventLocationRecordTypeId && 
                    oOldCampaignVar.Volunteer_Coordinator__c <> oNewCampaignVar.Volunteer_Coordinator__c
                    ) 
                            || (oNewCampaignVar.RecordTypeId == eventLocationRecordTypeId && oNewCampaignVar.Total_Number_Of_Volunteer_Slots__c <> oOldCampaignVar.Total_Number_Of_Volunteer_Slots__c) 
                            || (oNewCampaignVar.RecordTypeId == eventLocationRecordTypeId && oNewCampaignVar.Booked_Volunteer_Slots__c <> oOldCampaignVar.Booked_Volunteer_Slots__c))
                    {
                        if(oNewCampaignVar.Volunteer_Coordinator__c <> null)
                        {
                            lstVolunteerCoordinators.add(oNewCampaignVar);
                        }
                        if(oOldCampaignVar.Volunteer_Coordinator__c <> null)
                        {
                            lstVolunteerCoordinators.add(oOldCampaignVar);
                        }
                        
                    }
                }
                
            }
        }
        else
        {
            for(Campaign oCampaignVar: lstOldCampaign)
            {
                if(oCampaignVar.RecordTypeId == eventLocationRecordTypeId && 
                oCampaignVar.Event_Volunteer_Manager__c <> null)
                {
                    lstFinalCampaign.add(oCampaignVar);
                }
                
                if(oCampaignVar.RecordTypeId == eventLocationRecordTypeId &&
                oCampaignVar.Volunteer_Coordinator__c <> null)
                {
                    lstVolunteerCoordinators.add(oCampaignVar);
                    
                }
            }
        }
          
        if(lstVolunteerCoordinators.size() > 0)
        {   
            List<Id> lstCoordinatorIds = new List<Id>();
            List<User> lstUpdateUsers = new List<User>();
            for(Campaign oNewCampaignVar: lstVolunteerCoordinators)
            {
                lstCoordinatorIds.add(oNewCampaignVar.Volunteer_Coordinator__c);
            }
            
            //Aggregate SOQL is executed to find out the total values based on 
            //the specific Users from Campaigns
            List<AggregateResult> lstAggregates=[select Volunteer_Coordinator__c, 
            Status, SUM(Total_Number_Of_Volunteer_Slots__c) totalSlots, 
            SUM(Booked_Volunteer_Slots__c) bookedSlots from Campaign where
            Volunteer_Coordinator__c in :lstCoordinatorIds and
            Status = :System.Label.CampaignStatus_Completed Group By
            Volunteer_Coordinator__c, Status];
            
            for(User oNewUserVar : [select id, 
            Volunteer_Coordinator_Coverage_Rate__c from User
            where id in :lstCoordinatorIds])
            {
                oNewUserVar.Volunteer_Coordinator_Coverage_Rate__c = 0.0;
                for(AggregateResult aggregateVar: lstAggregates)
                {
                    //Checks for the corresponding User Id and 
                    //total slots value to prevent MATH exception
                    if(aggregateVar.get('Volunteer_Coordinator__c') == 
                    oNewUserVar.id && aggregateVar.get('totalSlots') <> 0)
                    {
                        dbTotalNumberOfVolunteerSlots = 
                        double.valueOf(aggregateVar.get('totalSlots'));
                        dbTotalBookedVolunteerSlots = 
                        double.valueOf(aggregateVar.get('bookedSlots'));                       
                        
                        
                        if(dbTotalNumberOfVolunteerSlots > 0){
                            dbManagersOverallRegionalCoverageRateCalculation =
                            (dbTotalBookedVolunteerSlots)/
                            (dbTotalNumberOfVolunteerSlots) ;
                        }
                        
                        
                        oNewUserVar.Volunteer_Coordinator_Coverage_Rate__c = 
                        dbManagersOverallRegionalCoverageRateCalculation;
                        
                    }
                    
                }
                lstUpdateUsers.add(oNewUserVar);
            }
            if(lstUpdateUsers.size() > 0)
            {
                try
                {
                    update lstUpdateUsers;
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),
                    'User',String.valueOf(lstCoordinatorIds),
                    'CampaignTriggerHelper',
                    'calculateRollUpForRateCalculation',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstUpdateUsers),
                    String.valueOf(lstOldCampaign));
                }
            }
            
        }
        
        if(lstFinalCampaign.size() > 0)
        {
            List<Id> lstManagerIds = new List<Id>();
            List<User> lstUpdateAnotherUser = new List<User>();
            for(Campaign oNewCampaignVar: lstFinalCampaign)
            {
                lstManagerIds.add(oNewCampaignVar.Event_Volunteer_Manager__c);
            }
            
            //Aggregate SOQL for the Event Volunteer Manager data population
            List<AggregateResult> lstAggregates = 
            [select Event_Volunteer_Manager__c, Status, 
            SUM(Total_Number_Of_Volunteer_Slots__c) totalSlots, 
            SUM(Booked_Volunteer_Slots__c) bookedSlots from Campaign where 
            Event_Volunteer_Manager__c in :lstManagerIds and 
            Status = :System.Label.CampaignStatus_Completed Group By 
            Event_Volunteer_Manager__c, Status];
            
            for(User oNewUserVar : [select id, 
            Managers_Overall_Regional_Coverage_Rate__c from User where 
            id in :lstManagerIds])
            {
                oNewUserVar.Managers_Overall_Regional_Coverage_Rate__c = 0.0;
                for(AggregateResult aggregateVar: lstAggregates)
                {
                    if(aggregateVar.get('Event_Volunteer_Manager__c') == 
                    oNewUserVar.id && aggregateVar.get('totalSlots') <> 0)
                    {
                        dbTotalNumberOfVolunteerSlots = double.valueOf
                        (aggregateVar.get('totalSlots'));
                        dbTotalBookedVolunteerSlots = double.valueOf
                        (aggregateVar.get('bookedSlots'));                       
                        
                        
                        if(dbTotalNumberOfVolunteerSlots > 0){
                            dbManagersOverallRegionalCoverageRateCalculation = 
                            (dbTotalBookedVolunteerSlots)/
                            (dbTotalNumberOfVolunteerSlots) ;
                        }
                        
                        oNewUserVar.Managers_Overall_Regional_Coverage_Rate__c = 
                        dbManagersOverallRegionalCoverageRateCalculation;
                        
                    }
                    
                }
                lstUpdateAnotherUser.add(oNewUserVar);
            }
            if(lstUpdateAnotherUser.size() > 0)
            {
                try
                {
                    update lstUpdateAnotherUser;
                }
                catch(Exception ex)
                {
                    //Creating a new Error Log record whenever any exception is 
                    //encountered while performing DML Operation
                    
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),
                    'User',String.valueOf(lstManagerIds),
                    'CampaignTriggerHelper',
                    'calculateRollUpForRateCalculation','Application',
                    UserInfo.getUserId(), 
                    String.valueOf(lstUpdateAnotherUser),
                    String.valueOf(lstOldCampaign));
                }
            }               
        }       
    }
       
    
    /**
    * Method name  : CampaignCompletionCheck
    * Description  : Use this method for checking the Campaign Completion 
    *                if related tasks are still pending
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>
    **/
    
    //This method is used for making validation check for Campaign Record 
    public static void CampaignCompletionCheck(List<Campaign> lstCampaignRecord)
    {
        List<Id> lstCampaignRecordIds = new List<Id>();
        for(Campaign oCampaignRef: lstCampaignRecord)
        {
            lstCampaignRecordIds.add(oCampaignRef.id);
        }
        
        //SOQL to retrieve task list for the corresponding Campaign record
        List<Task> lstTasks = [select id, Status, WhatId from Task where WhatId 
        in :lstCampaignRecordIds];
        for(Campaign oCampaignRecordsVar: lstCampaignRecord)
        {
            for(Task oTaskReferenceVar: lstTasks)
            {
                if(oTaskReferenceVar.Status <> 
                System.Label.CampaignStatus_Completed &&
                oCampaignRecordsVar.Status == 
                System.Label.CampaignStatus_Completed)
                {
                    oCampaignRecordsVar.addError
                    (System.Label.CampaignComplete_ErrorMessage);
                }
            }
        }
    }
    
    /**
    * Method name  : taskAssignment
    * Description  : Use this method for creating automated tasks 
    *                for the Deliverable Object
    * Return Type  : void
    * Parameter    : List<Deliverable__c> newDeliverableRecords, String dmlType
    **/
    
    //This method is called to create automated tasks on the Deliverable Record
    public void taskAssignment(List<Deliverable__c> lstNewDeliverableRecords,
    String sDMLType)
    {
        List<Id> lstEventIds = new List<Id>();
        List<Id> lstCampaignIds = new List<Id>();
        List<Id> lstAgencyIds = new List<Id>();
        Map<Id, Id> mapAgencyUsers = new Map<Id, Id>();
        Map<Id, Deliverable__c> mapDeliverables = new Map<Id,Deliverable__c>(lstNewDeliverableRecords);
        lstInitialDeliveryTask = new List<DeliverableBasedTaskList__c>();
        lstInitialDeliveryTask = [select Assigned_To__c, Campaign_Type__c, 
        Dependency__c, Due_Date_Calculated_From__c, Due_Date_Object__c, 
        Due_Date_Scenario__c, Due_Date_Value__c,Object_Name__c, Object_Type__c,
        Order__c, Priority__c,Record_Type__c, Status__c, Status_Condition__c,
        Status_Object__c, Subject__c,Type__c,Type_Values__c from
        DeliverableBasedTaskList__c 
        where Record_Type__c = 'Deliverable__c'];
        
        for(Deliverable__c deliverableRecordVar: lstNewDeliverableRecords)
        {
            lstEventIds.add(deliverableRecordVar.Event__c);  
            lstCampaignIds.add(deliverableRecordVar.Campaign__c);
            lstAgencyIds.add(deliverableRecordVar.Agency__c);
        }
        
        for(Task oTaskVar: [select Status, Unique_Reference__c, Due_Date__c, OwnerId, Custom_Settings_Linkage__c from Task where WhatId in :lstEventIds or WhatId in :lstCampaignIds or WhatId in :mapDeliverables.keyset()])
        {
            lstCompletedTasks.add(oTaskVar.Unique_Reference__c);            
        }
        
        if(lstAgencyIds.size() > 0)
        {
            List<User> lstAgencyUsers = [select id, Contact.AccountId 
            from User where Contact.AccountId in :lstAgencyIds Limit 1];
            for(User oUserVar: lstAgencyUsers)
            {
                mapAgencyUsers.put(oUserVar.Contact.AccountId, oUserVar.id);            
            } 
        }
        
        //The condition and underlying logic is being executed 
        //for Insert Scenario
        if(lstEventIds.size() > 0 && (sDMLType == System.Label.DMLType_Insert ||
        sDMLType == System.Label.DMLType_Update))
        {
            List<Campaign> deliverableRelatedCampaigns = new List<Campaign>();
            deliverableRelatedCampaigns = [select id, Order_Child_Packets__c, 
            Event__c, recordtypeid, Type, EVE_Specialist__c, Event__r.Status ,
            Volunteer_Coordinator__c, startdate, ownerid, enddate, status, 
            Project_Manager__c from Campaign where id in :lstEventIds];
            if(deliverableRelatedCampaigns.size() > 0)
            {

                createCampaignUserList(deliverableRelatedCampaigns, sDMLType);
                
                //Apurva - Code added to handle task for Event Deliverables
                
                if(lstNewDeliverableRecords.size()>0){
                    Map<Id, Id> event_SpecialistMap = new Map<Id,Id>();
                    Map<Id, Id> event_projectManagerMap = new Map<Id,Id>();
                    Map<Id, Id> event_campaignOwnerMap = new Map<Id,Id>();
                    Map<Id, Id> deliverable_SpecialistMap = new Map<Id,Id>();
                    Map<Id, Id> deliverable_projectManagerMap = new Map<Id,Id>();
                    Map<Id, Id> deliverable_delieverableOwnerMap = new Map<Id,Id>();
                    Map<Id, Id> deliverable_assignedToMap = new Map<Id,Id>();
                    Map<Id, String> mapDeliverableCampaignStatus = new Map<Id,String>();
                    Map<Id, String> mapDeliverableCampaignType = new Map<Id, String>();
                    List<String> lstDeliverableString = new List<String>();
                    for(Deliverable__c oDeliverableVar: lstNewDeliverableRecords)
                    {
                        lstDeliverableString.add(oDeliverableVar.Type__c);
                        for(Campaign oNewCampaignVar: deliverableRelatedCampaigns)
                        {
                            
                            if(oDeliverableVar.Event__c == oNewCampaignVar.Id){
                                if(oNewCampaignVar.Status <> null)
                                {
                                    mapDeliverableCampaignStatus.put(oDeliverableVar.id, 
                                    oNewCampaignVar.Status);
                                }
                                
                                if(oNewCampaignVar.Type <> null)
                                {
                                    mapDeliverableCampaignType.put(oDeliverableVar.id, 
                                    oNewCampaignVar.Type);
                                }
                                if(oDeliverableVar.Event_Specialist__c <> null)
                                {
                                    deliverable_SpecialistMap.put(oDeliverableVar.id,
                                    oDeliverableVar.Event_Specialist__c);  
                                }
                                if(oNewCampaignVar.Eve_Specialist__c <> null)
                                {
                                    event_SpecialistMap.put(oDeliverableVar.id,
                                    oNewCampaignVar.Eve_Specialist__c);  
                                }
                                if(oDeliverableVar.Project_Manager__c <> null)
                                {
                                    deliverable_projectManagerMap.put(oDeliverableVar.id, 
                                    oDeliverableVar.Project_Manager__c);
                                }
                                else
                                {
                                    deliverable_projectManagerMap.put(oDeliverableVar.id, 
                                    oDeliverableVar.OwnerId);
                                }
                                if(oNewCampaignVar.Project_Manager__c <> null)
                                {
                                    event_projectManagerMap.put(oDeliverableVar.id, 
                                    oNewCampaignVar.Project_Manager__c);
                                }
                                else
                                {
                                    event_projectManagerMap.put(oDeliverableVar.id, 
                                    oNewCampaignVar.OwnerId);
                                }
                                event_campaignOwnerMap.put(oDeliverableVar.id, 
                                oNewCampaignVar.OwnerId);
                                deliverable_delieverableOwnerMap.put(oDeliverableVar.id, 
                                oDeliverableVar.OwnerId);
                            }   
                        }
                    }
                    lstInitialDeliverableDeliveryTask = new List<DeliverableBasedTaskList__c>();
                    lstInitialDeliverableDeliveryTask = [select Assigned_To__c, Campaign_Type__c, 
                    Dependency__c, Due_Date_Calculated_From__c, Due_Date_Object__c, 
                    Due_Date_Scenario__c, Due_Date_Value__c,Object_Name__c, Object_Type__c,
                    Order__c, Priority__c,Record_Type__c, Status__c, Status_Condition__c,
                    Status_Object__c, Subject__c,Type__c,Type_Values__c from
                    DeliverableBasedTaskList__c 
                    where Record_Type__c = 'Deliverable__c' and Type_values__C in :lstDeliverableString];
                //  System.debug('Agarwal lstInitialDeliverableDeliveryTask' +lstInitialDeliverableDeliveryTask.size());
                    for(Deliverable__c oDeliverableVar: lstNewDeliverableRecords)
                    {
                        for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
                            lstInitialDeliverableDeliveryTask){
                                if((lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                                    && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)))) && 
                                    oDeliverableVar.Type__c <> null && 
                                    oDeliverableTaskLstVar.Type_Values__c.toLowerCase() ==
                                    String.valueOf(oDeliverableVar.Type__c).toLowerCase())
                                    {
                                        setFinalDeliverableDeliveryTask.add(oDeliverableTaskLstVar);                    
                                        mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                                        oDeliverableVar.id);
                                        mapRelatedDeliverableTasks.put(oDeliverableVar.id,
                                        oDeliverableVar.Type__c);
                                        mapTaskRecurssion.put(oDeliverableTaskLstVar.id,
                                        oDeliverableVar.id);
                                        if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Deliverable_Assigned_To &&
                                        oDeliverableVar.Assigned_To__c == null
                                        ||(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Campaign_Owner && 
                                        event_campaignOwnerMap.get(oDeliverableVar.id) ==null )
                                        || (oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Project_Manager && 
                                        deliverable_projectManagerMap.get(oDeliverableVar.id)== null) 
                                        || (oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Event_Specialist&& 
                                        deliverable_SpecialistMap.get(oDeliverableVar.id) == null))
                                        {
                                            mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            deliverable_delieverableOwnerMap.get(oDeliverableVar.id));
                                        }
                                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Campaign_Owner){
                                            mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            event_campaignOwnerMap.get(oDeliverableVar.id));
                                        }
                                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Project_Manager)
                                        {
                                            mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            deliverable_projectManagerMap.get(oDeliverableVar.id));
                                        }
                                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Campaign_Event_Specialist)
                                        {
                                            if(event_SpecialistMap.get(oDeliverableVar.id) == null){
                                                mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            event_campaignOwnerMap.get(oDeliverableVar.id));
                                            }
                                            else{
                                            mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            event_SpecialistMap.get(oDeliverableVar.id));
                                            }
                                        
                                        }
                                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Event_Specialist)
                                        {
                                            mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            deliverable_SpecialistMap.get(oDeliverableVar.id));
                                        }                       
                                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Agency && 
                                        oDeliverableVar.Agency__c <> null && 
                                        mapAgencyUsers <> null && 
                                        mapAgencyUsers.get(oDeliverableVar.Agency__c) <> null)
                                        {
                                            mapUsers2.put(oDeliverableTaskLstVar.id, 
                                            mapAgencyUsers.get(oDeliverableVar.Agency__c));
                                        }   
                                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                                        System.Label.Deliverable_Assigned_To)
                                        {
                                            mapUsers2.put(oDeliverableTaskLstVar.id,
                                            oDeliverableVar.Assigned_To__c);
                                        }
                                        else{
                                            mapUsers2.put(oDeliverableTaskLstVar.id,
                                            oDeliverableVar.OwnerId);
                                        }
                                    }
                            }
                    }
                //  System.debug('Apu setFinalDeliveryTask '+ setFinalDeliveryTask);
                    createDeliverableTaskRecords();
                }
                //Apurva - Changes end
            }
        }
        
        //The condition and underlying logic is being executed 
        //for Update Scenario
        if(lstCampaignIds.size() > 0)
        {
            List<Campaign> lstCampaign = [select id, Type, Status, 
            EVE_Specialist__c, OwnerId, Project_Manager__c from Campaign where 
            recordtypeid = :campaignRecordTypeId and id in :lstCampaignIds];
            Map<Id, Id> campaignSpecialistMap = new Map<Id,Id>();
            Map<Id, Id> projectManagerMap = new Map<Id,Id>();
            Map<Id, Id> campaignOwnerMap = new Map<Id,Id>();
            Map<Id, String> mapDeliverableCampaignStatus = new Map<Id,String>();
            Map<Id, String> mapDeliverableCampaignType = new Map<Id, String>();
            
            //This iteration is used for retrieving the users like campaign 
            //owners,Project Manager, EVent specialist etc and putting in a map.
            for(Deliverable__c oDeliverableVar: lstNewDeliverableRecords)
            {
                for(Campaign oNewCampaignVar: lstCampaign)
                {
                    if(oNewCampaignVar.Status <> null)
                    {
                        mapDeliverableCampaignStatus.put(oDeliverableVar.id, 
                        oNewCampaignVar.Status);
                    }
                    
                    if(oNewCampaignVar.Type <> null)
                    {
                        mapDeliverableCampaignType.put(oDeliverableVar.id, 
                        oNewCampaignVar.Type);
                    }
                    if(oNewCampaignVar.EVE_Specialist__c <> null)
                    {
                        campaignSpecialistMap.put(oDeliverableVar.id,
                        oNewCampaignVar.EVE_Specialist__c);  
                    }
                    if(oNewCampaignVar.Project_Manager__c <> null)
                    {
                        projectManagerMap.put(oDeliverableVar.id, 
                        oNewCampaignVar.Project_Manager__c);
                    }
                    else
                    {
                        projectManagerMap.put(oDeliverableVar.id, 
                        oNewCampaignVar.OwnerId);
                    }
                    campaignOwnerMap.put(oDeliverableVar.id, 
                    oNewCampaignVar.OwnerId);
                }
            }
            
            //This iteration checks for the conditions for the Task creation 
            //from the Custom Settings and create a final task creation list
            for(Deliverable__c oDeliverableVar: lstNewDeliverableRecords)
            {
                for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
                lstInitialDeliveryTask)
                {
                    if(oDeliverableTaskLstVar.Campaign_Type__c <> null && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                    && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)))) && 
                    mapDeliverableCampaignType <> null && 
                    mapDeliverableCampaignType.get(oDeliverableVar.id) <> null&&
                    oDeliverableTaskLstVar.Campaign_Type__c ==  
                    mapDeliverableCampaignType.get(oDeliverableVar.id) &&
                    oDeliverableVar.Type__c <> null && 
                    oDeliverableTaskLstVar.Type_Values__c <> null && 
                    oDeliverableTaskLstVar.Status_Condition__c <> null &&
                    oDeliverableTaskLstVar.Status_Object__c <> null && 
                    oDeliverableVar.Status__c.contains(oDeliverableTaskLstVar.Status_Condition__c) && 
                    oDeliverableTaskLstVar.Status_Object__c == 
                    System.Label.Deliverable_Object &&
                    oDeliverableTaskLstVar.Object_Name__c == 
                    System.Label.Deliverable_Object && 
                    oDeliverableTaskLstVar.Type_Values__c.toLowerCase() ==
                    String.valueOf(oDeliverableVar.Type__c).toLowerCase())
                    {
                        setFinalDeliveryTask.add(oDeliverableTaskLstVar);                    
                        mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.id);
                        mapRelatedDeliverableTasks.put(oDeliverableVar.id,
                        oDeliverableVar.Type__c);
                        mapTaskRecurssion.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.id);
                        if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Campaign_Owner 
                                || (oDeliverableTaskLstVar.Assigned_To__c == 
                                System.Label.Project_Manager && 
                                projectManagerMap.get(oDeliverableVar.id)== null) 
                                || (oDeliverableTaskLstVar.Assigned_To__c == 
                                System.Label.Event_Specialist && 
                                campaignSpecialistMap.get(oDeliverableVar.id) == null))
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            campaignOwnerMap.get(oDeliverableVar.id));
                        }
                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Project_Manager)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            projectManagerMap.get(oDeliverableVar.id));
                        }
                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Event_Specialist)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            campaignSpecialistMap.get(oDeliverableVar.id));
                        }                       
                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Agency && 
                        oDeliverableVar.Agency__c <> null && 
                        mapAgencyUsers <> null && 
                        mapAgencyUsers.get(oDeliverableVar.Agency__c) <> null)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            mapAgencyUsers.get(oDeliverableVar.Agency__c));
                        } 
                    }
                    else if(oDeliverableTaskLstVar.Campaign_Type__c <> null && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                    && !lstCompletedTasks.contains(String.valueOf(oDeliverableVar.id)) 
                    && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)))) &&
                    mapDeliverableCampaignType <> null && 
                    mapDeliverableCampaignType.get(oDeliverableVar.id) <> null&&
                    oDeliverableTaskLstVar.Campaign_Type__c ==  
                    mapDeliverableCampaignType.get(oDeliverableVar.id) &&
                    oDeliverableVar.Type__c <> null && 
                    oDeliverableTaskLstVar.Type_Values__c <> null && 
                    oDeliverableTaskLstVar.Status_Condition__c <> null && 
                    oDeliverableTaskLstVar.Status_Object__c <> null && 
                    mapDeliverableCampaignStatus <> null && 
                    mapDeliverableCampaignStatus.get(oDeliverableVar.id)<> null&&
                    oDeliverableTaskLstVar.Status_Condition__c == 
                    mapDeliverableCampaignStatus.get(oDeliverableVar.id) &&
                    oDeliverableTaskLstVar.Status_Object__c == 'Campaign' &&
                    oDeliverableTaskLstVar.Object_Name__c == 
                    System.Label.Deliverable_Object &&
                    oDeliverableTaskLstVar.Type_Values__c.toLowerCase() == 
                    String.valueOf(oDeliverableVar.Type__c).toLowerCase())
                    {
                        setFinalDeliveryTask.add(oDeliverableTaskLstVar);                    
                        mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.id);
                        mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.Type__c);
                        mapTaskRecurssion.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.id);
                        if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Campaign_Owner ||
                        (oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Project_Manager && projectManagerMap.get
                        (oDeliverableVar.id)== null) || 
                        (oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Event_Specialist &&
                        campaignSpecialistMap.get(oDeliverableVar.id) == null))
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            campaignOwnerMap.get(oDeliverableVar.id));
                        }
                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Project_Manager)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            projectManagerMap.get(oDeliverableVar.id));
                        }
                        else if(oDeliverableTaskLstVar.Assigned_To__c ==
                        System.Label.Event_Specialist)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            campaignSpecialistMap.get(oDeliverableVar.id));
                        }                       
                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Agency &&
                        oDeliverableVar.Agency__c <> null && 
                        mapAgencyUsers <> null && 
                        mapAgencyUsers.get(oDeliverableVar.Agency__c) <> null)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            mapAgencyUsers.get(oDeliverableVar.Agency__c));
                        } 
                    }
                    else if(oDeliverableTaskLstVar.Campaign_Type__c == null 
                    && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                    && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                    && !lstCompletedTasks.contains(String.valueOf(oDeliverableVar.id)))) &&
                    oDeliverableVar.Type__c <> null && 
                    oDeliverableTaskLstVar.Type_Values__c <> null &&
                    oDeliverableVar.Status__c == 
                    System.Label.CampaignStatus_Confirmed &&
                    oDeliverableTaskLstVar.Object_Name__c ==
                    System.Label.Deliverable_Object &&
                    oDeliverableTaskLstVar.Type_Values__c.toLowerCase() ==
                    String.valueOf(oDeliverableVar.Type__c).toLowerCase())
                    {
                        setFinalDeliveryTask.add(oDeliverableTaskLstVar);                    
                        mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.id);
                        mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                        oDeliverableVar.Type__c);
                        mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                        oDeliverableVar.id);
                        if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Campaign_Owner ||
                        (oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Project_Manager && projectManagerMap.get
                        (oDeliverableVar.id)== null) ||
                        (oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Event_Specialist && 
                        campaignSpecialistMap.get(oDeliverableVar.id) == null))
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            campaignOwnerMap.get(oDeliverableVar.id));
                        }
                        else if(oDeliverableTaskLstVar.Assigned_To__c == 
                        System.Label.Project_Manager)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            projectManagerMap.get(oDeliverableVar.id));
                        }
                        else if(oDeliverableTaskLstVar.Assigned_To__c ==
                        System.Label.Event_Specialist)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            campaignSpecialistMap.get(oDeliverableVar.id));
                        }                       
                        else if(oDeliverableTaskLstVar.Assigned_To__c ==
                        System.Label.Agency && 
                        oDeliverableVar.Agency__c <> null && 
                        mapAgencyUsers <> null && 
                        mapAgencyUsers.get(oDeliverableVar.Agency__c) <> null)
                        {
                            mapUsers.put(oDeliverableTaskLstVar.id, 
                            mapAgencyUsers.get(oDeliverableVar.Agency__c));
                        } 
                    }
                }
            }
           
            //This method is called for creating the tasks
            createTaskRecords();
        }
        
    }
    
    /**
    * Method name  : createCampaignUserList
    * Description  : Use this method for creating automated tasks for the 
    *                Campaign Object
    * Return Type  : void
    * Parameter    : List<Campaign>, String
    **/
    //This method is called to create automated tasks on Campaign Object 
    //based on their record types
    public void createCampaignUserList(List<Campaign> lstNewCampaignRecords, 
    String sDMLType)
    {
        
        //Iteration performed to check for the task creation on the  
        //corresponding record type and getting the final list to move ahead
        for(Campaign newCampaignVar: lstNewCampaignRecords)
        {
            
                if(newCampaignVar.RecordTypeId == eventRecordTypeId )
                {
                    lstEventBasedTasks.add(newCampaignVar);
                    lstEventsId.add(newCampaignVar.id);
                }
                else if(newCampaignVar.RecordTypeId ==eventLocationRecordTypeId )
                {
                    lstEventLocationBasedTasks.add(newCampaignVar);
                    lstEventsId.add(newCampaignVar.Event__c);
                    mapEventReferenceToEventLocations.put(newCampaignVar.id, 
                    newCampaignVar.Event__r.Status);
                }
                else if(newCampaignVar.RecordTypeId == campaignRecordTypeId && 
                newCampaignVar.Type <> 'OSR')
                {
                    lstCampaignIds.add(newCampaignVar);
                }
           
        }
        if(lstCampaignIds.size() > 0)
        {
            checkCampaignTaskCriteria(lstCampaignIds);
        }
        if(lstEventBasedTasks.size() > 0)
        {
            checkForEventTaskCriteria(lstEventBasedTasks, lstEventsId);
        }
        if(lstEventLocationBasedTasks.size() > 0)
        {
            checkEventLocationTaskCriteria(lstEventLocationBasedTasks, 
            lstEventsId, mapEventReferenceToEventLocations, sDMLType);
        }
        
    }
    
    /**
    * Method name  : createLeadBasedTasks
    * Description  : Use this method for creating automated tasks for the Lead 
    *                Object
    * Return Type  : void
    * Parameter    : List<Lead>, String
    **/
    //This method is called to create automated tasks on the Lead Record
    public void createLeadBasedTasks(List<Lead> lstLeadRecords, String sDMLType)
    {
        List<Id> lstLeadOwners = new List<Id>();
        Map<Id, Id> mapLeadUsersFromQueue = new Map<Id, Id>();
        
        lstInitialDeliveryTask = new List<DeliverableBasedTaskList__c>();
        lstInitialDeliveryTask = [select Assigned_To__c, Campaign_Type__c, 
        Dependency__c,Due_Date_Calculated_From__c, Due_Date_Object__c, 
        Due_Date_Scenario__c,Due_Date_Value__c, Object_Name__c, Object_Type__c, 
        Order__c, Priority__c,Record_Type__c, Status__c, Status_Condition__c, 
        Status_Object__c, Subject__c,Type__c, Type_Values__c from 
        DeliverableBasedTaskList__c 
        where Record_Type__c = 'Lead'];
        
        
        //Retrieving the Queue owners for assigning the 
        //corresponding task to a proper User
        for(Lead oNewLeadRecordVar: lstLeadRecords)
        {
            if(String.valueOf(oNewLeadRecordVar.OwnerId).substring(0,3) =='00G')
            {
                lstLeadOwners.add(oNewLeadRecordVar.OwnerId);
            }
        }
        
        //This section is used for retrieving the first owner from the queue and
        //assign the corresponding tasks to the same
        if(lstLeadOwners.size() > 0)
        {
            List<GroupMember> listUserIds= [Select UserOrGroupId,
            GroupId From GroupMember where GroupId in :lstLeadOwners];
            for(Lead oLeadRecordVar: lstLeadRecords)
            {
                for(GroupMember groupMemberVar: listUserIds)
                {
                    //This logic is used for bypassing the logic if the 
                    //first user from the queue has been retrieved
                    if(oLeadRecordVar.OwnerId == groupMemberVar.GroupId &&
                    mapLeadUsersFromQueue.get(oLeadRecordVar.OwnerId) == null)
                    {
                        mapLeadUsersFromQueue.put(oLeadRecordVar.OwnerId, 
                        groupMemberVar.UserOrGroupId);
                    }
                }
            }
        }
        
        //Iteration performed for lead records to check for the 
        //corresponding automated task creation
        for(Lead oLeadRecordsVar: lstLeadRecords)
        {
            for(DeliverableBasedTaskList__c oDeliverableTaskLstVar:
            lstInitialDeliveryTask)
            {
                if(oDeliverableTaskLstVar.Type_Values__c == null && 
                oDeliverableTaskLstVar.Object_Name__c==System.Label.Lead_Object)
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);                    
                    mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                    oLeadRecordsVar.id);
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,'');
                    mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                    oLeadRecordsVar.id);
                    if(mapLeadUsersFromQueue.get(oLeadRecordsVar.OwnerId)<>null)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        mapLeadUsersFromQueue.get(oLeadRecordsVar.OwnerId));
                    }
                    else
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oLeadRecordsVar.OwnerID);  
                    }
                }
                else if(oLeadRecordsVar.Lead_Score__c <> null && 
                oDeliverableTaskLstVar.Type_Values__c <> null && 
                oDeliverableTaskLstVar.Object_Name__c==System.Label.Lead_Object&&
                oLeadRecordsVar.Lead_Score__c >= 
                Integer.valueOf(oDeliverableTaskLstVar.Type_Values__c))
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);                    
                    mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                    oLeadRecordsVar.id);
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,'');
                    mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                    oLeadRecordsVar.id);
                    if(mapLeadUsersFromQueue.get(oLeadRecordsVar.OwnerId)<>null)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id,
                        mapLeadUsersFromQueue.get(oLeadRecordsVar.OwnerId));
                    }
                    else
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oLeadRecordsVar.OwnerID);  
                    }
                    
                }
            }
        }
        //This is called for task creation on lead
        createTaskRecords();
    }
    
    /**
    * Method name  : checkCampaignTaskCriteria
    * Description  : Use this method for creating automated tasks for the 
    *                Campaign Record Type based on the defined conditions
    *                
    * Return Type  : void
    * Parameter    : List<Campaign> 
    **/
    
    //This method is called to create automated tasks on the Campaign Record
    private void checkCampaignTaskCriteria(List<Campaign> lstCampaignBasedTask)
    {
        lstInitialDeliveryTask = new List<DeliverableBasedTaskList__c>();
        lstInitialDeliveryTask = [select Assigned_To__c, Campaign_Type__c,
        Dependency__c, Due_Date_Calculated_From__c, Due_Date_Object__c, 
        Due_Date_Scenario__c, Due_Date_Value__c, Object_Name__c,
        Object_Type__c, Order__c, Priority__c, Record_Type__c, Status__c,
        Status_Condition__c, Status_Object__c, Subject__c, Type__c,
        Type_Values__c from DeliverableBasedTaskList__c 
        where Record_Type__c = 'Campaign'];
        
        Map<Id, Campaign> mapCampaigns = new Map<Id,Campaign>(lstCampaignBasedTask);
        
        for(Task oTaskVar: [select Status, Unique_Reference__c, Due_Date__c, OwnerId, Custom_Settings_Linkage__c from Task where WhatId in :mapCampaigns.keyset()])
        {
            lstCompletedTasks.add(oTaskVar.Unique_Reference__c);            
        }
        
        //This iteration is used for creating final list of tasks with all 
        //corresponding task required field values
        for(Campaign oOldCampaignVar: lstCampaignBasedTask)
        {
            for(DeliverableBasedTaskList__c oDeliverableTaskLstVar:
            lstInitialDeliveryTask)
            {
                if(oDeliverableTaskLstVar.Type_Values__c == null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                && !lstCompletedTasks.contains(String.valueOf(oOldCampaignVar.id)))) &&
                oOldCampaignVar.Status <> System.Label.Cancelled &&
                oDeliverableTaskLstVar.Object_Type__c == 
                System.Label.Recordtype_Campaign && 
                oDeliverableTaskLstVar.Record_Type__c == 
                System.Label.Recordtype_Campaign)
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                    Date dDueDateValue;
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains
                    (System.Label.Before_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                        System.Label.Start_Date && 
                        oDeliverableTaskLstVar.Due_Date_Value__c <> null &&
                        oOldCampaignVar.StartDate <> null)
                        {
                            dDueDateValue = 
                            oOldCampaignVar.StartDate.addDays(Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Campaign_Lanch_Date)
                        {
                            dDueDateValue = oOldCampaignVar.Launch_Date__c.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Campaign_Lanch_Date)
                        {
                            dDueDateValue = oOldCampaignVar.Launch_Date__c.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Id);
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Type);
                    mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                    oOldCampaignVar.id);
                    if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Campaign_Owner || 
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Project_Manager &&
                    oOldCampaignVar.Project_Manager__c == null))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.OwnerID);
                    }
                    else if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Project_Manager)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.Project_Manager__c);
                    }                           
                }
                else if(oOldCampaignVar.Status <> System.Label.Cancelled 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                && !lstCompletedTasks.contains(String.valueOf(oOldCampaignVar.id)))) &&
                oDeliverableTaskLstVar.Type_Values__c == 
                System.Label.Project_Manager &&
                oOldCampaignVar.Project_Manager__c <> null &&
                oDeliverableTaskLstVar.Object_Type__c == null &&
                oDeliverableTaskLstVar.Record_Type__c == 
                System.Label.Recordtype_Campaign)
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                    Date dDueDateValue;
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                        System.Label.Start_Date && 
                        oDeliverableTaskLstVar.Due_Date_Value__c <> null &&
                        oOldCampaignVar.StartDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf(-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Campaign_Lanch_Date)
                        {
                            dDueDateValue = oOldCampaignVar.Launch_Date__c.addDays
                            (Integer.valueOf(-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf(
                            oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Campaign_Lanch_Date)
                        {
                            dDueDateValue = oOldCampaignVar.Launch_Date__c.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Id);
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Type);
                    mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                    oOldCampaignVar.id);
                    if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Project_Manager && 
                    oOldCampaignVar.Project_Manager__c <> null)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.Project_Manager__c);
                    }
                    else if((oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Project_Manager && 
                    oOldCampaignVar.Project_Manager__c == null))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.OwnerID);
                    }
                }
                else if(oDeliverableTaskLstVar.Type_Values__c <> null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                && !lstCompletedTasks.contains(String.valueOf(oOldCampaignVar.id)))) &&
                oOldCampaignVar.Status <> null &&
                oDeliverableTaskLstVar.Object_Type__c == 
                System.Label.Recordtype_Campaign && 
                oDeliverableTaskLstVar.Record_Type__c == 
                System.Label.Recordtype_Campaign && 
                (oDeliverableTaskLstVar.Type_Values__c.toLowerCase().
                contains(oOldCampaignVar.Status.toLowerCase())))
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                    Date dDueDateValue;
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date && 
                        oDeliverableTaskLstVar.Due_Date_Value__c <> null &&
                        oOldCampaignVar.StartDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Campaign_Lanch_Date)
                        {
                            dDueDateValue = oOldCampaignVar.Launch_Date__c.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Campaign_Lanch_Date)
                        {
                            dDueDateValue = oOldCampaignVar.Launch_Date__c.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                    }
                    mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Id);
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Type);
                    mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                    oOldCampaignVar.id);
                    if(oDeliverableTaskLstVar.Assigned_To__c ==
                    System.Label.Campaign_Owner || 
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Specialist && 
                    oOldCampaignVar.EVE_Specialist__c == null) ||
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Project_Manager &&
                    oOldCampaignVar.Project_Manager__c == null))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.OwnerID);
                    }
                    else if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Project_Manager)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.Project_Manager__c);
                    }
                    else if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Specialist)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id,
                        oOldCampaignVar.EVE_Specialist__c);
                    }                   
                    
                }
                
            }
        }
        
        createTaskRecords();
    }
    
    /**
    * Method name  : checkEventLocationTaskCriteria
    * Description  : Use this method for creating automated tasks for the Event 
    *                Location Record Type based on the defined conditions
    *                
    * Return Type  : void
    * Parameter    : List<Campaign> campaignBasedTask
    **/
    
    //This method is called to create automated tasks on the Event Location 
    //Record
    private void checkEventLocationTaskCriteria(List<Campaign> 
    eventLocationBasedTask, List<Id> eventId,
    Map<Id, String> eventRefToEventLocation, String sDMLType)
    {
        lstInitialDeliveryTask = new List<DeliverableBasedTaskList__c>();
        lstInitialDeliveryTask = [select Assigned_To__c, Campaign_Type__c,
        Dependency__c, Due_Date_Calculated_From__c, Due_Date_Object__c, 
        Due_Date_Scenario__c, Due_Date_Value__c, Object_Name__c, Object_Type__c,
        Order__c, Priority__c, Record_Type__c, Status__c, Status_Condition__c,
        Status_Object__c, Subject__c, Type__c, Type_Values__c from
        DeliverableBasedTaskList__c where Record_Type__c = 'Event Location'];
        //Retrieves deliverable records via SOQL for the corresponding event 
        //with which this event location is related and 
        //create tasks on event location
        List<Deliverable__c> listDeliverableRelatedRecords = [select id, Type__c
        from Deliverable__c where Event__c in :eventId];
        List<Id> listIds = new List<Id>();
        Map<Id,String> mapTaskCompletion = new Map<Id,String>();
        Id marketingWebTeamId;
        
        for(Campaign newCampaignVar: eventLocationBasedTask)
        {
            listIds.add(newCampaignVar.id);
        }
        
        for(Task oTaskVar: [select Status, Unique_Reference__c, Due_Date__c, OwnerId, Custom_Settings_Linkage__c from Task where WhatId in :eventId or WhatId in :listIds])
        {
            lstCompletedTasks.add(oTaskVar.Unique_Reference__c);            
        }
        
        //SOQL for identifying the completed tasks so that 
        //they should not be created again
        List<Task> tList = [select id, Status, Custom_Settings_Linkage__c, 
        WhatId from Task where WhatId in :listIds];
        for(Campaign newCampaignVar: eventLocationBasedTask)
        {
            for(Task taskVar: tList)
            {
                if(taskVar.Status == System.Label.Cancelled ||
                taskVar.Status == System.Label.CampaignStatus_Completed)
                {
                    mapTaskCompletion.put(newCampaignVar.id,
                    taskVar.Custom_Settings_Linkage__c);
                }
            }
        }
        //Final Iteration where the corresponding conditions are checked and 
        //a final task list is generated
        for(Campaign oOldCampaignVar: eventLocationBasedTask)
        {
            for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
            lstInitialDeliveryTask)
            {
                if((oDeliverableTaskLstVar.Type_Values__c <> null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                && !lstCompletedTasks.contains(String.valueOf(oOldCampaignVar.id)))) &&
                (oDeliverableTaskLstVar.id <> mapTaskCompletion.get
                (oOldCampaignVar.id)) &&
                oDeliverableTaskLstVar.Object_Type__c ==
                System.Label.Recordtype_Campaign  && 
                (oDeliverableTaskLstVar.Type_Values__c.toLowerCase().contains(oOldCampaignVar.Status.toLowerCase()) ||
                (eventRefToEventLocation.get
                (oOldCampaignVar.id) <> null && 
                oDeliverableTaskLstVar.Type_Values__c.toLowerCase().
                contains(eventRefToEventLocation.get
                (oOldCampaignVar.id).toLowerCase())))) ||
                ((oDeliverableTaskLstVar.id <> mapTaskCompletion.get
                (oOldCampaignVar.id)) && 
                sDMLType == System.Label.DMLType_Insert && 
                oDeliverableTaskLstVar.Subject__c.contains('Confirm Venue')) ||
                (oOldCampaignVar.Order_Child_Packets__c &&
                oDeliverableTaskLstVar.Type__c <> null &&
                oDeliverableTaskLstVar.Type__c == 
                System.Label.Order_Beneficiary_Packets_Task &&
                (oOldCampaignVar.Status <> System.Label.Cancelled &&
                oOldCampaignVar.Status <> System.Label.CampaignStatus_Event_Location) &&
                oDeliverableTaskLstVar.Record_Type__c == 
                System.Label.Recordtype_EventLocation))
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                    Date dDueDateValue;
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date && oOldCampaignVar.StartDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date && oOldCampaignVar.EndDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                    }
                    
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date && oOldCampaignVar.StartDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                        else if(oOldCampaignVar.EndDate <> null &&
                        oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date && oOldCampaignVar.EndDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                    }
                    if(oDeliverableTaskLstVar.Record_Type__c ==
                    System.Label.Recordtype_Event)
                    {
                        mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                        oOldCampaignVar.Event__c);
                    }
                    else if(oDeliverableTaskLstVar.Record_Type__c ==
                    System.Label.Recordtype_EventLocation)
                    {
                        mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                        oOldCampaignVar.id);
                    }
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Type);
                    if(oOldCampaignVar.Status <> 
                    System.Label.CampaignStatus_Cancelled &&
                    oOldCampaignVar.Status <> 
                    System.Label.CampaignStatus_Event_Location &&
                    oOldCampaignVar.Status <> 
                    System.Label.Status_Event_Lost)
                    mapTaskRecurssion.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.id);
                    if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Campaign_Owner || 
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Specialist &&
                    oOldCampaignVar.EVE_Specialist__c == null) ||
                    (oDeliverableTaskLstVar.Assigned_To__c ==
                    System.Label.Marketing_Web_Team_Member &&
                    (marketingWebTeamId == null ||
                    listDeliverableRelatedRecords.size() == 0)))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id,
                        oOldCampaignVar.OwnerID);
                    }
                    else if((oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Specialist) || 
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Marketing_Web_Team_Member &&
                    (marketingWebTeamId == null ||
                    listDeliverableRelatedRecords.size() == 0)))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.EVE_Specialist__c);
                    }
                    else if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Marketing_Web_Team_Member && 
                    marketingWebTeamId <> null)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        marketingWebTeamId);
                    }                    
                    else if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Volunteer_Coordinator)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.Volunteer_Coordinator__c);
                    }                           
                }
                
                //This is for the tasks to be created on EVent Location based on
                //the deliverable related conditions
                if(listDeliverableRelatedRecords.size() > 0 && 
                oOldCampaignVar.Status <> System.Label.Cancelled &&
                oDeliverableTaskLstVar.Object_Type__c == 
                System.Label.Deliverable_Object)
                {
                    for(Deliverable__c oDeliverableVar: 
                    listDeliverableRelatedRecords)
                    {
                        if(oDeliverableVar.Type__c <> null && 
                        oDeliverableTaskLstVar.Type_Values__c == 
                        oDeliverableVar.Type__c)
                        {
                            if((oDeliverableTaskLstVar.Subject__c.contains
                            (System.Label.Volunteer_Coordinator_Based_First_Task) ||
                            (oDeliverableTaskLstVar.Subject__c.contains(System.Label.Volunteer_Coordinator_Based_SecondTask)))
                            && oOldCampaignVar.Volunteer_Coordinator__c <> null)
                            {
                                setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                            }
                            else
                            {
                                setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                            }
                            Date dDueDateValue;
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                            {
                                if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.Start_Date && 
                                oOldCampaignVar.StartDate <> null)
                                {
                                    dDueDateValue = oOldCampaignVar.StartDate.addDays
                                    (Integer.valueOf(-oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                                else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.End_Date &&
                                oOldCampaignVar.EndDate <> null)
                                {
                                    dDueDateValue = 
                                    oOldCampaignVar.EndDate.addDays(Integer.valueOf
                                    (-oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                            }
                            
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                            {
                                if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                                System.Label.Start_Date && 
                                oOldCampaignVar.StartDate <> null)
                                {
                                    dDueDateValue = oOldCampaignVar.StartDate.addDays
                                    (Integer.valueOf
                                    (oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                                else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                                System.Label.End_Date && 
                                oOldCampaignVar.EndDate <> null)
                                {
                                    dDueDateValue = 
                                    oOldCampaignVar.EndDate.addDays
                                    (Integer.valueOf
                                    (oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                            }
                            if(oDeliverableTaskLstVar.Record_Type__c == 
                            System.Label.Recordtype_Event)
                            {
                                mapRelatedDeliverable.put
                                (oDeliverableTaskLstVar.id,
                                oOldCampaignVar.Event__c);
                            }
                            else if(oDeliverableTaskLstVar.Record_Type__c ==
                            System.Label.Recordtype_EventLocation)
                            {
                                mapRelatedDeliverable.put
                                (oDeliverableTaskLstVar.id,
                                oOldCampaignVar.id);
                            }
                            mapRelatedDeliverableTasks.put
                            (oDeliverableTaskLstVar.id,
                            oOldCampaignVar.Type);
                            mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                            oDeliverableVar.id);
                            if(oDeliverableTaskLstVar.Assigned_To__c == 
                            System.Label.Campaign_Owner ||
                            (oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Event_Specialist &&
                            oOldCampaignVar.EVE_Specialist__c == null) ||
                            (oDeliverableTaskLstVar.Assigned_To__c == 
                            'System.Label.Onsite_Facilitator' && 
                            oOldCampaignVar.Primary_Compassion_Contact__c == 
                            null))
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id, 
                                oOldCampaignVar.OwnerID);
                            }
                            else if((oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Event_Specialist) ||
                            (oDeliverableTaskLstVar.Assigned_To__c ==
                            'System.Label.Onsite_Facilitator' && 
                            oOldCampaignVar.Primary_Compassion_Contact__c==null)) 
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id, 
                                oOldCampaignVar.EVE_Specialist__c);
                            }
                            else if((oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Event_Specialist) )
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id, 
                                oOldCampaignVar.EVE_Specialist__c); 
                            }
                            else if(oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Onsite_Facilitator &&  
                            oOldCampaignVar.Primary_Compassion_Contact__c<>null)
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id,
                                oOldCampaignVar.OwnerId);
                            }
                            
                            else if(oDeliverableTaskLstVar.Assigned_To__c == 
                            System.Label.Event_Volunteer_Coordinator)
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id, 
                                oOldCampaignVar.Volunteer_Coordinator__c);
                            }
                        }
                    }
                }
            }
        }
        
        createTaskRecords();
    }
    
    /**
    * Method name  : checkForEventTaskCriteria
    * Description  : Use this method for creating automated tasks for the Event
    *                Record Type based on the defined conditions
    *                
    * Return Type  : void
    * Parameter    : List<Campaign> campaignBasedTask
    **/
    
    //This method is called to create automated tasks on the Event Record
    private void checkForEventTaskCriteria(List<Campaign> eventBasedTask,
    List<Id> eventId)
    {
        lstInitialDeliveryTask = new List<DeliverableBasedTaskList__c>();
lstInitialDeliveryTask = [select Assigned_To__c, Campaign_Type__c,
 Dependency__c, Due_Date_Calculated_From__c, Due_Date_Object__c, 
 Due_Date_Scenario__c, Due_Date_Value__c, Object_Name__c, Object_Type__c, 
 Order__c, Priority__c, Record_Type__c, Status__c, Status_Condition__c,
 Status_Object__c, Subject__c, Type__c, 
 Type_Values__c from DeliverableBasedTaskList__c where 
 Record_Type__c = 'Event' or Record_Type__c = 'Event Location'];
 
 
 for(Task oTaskVar: [select Status, Unique_Reference__c, Due_Date__c, OwnerId, Custom_Settings_Linkage__c from Task where WhatId in :eventId])
        {
            lstCompletedTasks.add(oTaskVar.Unique_Reference__c);            
        }
               
        //SOQL is used for retrieving event location records for the 
        //corresponding event
        List<Campaign> listEventLocationRelated = [select id, Status, Type, 
        Volunteer_Coordinator__c, OwnerId from Campaign where 
        recordTypeId = :eventLocationRecordTypeId and Event__c in :eventId];
        Boolean bCriteriaMet = false;
        Id coordinatorId;
        
        //Iteration for retrieving the Volunteer COordinator record
        if(listEventLocationRelated.size() > 0)
        {
            for(Campaign oCampaignVar: listEventLocationRelated)
            {
                if(oCampaignVar.Status == System.Label.Cancelled || 
                oCampaignVar.Status == 
                System.Label.CampaignStatus_Event_Location)
                {
                    bCriteriaMet = true;
                }
                if(oCampaignVar.Volunteer_Coordinator__c <> null)
                {
                    coordinatorId = oCampaignVar.Volunteer_Coordinator__c;
                }               
            }
        }
        
        //Deliverable records linked to this event is retrieved in this SOQL
        List<Deliverable__c> listDeliverableRelatedRecords = [select id, 
        Status__c, Type__c, Assigned_To__c from Deliverable__c where
        Event__c in :eventId];
        Id marketingWebTeamId;
        for(Deliverable__c oDeliverableVar: listDeliverableRelatedRecords)
        {
            if(oDeliverableVar.Assigned_To__c <> null)
            {
                marketingWebTeamId = oDeliverableVar.Assigned_To__c;
            }
        }
        
        //Final Iteration to check for the conditions and 
        //create final task list to be created
        for(Campaign oOldCampaignVar: eventBasedTask)
        {
            for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
            lstInitialDeliveryTask)
            {
                if((oDeliverableTaskLstVar.Type_Values__c <> null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                && !lstCompletedTasks.contains(String.valueOf(oOldCampaignVar.id)))) && 
                oDeliverableTaskLstVar.Record_Type__c == 
                System.Label.Recordtype_Event && 
                oDeliverableTaskLstVar.Object_Type__c == 
                System.Label.Recordtype_Campaign && 
                oDeliverableTaskLstVar.Record_Type__c ==
                System.Label.Recordtype_Event && 
                oOldCampaignVar.Status <> null && 
                (oDeliverableTaskLstVar.Type_Values__c.toLowerCase().contains
                (oOldCampaignVar.Status.toLowerCase()))))
                {
                    setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                    Date dDueDateValue;
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date && 
                        oDeliverableTaskLstVar.Due_Date_Value__c <> null &&
                        oOldCampaignVar.StartDate <> null)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (-oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                    {
                        if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.Start_Date)
                        {
                            dDueDateValue = oOldCampaignVar.StartDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id,
                            dDueDateValue);
                        }
                        else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                        System.Label.End_Date)
                        {
                            dDueDateValue = oOldCampaignVar.EndDate.addDays
                            (Integer.valueOf
                            (oDeliverableTaskLstVar.Due_Date_Value__c));
                            mapDueDate.put(oDeliverableTaskLstVar.id, 
                            dDueDateValue);
                        }
                    }
                    mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Id);
                    mapRelatedDeliverableTasks.put(oDeliverableTaskLstVar.id,
                    oOldCampaignVar.Type);
                    if(oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Campaign_Owner || 
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Specialist && 
                    oOldCampaignVar.EVE_Specialist__c == null) || 
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Marketing_Web_Team_Member && 
                    (marketingWebTeamId == null || 
                    listDeliverableRelatedRecords.size() == 0)))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.OwnerID);
                    }
                    else if((oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Event_Specialist) ||
                    (oDeliverableTaskLstVar.Assigned_To__c == 
                    System.Label.Marketing_Web_Team_Member && 
                    (marketingWebTeamId == null ||
                    listDeliverableRelatedRecords.size() == 0)))
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        oOldCampaignVar.EVE_Specialist__c);
                    }
                    else if(oDeliverableTaskLstVar.Assigned_To__c ==
                    System.Label.Deliverable_Assigned_To &&
                    marketingWebTeamId <> null)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        marketingWebTeamId);
                    }
                    else if(oDeliverableTaskLstVar.Assigned_To__c ==
                    System.Label.Event_Volunteer_Coordinator)
                    {
                        mapUsers.put(oDeliverableTaskLstVar.id, 
                        coordinatorId);
                    }                           
                }
                
                if(listEventLocationRelated.size() > 0 && 
                oDeliverableTaskLstVar.Record_Type__c ==
                System.Label.Recordtype_EventLocation)
                {
                    for(Campaign eventLocationVar: listEventLocationRelated)
                    {
                        if(oDeliverableTaskLstVar.Subject__c == 
                        'Notify Onsite Facilitator of Cancellation' &&
                        oDeliverableTaskLstVar.Record_Type__c ==
                        System.Label.Recordtype_EventLocation && 
                        oDeliverableTaskLstVar.Type_Values__c <> null && 
                        oDeliverableTaskLstVar.Type_Values__c.toLowerCase().
                        contains(eventLocationVar.Status.toLowerCase()) &&
                        (eventLocationVar.Status == System.Label.Cancelled ||
                        eventLocationVar.Status == 'Location Lost' ))
                        {
                            
                            Date dDueDateValue;
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                            {
                                if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                                System.Label.Start_Date && 
                                eventLocationVar.StartDate <> null)
                                {
                                    dDueDateValue = 
                                    oOldCampaignVar.StartDate.addDays
                                    (Integer.valueOf
                                    (-oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                                else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.End_Date &&
                                eventLocationVar.EndDate <> null)
                                {
                                    dDueDateValue = eventLocationVar.EndDate.addDays
                                    (Integer.valueOf
                                    (-oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                            }
                            
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                            {
                                if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.Start_Date && 
                                eventLocationVar.StartDate <> null)
                                {
                                    dDueDateValue = 
                                    eventLocationVar.StartDate.addDays
                                    (Integer.valueOf
                                    (oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                                else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.End_Date && 
                                eventLocationVar.EndDate <> null)
                                {
                                    dDueDateValue = eventLocationVar.EndDate.addDays
                                    (Integer.valueOf
                                    (oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id,
                                    dDueDateValue);
                                }
                            }
                          
                           
                           Task oNewTaskCreationVar = new Task();
                        oNewTaskCreationVar.WhatId = eventLocationVar.id;
                        oNewTaskCreationVar.Task_Type__c= 
                        oDeliverableTaskLstVar.Record_Type__c;
                        if(oDeliverableTaskLstVar.Due_Date_Object__c.contains(System.Label.Task_Object))
                        {
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                            {
                                oNewTaskCreationVar.ActivityDate = System.Today().
                                addDays(-Integer.valueOf
                                (oDeliverableTaskLstVar.Due_Date_Value__c));
                            }
                            else if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                            {
                                oNewTaskCreationVar.ActivityDate =
                                System.Today().addDays(Integer.valueOf
                                (oDeliverableTaskLstVar.Due_Date_Value__c));
                            }
                            
                        }
                        else
                        {
                            oNewTaskCreationVar.ActivityDate = 
                            mapDueDate.get(oDeliverableTaskLstVar.id);
                        }
                        oNewTaskCreationVar.OwnerID = eventLocationVar.OwnerId;
                        oNewTaskCreationVar.Status =  
                        oDeliverableTaskLstVar.Status__c;
                        oNewTaskCreationVar.Priority = 
                        oDeliverableTaskLstVar.Priority__c;
                        oNewTaskCreationVar.Subject =
                        oDeliverableTaskLstVar.Subject__c;
                        oNewTaskCreationVar.Custom_Settings_Linkage__c =
                        oDeliverableTaskLstVar.id;
                        String sUniqueKey = '';
                        sUniqueKey =  
                        eventLocationVar.id + '-' + oDeliverableTaskLstVar.id ;
                        oNewTaskCreationVar.Unique_Reference__c = 
                        sUniqueKey;
                        if(eventLocationVar.OwnerId <> null)
                        lstTask.add(oNewTaskCreationVar);
                            
                        }                         
                        
                    }
                }
                
                if(listDeliverableRelatedRecords.size() > 0 &&
                oDeliverableTaskLstVar.Object_Type__c == 
                System.Label.Deliverable_Object)
                {
                    for(Deliverable__c oDeliverableVar: 
                    listDeliverableRelatedRecords)
                    {
                        if(oDeliverableVar.Status__c <> System.Label.Cancelled 
                        && (lstCompletedTasks.isEmpty() || (lstCompletedTasks.size() >0 
                        && !lstCompletedTasks.contains(String.valueOf(oDeliverableTaskLstVar.id)) 
                        && !lstCompletedTasks.contains(String.valueOf(oOldCampaignVar.id)) 
                        && !lstCompletedTasks.contains(String.valueOf(oDeliverableVar.id)))) &&
                        oDeliverableVar.Type__c <> null &&
                        oDeliverableTaskLstVar.Record_Type__c == 
                        System.Label.Recordtype_Event && 
                        oDeliverableTaskLstVar.Type_Values__c.toLowerCase() ==
                        oDeliverableVar.Type__c.toLowerCase())
                        {
                            setFinalDeliveryTask.add(oDeliverableTaskLstVar);
                            Date dDueDateValue;
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.Before_Condition))
                            {
                                if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.Start_Date && 
                                oOldCampaignVar.StartDate <> null)
                                {
                                    dDueDateValue = oOldCampaignVar.StartDate.addDays
                                    (Integer.valueOf
                                    (-oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                                else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.End_Date && 
                                oOldCampaignVar.EndDate <> null)
                                {
                                    dDueDateValue = oOldCampaignVar.EndDate.addDays
                                    (Integer.valueOf
                                    (-oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id,
                                    dDueDateValue);
                                }
                            }
                            
                            if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains(System.Label.After_Condition))
                            {
                                if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c == 
                                System.Label.Start_Date &&
                                oOldCampaignVar.StartDate <> null)
                                {
                                    dDueDateValue = oOldCampaignVar.StartDate.addDays
                                    (Integer.valueOf
                                    (oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                                else if(oDeliverableTaskLstVar.Due_Date_Calculated_From__c ==
                                System.Label.End_Date && oOldCampaignVar.EndDate <> null)
                                {
                                    dDueDateValue = oOldCampaignVar.EndDate.addDays
                                    (Integer.valueOf
                                    (oDeliverableTaskLstVar.Due_Date_Value__c));
                                    mapDueDate.put(oDeliverableTaskLstVar.id, 
                                    dDueDateValue);
                                }
                            }
                            mapRelatedDeliverable.put(oDeliverableTaskLstVar.id,
                            oOldCampaignVar.Id);
                            mapRelatedDeliverableTasks.put
                            (oDeliverableTaskLstVar.id,
                            oOldCampaignVar.Type);
                            mapTaskRecurssion.put(oDeliverableTaskLstVar.id, 
                            oDeliverableVar.id);
                            if(oDeliverableTaskLstVar.Assigned_To__c == 
                            System.Label.Campaign_Owner ||
                            (oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Event_Specialist &&
                            oOldCampaignVar.EVE_Specialist__c == null) || 
                            (oDeliverableTaskLstVar.Assigned_To__c == 
                            System.Label.Deliverable_Assigned_To && 
                            oDeliverableVar.Assigned_To__c == null))
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id,
                                oOldCampaignVar.OwnerID);
                            }
                            else if(oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Event_Specialist )
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id, 
                                oOldCampaignVar.EVE_Specialist__c);                                
                                
                            }
                            else if(oDeliverableTaskLstVar.Assigned_To__c ==
                            System.Label.Deliverable_Assigned_To && 
                            oDeliverableVar.Assigned_To__c <> null)
                            {
                                mapUsers.put(oDeliverableTaskLstVar.id,
                                oDeliverableVar.Assigned_To__c);
                            }
                            else if(oDeliverableTaskLstVar.Assigned_To__c == 
                            System.Label.Event_Volunteer_Coordinator)
                            {
                                if(oOldCampaignVar.Volunteer_Coordinator__c <>
                                null)
                                mapUsers.put(oDeliverableTaskLstVar.id,
                                coordinatorId);                                
                                else
                                mapUsers.put(oDeliverableTaskLstVar.id,
                                oOldCampaignVar.OwnerID);
                            }
                        }
                    }
                }
            }
        }  
        
        createTaskRecords();
    }
    
    /**
    * Method name  : createTaskRecords
    * Description  : Use this method for creating automated tasks based on the 
    *                available final list of task provided from the
    *                 above set of methods
    * Return Type  : void
    * Parameter    : void
    **/
    
    //This method is used for creating Automated Task records.
    private void createTaskRecords()
    {
        List<Id> listParentIds = new List<Id>();
        List<String> listParents = new List<String>();
        List<String> listObjectReference = new List<String>();
        //Checks if the final List of Tasks is not empty
        if(setFinalDeliveryTask.size() > 0)
        {
            
            //Checks for all the mandatory task field values from the 
            //corresponding custom settings data and creates/updates the tasks 
            for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
            setFinalDeliveryTask)
            {
                Task oNewTaskCreationVar = new Task();
                if(oDeliverableTaskLstVar.Object_Name__c == 
                System.Label.Lead_Object)
                {
                    oNewTaskCreationVar.WhoId = 
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id);
                }
                else
                {
                    oNewTaskCreationVar.WhatId = 
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id);
                }
                if(oDeliverableTaskLstVar.Object_Name__c == 
                System.Label.Lead_Object)
                {
                    oNewTaskCreationVar.Task_Type__c =
                    System.Label.Task_Type_Contact;
                    if(oDeliverableTaskLstVar.Subject__c == 
                    System.Label.Lead_Task_Subject)
                    {
                        oNewTaskCreationVar.Method__c = 
                        System.Label.Lead_Method_Follow_Up;
                    }
                    else
                    {
                        oNewTaskCreationVar.Method__c =
                        System.Label.Lead_Method_Cultivation;
                    }
                }
                else
                {
                    if(oDeliverableTaskLstVar.Record_Type__c ==
                    System.Label.Deliverable_Object)
                    {
                        oNewTaskCreationVar.Task_Type__c = 
                        System.Label.DeliverableRecordType_Campaign;
                    }
                    else
                    {
                        oNewTaskCreationVar.Task_Type__c=
                        oDeliverableTaskLstVar.Record_Type__c;
                    }
                }
                if(oDeliverableTaskLstVar.Due_Date_Object__c.contains
                (System.Label.Task_Object))
                {
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains
                    (System.Label.Before_Condition))
                    {
                        oNewTaskCreationVar.ActivityDate = System.Today().addDays
                        (-Integer.valueOf(oDeliverableTaskLstVar.Due_Date_Value__c));
                    }
                    else if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains
                    (System.Label.After_Condition))
                    {
                        oNewTaskCreationVar.ActivityDate = System.Today().addDays
                        (Integer.valueOf(oDeliverableTaskLstVar.Due_Date_Value__c));
                    }
                    
                }
                else
                {
                    oNewTaskCreationVar.ActivityDate = 
                    mapDueDate.get(oDeliverableTaskLstVar.id);
                }
                
                if(oDeliverableTaskLstVar.Assigned_To__c <> null &&
                oDeliverableTaskLstVar.Assigned_To__c <> '')
                {
                    oNewTaskCreationVar.OwnerID =
                    mapUsers.get(oDeliverableTaskLstVar.id);
                }
                oNewTaskCreationVar.Status = oDeliverableTaskLstVar.Status__c;
                oNewTaskCreationVar.Priority =oDeliverableTaskLstVar.Priority__c;
                oNewTaskCreationVar.Subject =oDeliverableTaskLstVar.Subject__c;
                if(mapTaskRecurssion <> null && 
                mapTaskRecurssion.get(oDeliverableTaskLstVar.id) <> null)
                oNewTaskCreationVar.Related_Object_Reference__c =
                mapTaskRecurssion.get(oDeliverableTaskLstVar.id);                
                oNewTaskCreationVar.Custom_Settings_Linkage__c = 
                oDeliverableTaskLstVar.id;
                String sUniqueKey = '';
                if(mapTaskRecurssion <> null &&
                mapTaskRecurssion.get(oDeliverableTaskLstVar.id) <> null)
                {
                    sUniqueKey =
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id) + '-' +
                    oDeliverableTaskLstVar.id + '-' + 
                    mapTaskRecurssion.get(oDeliverableTaskLstVar.id);
                }
                else
                {
                    sUniqueKey = 
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id) + '-' +
                    oDeliverableTaskLstVar.id ;
                }
                oNewTaskCreationVar.Unique_Reference__c = sUniqueKey;
                if(mapUsers.get(oDeliverableTaskLstVar.id) <> null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks <> null 
                && !lstCompletedTasks.contains(oNewTaskCreationVar.Unique_Reference__c))))
                 lstTask.add(oNewTaskCreationVar); 
                            
            }
           
        }
        
        if(lstTask.size() > 0)
        {
            //This try catch bolck is kept as additional safety measure which 
            //ensures smooth running of code and to help debugger to 
            //identify the root cause
            //in case if any error or issue gets raised
            try
            {
                upsert lstTask Unique_Reference__c;
            }            
            catch(Exception ex)
            {
                //This is particularly kept to prevent the code breaking and 
                //will allow Developer to debug the reason for the same
                //This can also be well directed to any object field to capture
                //these defects in future for reference
                
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),
                'Task',String.valueOf(mapRelatedDeliverable.values()),
                'CampaignTriggerHelper','getCampaignLocation','Application',
                UserInfo.getUserId(), String.valueOf(lstTask),null);
                          
            }
            
        }
        
    }
    
    
    /**
    * Method name  : createDdeliverableTaskRecords
    * Description  : Use this method for creating automated tasks based on the 
    *                available final list of task provided from the
    *                above set of methods
    * Return Type  : void
    * Parameter    : void
    **/
    
    //This method is used for creating Automated Task records.
    private void createDeliverableTaskRecords()
    {
        List<Id> listParentIds = new List<Id>();
        List<String> listParents = new List<String>();
        List<String> listObjectReference = new List<String>();
        //Checks if the final List of Tasks is not empty
        System.debug('setFinalDeliverableDeliveryTask'+ setFinalDeliverableDeliveryTask.size());
        if(setFinalDeliverableDeliveryTask.size() > 0)
        {
            
            //Checks for all the mandatory task field values from the 
            //corresponding custom settings data and creates/updates the tasks 
            for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
            setFinalDeliverableDeliveryTask)
            {
                Task oNewTaskCreationVar = new Task();
                if(oDeliverableTaskLstVar.Object_Name__c == 
                System.Label.Lead_Object)
                {
                    oNewTaskCreationVar.WhoId = 
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id);
                }
                else
                {
                    oNewTaskCreationVar.WhatId = 
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id);
                }
                if(oDeliverableTaskLstVar.Object_Name__c == 
                System.Label.Lead_Object)
                {
                    oNewTaskCreationVar.Task_Type__c =
                    System.Label.Task_Type_Contact;
                    if(oDeliverableTaskLstVar.Subject__c == 
                    System.Label.Lead_Task_Subject)
                    {
                        oNewTaskCreationVar.Method__c = 
                        System.Label.Lead_Method_Follow_Up;
                    }
                    else
                    {
                        oNewTaskCreationVar.Method__c =
                        System.Label.Lead_Method_Cultivation;
                    }
                }
                else
                {
                    if(oDeliverableTaskLstVar.Record_Type__c ==
                    System.Label.Deliverable_Object)
                    {
                        oNewTaskCreationVar.Task_Type__c = 
                        System.Label.DeliverableRecordType_Campaign;
                    }
                    else
                    {
                        oNewTaskCreationVar.Task_Type__c=
                        oDeliverableTaskLstVar.Record_Type__c;
                    }
                }
                if(oDeliverableTaskLstVar.Due_Date_Object__c.contains
                (System.Label.Task_Object))
                {
                    if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains
                    (System.Label.Before_Condition))
                    {
                        oNewTaskCreationVar.ActivityDate = System.Today().addDays
                        (-Integer.valueOf(oDeliverableTaskLstVar.Due_Date_Value__c));
                    }
                    else if(oDeliverableTaskLstVar.Due_Date_Scenario__c.contains
                    (System.Label.After_Condition))
                    {
                        oNewTaskCreationVar.ActivityDate = System.Today().addDays
                        (Integer.valueOf(oDeliverableTaskLstVar.Due_Date_Value__c));
                    }
                    
                }
                else
                {
                    oNewTaskCreationVar.ActivityDate = 
                    mapDueDate.get(oDeliverableTaskLstVar.id);
                }
                
                if(oDeliverableTaskLstVar.Assigned_To__c <> null &&
                oDeliverableTaskLstVar.Assigned_To__c <> '')
                {
                    oNewTaskCreationVar.OwnerID =
                    mapUsers2.get(oDeliverableTaskLstVar.id);
                }
                oNewTaskCreationVar.Status = oDeliverableTaskLstVar.Status__c;
                oNewTaskCreationVar.Priority =oDeliverableTaskLstVar.Priority__c;
                oNewTaskCreationVar.Subject =oDeliverableTaskLstVar.Subject__c;
                if(mapTaskRecurssion <> null && 
                mapTaskRecurssion.get(oDeliverableTaskLstVar.id) <> null)
                oNewTaskCreationVar.Related_Object_Reference__c =
                mapTaskRecurssion.get(oDeliverableTaskLstVar.id);                
                oNewTaskCreationVar.Custom_Settings_Linkage__c = 
                oDeliverableTaskLstVar.id;
                String sUniqueKey = '';
                /*if(mapTaskRecurssion <> null &&
                mapTaskRecurssion.get(oDeliverableTaskLstVar.id) <> null)
                {
                    sUniqueKey =
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id) + '-' +
                    oDeliverableTaskLstVar.id + '-' + 
                    mapTaskRecurssion.get(oDeliverableTaskLstVar.id);
                }
                else
                {*/
                    sUniqueKey = 
                    mapRelatedDeliverable.get(oDeliverableTaskLstVar.id) + '-' +
                    oDeliverableTaskLstVar.id ;
                //}
                oNewTaskCreationVar.Unique_Reference__c = sUniqueKey;
                
            /*  system.debug(mapUsers2.get(oDeliverableTaskLstVar.id) <> null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks <> null 
                && !lstCompletedTasks.contains(oNewTaskCreationVar.Unique_Reference__c))));*/
                if(mapUsers2.get(oDeliverableTaskLstVar.id) <> null 
                && (lstCompletedTasks.isEmpty() || (lstCompletedTasks <> null 
                && !lstCompletedTasks.contains(oNewTaskCreationVar.Unique_Reference__c)))){
                // System.debug('@AAA@ Inside If');
                 lstTask.add(oNewTaskCreationVar); 
                }
            }
           
        }
        //System.debug('@AAA@ lstTask'+ lstTask);
        if(lstTask.size() > 0)
        {
            //This try catch bolck is kept as additional safety measure which 
            //ensures smooth running of code and to help debugger to 
            //identify the root cause
            //in case if any error or issue gets raised
            try
            {

                upsert lstTask Unique_Reference__c;
            }            

            catch(Exception ex)
            {

                //This is particularly kept to prevent the code breaking and 
                //will allow Developer to debug the reason for the same
                //This can also be well directed to any object field to capture
                //these defects in future for reference
                

                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),
                'Task',String.valueOf(mapRelatedDeliverable.values()),
                'CampaignTriggerHelper','getCampaignLocation','Application',
                UserInfo.getUserId(), String.valueOf(lstTask),null);
                          
            }
            
        }
    }
    /**
    * Method name  : assignEstimatedVolunteerNeed
    * Description  : Use this method for assigning value to Estimated Volunteer
    *                Needed field based on the mentioned conditions in 
    *                Custom Settings data
    *                This is also used for performing rollup to corresponding 
    *                event based on the values calculated in the corresponding 
    *                event locations
    * Return Type  : void
    * Parameter    : List<Campaign>
    **/
    //This method is used for assigning Estimated number of Volunteers based on
    //the User Input during record creation
    public void assignEstimatedVolunteerNeed(List<Campaign> lstCampaign)
    {
        List<Campaign> lstEventLocationRecords = new List<Campaign>();
        List<Campaign> lstFinalRecordsToUpdate = new List<Campaign>();
        
        List<Id> lstEvents = new List<Id>();
        Double dbVolunteerRollUp = 0;
        List<Id> lstRestrictedLocationIds = new List<Id>();
        
        for(Campaign oCampaignReferenceVar: lstCampaign)
        {
            if(oCampaignReferenceVar.RecordTypeId == eventLocationRecordTypeId)
            {
                lstEventLocationRecords.add(oCampaignReferenceVar);
            }
        }
        
        //Iteration to check for the required conditions and retrieve 
        //corresponding value from the custom settings data
        if(!lstEventLocationRecords.isEmpty())
        {
            List<VolunteerSizeDetermination__c> lstVolunteerReference = 
            VolunteerSizeDetermination__c.getAll().values();
            for(Campaign oEventLocationReferenceVar: lstEventLocationRecords)
            {
                for(VolunteerSizeDetermination__c oVolunteerReferenceVar :
                lstVolunteerReference)
                {
                    if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c <> null
                    && oEventLocationReferenceVar.Packet_Pass_Needed__c <> null &&
                    oEventLocationReferenceVar.Estimated_Audience_Size__c <> null)
                    {
                        if(oVolunteerReferenceVar.Booth_Operator__c.contains('='))
                        {
                            if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('='))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c == 
                                oVolunteerReferenceVar.Number_Of_Booths_Tables__c && 
                                oVolunteerReferenceVar .Packet_Pass_Needed__c ==
                                oEventLocationReferenceVar.Packet_Pass_Needed__c &&
                                oEventLocationReferenceVar.Estimated_Audience_Size__c == 
                                oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c =
                                    oVolunteerReferenceVar.Number_Of_Volunteers_Needed__c;
                                }
                            }
                            else if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('>'))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c == oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar .Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c >  oVolunteerReferenceVar .Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c =
                                    oVolunteerReferenceVar.Number_Of_Volunteers_Needed__c;
                                }
                            }
                            else if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('<'))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c == oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar .Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c < oVolunteerReferenceVar .Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c = 
                                    oVolunteerReferenceVar.Number_Of_Volunteers_Needed__c;
                                }
                            }
                        }
                        else if(oVolunteerReferenceVar.Booth_Operator__c.contains('>'))
                        {
                            if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('='))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c > oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar.Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c ==  oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c =
                                    oVolunteerReferenceVar .Number_Of_Volunteers_Needed__c;
                                }
                            }
                            else if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('>'))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c > oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar.Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c >  oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c =
                                    oVolunteerReferenceVar.Number_Of_Volunteers_Needed__c;
                                }
                            }
                            else if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('<'))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c > oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar.Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c < oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c =
                                    oVolunteerReferenceVar.Number_Of_Volunteers_Needed__c;
                                }
                            }
                        }
                        else if(oVolunteerReferenceVar.Booth_Operator__c.contains('<'))
                        {
                            if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('='))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c < oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar.Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c ==  oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c = 
                                    oVolunteerReferenceVar .Number_Of_Volunteers_Needed__c;
                                }
                            }
                            else if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('>'))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c < oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar.Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c >  oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c = 
                                    oVolunteerReferenceVar .Number_Of_Volunteers_Needed__c;
                                }
                            }
                            else if(oVolunteerReferenceVar.Event_Audience_Size_Operator__c.contains('<'))
                            {
                                if(oEventLocationReferenceVar.Number_Of_Booths_Tables__c < oVolunteerReferenceVar.Number_Of_Booths_Tables__c &&  oVolunteerReferenceVar.Packet_Pass_Needed__c == oEventLocationReferenceVar.Packet_Pass_Needed__c &&  oEventLocationReferenceVar.Estimated_Audience_Size__c < oVolunteerReferenceVar.Event_Audience_Size__c)
                                {
                                    oEventLocationReferenceVar.Estimated_Volunteers_Needed__c =
                                    oVolunteerReferenceVar.Number_Of_Volunteers_Needed__c;
                                }
                            }
                        }
                    }
                }
                
            }           
        }
        
        for(Campaign oCampaignReferenceVar: lstCampaign)
        {
            if(oCampaignReferenceVar.RecordTypeId == eventLocationRecordTypeId)
            {
                lstEventLocationRecords.add(oCampaignReferenceVar);
                lstEvents.add(oCampaignReferenceVar.Event__c);
                lstRestrictedLocationIds.add(oCampaignReferenceVar.id);
                if(oCampaignReferenceVar.Estimated_Volunteers_Needed__c <> null)
                {
                    dbVolunteerRollUp = 
                    oCampaignReferenceVar.Estimated_Volunteers_Needed__c;
                }
            }
            
        }
        
        List<Campaign> lstEventLocation = [select id, 
        Estimated_Volunteers_Needed__c from Campaign where 
        Event__c in :lstEvents and id not in :lstRestrictedLocationIds and 
        RecordTypeId = :eventLocationRecordTypeId];
        List<Campaign> lstUpdateEvents = new List<Campaign>();
        
        if(!lstEventLocation.isEmpty())
        {
            for(Campaign oEventLocationVar: lstEventLocation)
            {
                if(oEventLocationVar.Estimated_Volunteers_Needed__c <> null)
                {
                    dbVolunteerRollUp = dbVolunteerRollUp +
                    oEventLocationVar.Estimated_Volunteers_Needed__c;
                }
            }    
        }
        
        //This is used for updating the event records data for the 
        //corresponding event locations
        if(dbVolunteerRollUp <> 0)
        {
            for(Campaign oCampaignReferenceVar: [select id,
            Estimated_Volunteers_Needed__c from Campaign where 
            id in :lstEvents and recordtypeid = :eventRecordTypeId])
            {
                oCampaignReferenceVar.Estimated_Volunteers_Needed__c = 
                dbVolunteerRollUp; 
                lstUpdateEvents.add(oCampaignReferenceVar);       
            }
            
            if(!lstUpdateEvents.isEmpty())
            {
                try
                {
                    update lstUpdateEvents;
                }
                catch(Exception ex)
                {
                    //Creating a new Error Log record whenever 
                    //any exception is encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),
                    'Event_Location__c',String.valueOf(lstEvents),
                    'CampaignTriggerHelper','assignEstimatedVolunteerNeed',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstUpdateEvents),null);
                }
            }
        }
        
        
    }
    
    /**
    * Method name  : calculateGoalsInUpdateScenario
    * Description  : Use this method for Goal Calculation in the Update Scenario
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign>,  
    *                Map<Id, Campaign>, Map<Id, Campaign>
    **/
    //This method is used in Goal Calculation in the Update Scenario
    public void calculateGoalsInUpdateScenario(List<Campaign> lstOldCampaign,
    List<Campaign> lstNewCampaigns,  Map<Id,
    Campaign> newcampaignMap, Map<Id, Campaign> campaignMap)
    {    
        for(Campaign oOldCampaignVar: lstOldCampaign)
        {
            for(Campaign oNewCampaignVar: lstNewCampaigns)
            {    
                if((oNewCampaignVar.Program__c != null ) && (oNewCampaignVar.recordtypeid == eventRecordTypeId 
                            || oNewCampaignVar.recordtypeid == campaignRecordTypeId) && ( (oNewCampaignVar.Total_Budget__c != null && oOldCampaignVar.Total_Budget__c <> oNewCampaignVar.Total_Budget__c ) 
                            || ( oNewCampaignVar.Total_Expense__c != null && oOldCampaignVar.Total_Expense__c <> oNewCampaignVar.Total_Expense__c )) ) 
                {     
                    set<Id> setAvailableIds = newcampaignMap.keySet();
                    for(Id availableIdVar: setAvailableIds)
                    {
                        if(availableIdVar != null)
                        {
                            setProgramId.add
                            (newcampaignMap.get(availableIdVar).Program__c);                                     
                        }  
                    }                         
                    
                } 
                
                if((oNewCampaignVar.Program__c != null && (oOldCampaignVar.Program__c <> oNewCampaignVar.Program__c)) && (oNewCampaignVar.recordtypeid == eventRecordTypeId 
                            || oNewCampaignVar.recordtypeid == campaignRecordTypeId) && ( (oNewCampaignVar.Total_Budget__c != null  ) 
                            || ( oNewCampaignVar.Total_Expense__c != null )) ) 
                {                       
                    set<Id> setAvailableIds = newcampaignMap.keySet();
                    for(Id availableIdVar: setAvailableIds)
                    {
                        setProgramId.add(newcampaignMap.get(availableIdVar).Program__c);    
                    }        
                } 
                
                if(oNewCampaignVar.Program__c == null  && 
                (oOldCampaignVar.Program__c <> oNewCampaignVar.Program__c))
                {
                    set<Id> setAvailableIds = campaignMap.keySet();
                    for(Id availableIdVar: setAvailableIds)
                    {                                 
                        setProgramId.add(campaignMap.get
                        (availableIdVar).Program__c);                                    
                    }                      
                }        
                
                
                if(oNewCampaignVar.recordtypeid == eventLocationRecordTypeId)
                {       
                    if((oOldCampaignVar.Status <> System.Label.Cancelled && 
                    oNewCampaignVar.Status == System.Label.Cancelled) 
                            ||(oOldCampaignVar.Status <> 
                            System.Label.CampaignStatus_Event_Location && 
                            oNewCampaignVar.Status == 
                            System.Label.CampaignStatus_Event_Location))
                    {     
                        lstCampaign.add(oNewCampaignVar);      
                    }
                    
                    if((EventTriggerHelper.iRecursiveCheckVolunteerCoordinator < 1)
                    &&
                    (oOldCampaignVar.Volunteer_Coordinator__c <> 
                    oNewCampaignVar.Volunteer_Coordinator__c)
                    && oNewCampaignVar.Volunteer_Coordinator__c != null)
                    {     
                        lstEventLocationVolunteerCoordinatorUserIds.add
                        (oNewCampaignVar.Volunteer_Coordinator__c);
                    } 
                    
                    if((EventTriggerHelper.iRecursiveCheckVolunteerCoordinator < 1) 
                    && 
                    (oNewCampaignVar.Volunteer_Coordinator__c != null) && 
                    ((oOldCampaignVar.Total_Number_Of_Volunteer_Slots__c <> 
                    oNewCampaignVar.Total_Number_Of_Volunteer_Slots__c) 
                                ||(oOldCampaignVar.Booked_Volunteer_Slots__c <>
                                oNewCampaignVar.Booked_Volunteer_Slots__c)))
                    {     
                        lstEventLocationVolunteerCoordinatorUserIds.add
                        (oNewCampaignVar.Volunteer_Coordinator__c);
                    }
                }        
                
                if(oNewCampaignVar.recordtypeid == eventRecordTypeId)
                {
                    if(((oOldCampaignVar.Status <> System.Label.Cancelled &&
                    oNewCampaignVar.Status == System.Label.Cancelled) 
                                || (oOldCampaignVar.Status <> 
                                System.Label.Status_Event_Lost &&
                                oNewCampaignVar.Status == 
                                System.Label.Status_Event_Lost)) && 
                                (oNewCampaignVar.Cancellation_Reason__c == null
                                ||oNewCampaignVar.Cancellation_Reason__c == ''))
                    { 
                        oNewCampaignVar.addError
                        (System.Label.Cancellation_Error);
                        
                    }
                    else if(((oOldCampaignVar.Status <> System.Label.Cancelled
                    && oNewCampaignVar.Status == System.Label.Cancelled) 
                                || (oOldCampaignVar.Status <> 
                                System.Label.Status_Event_Lost &&
                                oNewCampaignVar.Status ==
                                System.Label.Status_Event_Lost)) &&
                                oNewCampaignVar.Cancellation_Reason__c <> null
                                && oNewCampaignVar.Cancellation_Reason__c <> '')
                    {
                        lstCampaign.add(oNewCampaignVar);
                    }
                    
                    if(oOldCampaignVar.Publish_to_Web__c != true &&
                    oNewCampaignVar.Publish_to_Web__c == true)
                    {
                        lstCampaign.add(oNewCampaignVar);
                    }
                    
                    if(oOldCampaignVar.Track_goals_at__c <>
                    System.Label.Recordtype_Event && 
                    oNewCampaignVar.Track_goals_at__c == 
                    System.Label.Recordtype_Event )
                    {
                        lstCampaignEventGoalsRollup.add(oNewCampaignVar);
                    }
                    else if(oOldCampaignVar.Track_goals_at__c <> 
                    System.Label.Recordtype_EventLocation &&
                    oNewCampaignVar.Track_goals_at__c == 
                    System.Label.Recordtype_EventLocation )
                    {
                        lstCampaignEventLocationGoalsRollup.add(oNewCampaignVar);
                    }
                }
                
                if(oNewCampaignVar.recordtypeid == campaignRecordTypeId)
                {
                    if(oOldCampaignVar.Status <> System.Label.Cancelled && 
                    oNewCampaignVar.Status == System.Label.Cancelled)
                    {
                        lstCampaign.add(oNewCampaignVar);
                    }
                } 
                
                if(EventTriggerHelper.iRecursiveCheckGoalsTrapId < 1 && 
                ((oOldCampaignVar.Actual_Revenue__c <> 
                oNewCampaignVar.Actual_Revenue__c ) 
                            ||(oOldCampaignVar.Actual_Sponsorships__c <>
                            oNewCampaignVar.Actual_Sponsorships__c ) 
                            ||(oOldCampaignVar.Actual_Impact__c <> 
                            oNewCampaignVar.Actual_Impact__c ) 
                            ||(oOldCampaignVar.Actual_Continuity__c <> 
                            oNewCampaignVar.Actual_Continuity__c) 
                            ||(oOldCampaignVar.Actual_Continuity_On_FCD__c <>
                            oNewCampaignVar.Actual_Continuity_On_FCD__c) 
                            ||(oOldCampaignVar.Actual_Impact_On_FCD__c <> 
                            oNewCampaignVar.Actual_Impact_On_FCD__c ) 
                            ||(oOldCampaignVar.Actual_Revenue_On_FCD__c <> 
                            oNewCampaignVar.Actual_Revenue_On_FCD__c ) 
                            ||(oOldCampaignVar.Actual_Sponsorships_On_FCD__c <> 
                            oNewCampaignVar.Actual_Sponsorships_On_FCD__c ))) 
                
                {
                    setActualsCalculationEventEvLocId.add(oNewCampaignVar.id);
                } 
                
                
            }
        }
        logicForProgramList();
    }
    
    /**
    * Method name  : goalsAssignmentOnInsert
    * Description  : Use this method for Goal Calculation in the Insert Scenario
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,Map<Id, Campaign> 
    **/
    
    //This method is used for goals assignment in Insert Operations
    public void goalsAssignmentOnInsert(List<Campaign> lstNewCampaigns,
    Map<Id, Campaign> mapNewCampaign)
    {
        for(Campaign oNewCampaignVar : lstNewCampaigns)
        {
            if((oNewCampaignVar.recordtypeid == eventLocationRecordTypeId) &&
            (oNewCampaignVar.Volunteer_Coordinator__c != null))
            {     
                lstEventLocationVolunteerCoordinatorUserIds.add
                (oNewCampaignVar.Volunteer_Coordinator__c);
            }           
            
            
            if(EventTriggerHelper.iRecursiveCheckGoalsTrapId < 1 && 
            ((oNewCampaignVar.Actual_Revenue__c != null) 
                        || (oNewCampaignVar.Actual_Sponsorships__c != null) 
                        || (oNewCampaignVar.Actual_Impact__c != null) 
                        || ( oNewCampaignVar.Actual_Continuity__c != null) 
                        || (oNewCampaignVar.Actual_Continuity_On_FCD__c != null) 
                        || (oNewCampaignVar.Actual_Impact_On_FCD__c != null) 
                        || ( oNewCampaignVar.Actual_Revenue_On_FCD__c!= null) 
                        ||(oNewCampaignVar.Actual_Sponsorships_On_FCD__c !=null)))
            
            {
                setActualsCalculationEventEvLocId.add(oNewCampaignVar.id);
            } 
            if(oNewCampaignVar.Program__c != null && 
            (oNewCampaignVar.recordtypeid == eventRecordTypeId || 
            oNewCampaignVar.recordtypeid == campaignRecordTypeId) && 
            ( (oNewCampaignVar.Total_Budget__c != null  ) || 
            ( oNewCampaignVar.Total_Expense__c != null ))) 
            {
                set<Id> setAvailableIds = mapNewCampaign.keySet();
                for(Id availableIdVar: setAvailableIds)
                {
                    setProgramId.add(mapNewCampaign.get
                    (availableIdVar).Program__c);   
                }                      
            }                                           
        }
        logicForProgramList();
    }
    
    //This method is used for performing post delete operations for 
    //Goals assignment
    public void performPostDeleteOperations(Map<Id, Campaign> mapCampaign)
    {
        set<Id> setAvailableIds = mapCampaign.keySet();
        for(Id availableIdVar: setAvailableIds)
        {
            setProgramId.add(mapCampaign.get(availableIdVar).Program__c);   
        }
        logicForProgramList(); 
    }
    
    //This method is used for calling helper class for executing 
    //additional calculation logic after the final list is identified
    private void logicForProgramList()
    {
        EventTriggerHelper helperReference = new EventTriggerHelper();
        if(setProgramId.size()>0)
        {
            helperReference.UpdateProgramEventCampaignRollup
            (lstProgramRollUpCampaign, setProgramId);         
        }
        
        if(lstCampaignEventGoalsRollup.size() > 0)
        {
            helperReference.RollUpRelatedGoalsEvent(lstCampaignEventGoalsRollup);
        }
        
        if(lstCampaignEventLocationGoalsRollup.size() > 0)
        {
            helperReference.RollUpRelatedGoalsEventLocation
            (lstCampaignEventLocationGoalsRollup);
        }
        
        if(lstCampaign.size() > 0)
        {
            helperReference.closeRelatedEvents(lstCampaign);
        }
        
        if(setActualsCalculationEventEvLocId.size() > 0)
        {
            helperReference.GoalsIDTrap(lstGoals , true, 
            setActualsCalculationEventEvLocId );
        }   
        
    }
    
       
    
    /**
    * Method name  : shareUnshareCampaign
    * Description  : Use this method for providing or 
    *                revoking the sharing access on Campaign for a User
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Campaign> ,Map<Id,Campaign> ,List<Campaign> ,boolean 
    **/
    
    public void shareUnshareCampaign(Map<Id,Campaign> mapNewCampaign,
    Map<Id,Campaign> mapOldCampaign,List<Campaign> lstNewCampaign,boolean bIsUpdate){

        List<Campaign> lstCampaign=new List<Campaign>();
        Id recorTypeId=Utility.getRecordtype
        (System.Label.Recordtype_Campaign,System.Label.Recordtype_Campaign);
        
        if(!bIsUpdate){            
            
            for(Campaign oNewCampaignVar :lstNewCampaign){
                
                if((oNewCampaignVar.recordtypeId==recorTypeId)&&
                (oNewCampaignVar.Agency__c!=null))
                lstCampaign.add(oNewCampaignVar);
                
            } 
            
            if( lstCampaign.size()>0) 
            ShareUnshareHelper.shareUnShareCampaign(lstNewCampaign,true);
            
        }
        else{
            
            for(Id oCampaignIdVar: mapOldCampaign.keySet()){
                
                if((mapnewCampaign.get(oCampaignIdVar).Agency__c!=
                mapOldCampaign.get(oCampaignIdVar).Agency__c)&&
                (mapnewCampaign.get(oCampaignIdVar).recordtypeId==recorTypeId))
                lstCampaign.add(mapnewCampaign.get(oCampaignIdVar));
                
            }
            if(lstCampaign.size()>0){
                ShareUnshareHelper.shareUnShareCampaign
                (mapOldCampaign.values(),false);
                ShareUnshareHelper.shareUnShareCampaign(lstCampaign,true);
            }
        } 
    }
    
    /**
    * Method name  : trackGoalsAtValidationRule
    * Description  : Use this method for validating if the track goals at 
    *                condition for entering the goals either in 
    *                event or event location
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign>
    **/

    //This method is used for validating the event record before save whether
    //the track goals at is being changed after goal addition
    
    public void trackGoalsAtValidationRule(Map<id,Campaign> mapOldCampaign,
    Map<Id, Campaign> mapNewCampaign)
    {
        Map<Id,Campaign> mapGoalsBelowEventId = new Map<Id,Campaign>();
        Map<Id,Campaign> mapGoalsBelowEventLocationId = new Map<Id,Campaign>();
        Map<Id, String> lstErrorCampaigns = new Map<Id, String>();
        
        for(Campaign oCampaignVar : mapNewCampaign.values())
        {
            if(oCampaignVar.Track_Goals_At__c <> null && oCampaignVar.Track_Goals_At__c <> mapOldCampaign.get(oCampaignVar.id).Track_Goals_At__c)
            {
                if(oCampaignVar.Track_Goals_At__c == System.label.EventLocation_TrackGoalAt)
                {
                    mapGoalsBelowEventId.put(oCampaignVar.id, oCampaignVar);
                }
                else
                {
                    mapGoalsBelowEventLocationId.put(oCampaignVar.id, oCampaignVar);
                }
            }           
        }
        if(mapGoalsBelowEventId.size() > 0 || mapGoalsBelowEventLocationId.size() > 0)
        {
            
            List<Goals__c> lstGoalsPresent = new List<Goals__c>([select id, Campaign__c, Campaign__r.Event__c from Goals__c where Campaign__r.Event__c in :mapGoalsBelowEventLocationId.keyset() OR Campaign__c in :mapGoalsBelowEventId.keyset()]);
            
            
            for(Goals__c oGoalVar : lstGoalsPresent)
            {
                if(oGoalVar.Campaign__r.Event__c <> null)
                mapNewCampaign.get(oGoalVar.Campaign__r.Event__c).Track_Goals_At__c.addError(System.Label.TrackGoalsAt_Event);
                else
                mapNewCampaign.get(oGoalVar.Campaign__c).Track_Goals_At__c.addError(System.Label.TrackGoalsAt_EventLocation);
            }
        }
    }
    /**
    * Method name  : trackInfluencersAtValidationRule
    * Description  : Use this method for validating if the track influencers at 
    *                condition for entering the influencers either in 
    *                event or event location
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign>
    **/
    
    //Oct-2015 Shanu- Changes made for COR0001497
    //This method is used for validating the event record before save whether
    //the track influencers at is being changed after the influencer addition
    
    public void trackInfluencersAtValidationRule(Map<id,Campaign> mapOldCampaign,
    Map<Id, Campaign> mapNewCampaign)
    {
        Map<Id,Campaign> mapInfluencersBelowEventId = new Map<Id,Campaign>();
        Map<Id,Campaign> mapInfluencersBelowEventLocationId = new Map<Id,Campaign>();
        Map<Id, String> lstErrorCampaigns = new Map<Id, String>();
        
        for(Campaign oCampaignVar : mapNewCampaign.values())
        {
            if(oCampaignVar.Track_Influencer_At__c <> null && oCampaignVar.Track_Influencer_At__c <> mapOldCampaign.get(oCampaignVar.id).Track_Influencer_At__c)
            {
                if(oCampaignVar.Track_Influencer_At__c == System.label.EventLocation_TrackInfluencerAt)
                {
                    mapInfluencersBelowEventId.put(oCampaignVar.id, oCampaignVar);
                }
                else
                {
                    mapInfluencersBelowEventLocationId.put(oCampaignVar.id, oCampaignVar);
                }
            }           
        }
        if(mapInfluencersBelowEventId.size() > 0 || mapInfluencersBelowEventLocationId.size() > 0)
        {
            
            List<Influencer__c> lstInfluencersPresent = new List<Influencer__c>([select id, Campaign__c, Campaign__r.Event__c from Influencer__c where Campaign__r.Event__c in :mapInfluencersBelowEventLocationId.keyset() OR Campaign__c in :mapInfluencersBelowEventId.keyset()]);
            
            
            for(Influencer__c oInfluencerVar : lstInfluencersPresent)
            {
                if(oInfluencerVar.Campaign__r.Event__c <> null)
                mapNewCampaign.get(oInfluencerVar.Campaign__r.Event__c).Track_Influencer_At__c.addError(System.Label.TrackInfluencersAt_Event);
                else
                mapNewCampaign.get(oInfluencerVar.Campaign__c).Track_Influencer_At__c.addError(System.Label.TrackInfluencersAt_EventLocation);
            }
        }
    }
    
    
    /**
    * Method name  : trackGoalsAtValidationRule
    * Description  : Use this method for validating if the track goals at 
    *                condition for entering the goals either in 
    *                event or event location
    * Return Type  : void
    * Parameter    : List<Campaign>, List<Campaign>
    **/
    
    //This method is used for validating the event record before save whether
    //the track goals at is being changed after goal addition
    /*
    public void trackGoalsAtValidationRule(List<Campaign> lstOldCampaign,
    List<Campaign> lstNewCampaign)
    {
        list<id> lstGoalsBelowEventId = new list<id>();
        list<id> lstGoalsBelowEventLocationId = new list<id>();
        string sErrorMsg;
        
        for(Campaign oNewCampaignVar: lstNewCampaign)
        {
            for(Campaign oOldCampaignVar: lstOldCampaign)
            {
                if(oNewCampaignVar.Track_Goals_At__c <> 
                oOldCampaignVar.Track_Goals_At__c)
                {   
                    if(oNewCampaignVar.Track_Goals_At__c ==
                    System.label.EventLocation_TrackGoalAt)
                    {
                        lstGoalsBelowEventId.add(oNewCampaignVar.id);  
                        
                        if(lstGoalsBelowEventId!= null)
                        {
                            list<Goals__c> lstGoals = [select id, 
                            name from Goals__c where 
                            Campaign__r.id in :lstGoalsBelowEventId];
                            if(lstGoals.size() <> 0)
                            {
                                sErrorMsg=System.Label.TrackGoalsAt_EventLocation;
                                //There are existing goals at Event. 
                                //Please update or delete them to continue.m.
                                
                                oNewCampaignVar.addError(sErrorMsg );    
                            }
                        } 
                    }
                    else if(oNewCampaignVar.Track_Goals_At__c == 
                    System.label.Event_TrackGoalAt)
                    {
                        lstGoalsBelowEventLocationId.add(oNewCampaignVar.id); 
                        if(lstGoalsBelowEventLocationId!= null)
                        {
                            list <id> lstEventLocationIds = new list<id>();
                            list<Campaign> lstEvLoc = [select id,
                            Name from Campaign where event__r.id in:
                            lstGoalsBelowEventLocationId and 
                            recordtypeid =: eventLocationRecordTypeId ];  
                            if(lstEvLoc != null)
                            {
                                for(Campaign c: lstEvLoc)
                                {
                                    lstEventLocationIds.add(c.id);
                                }        
                            }
                            list<Goals__c> lstGoals = [select id, 
                            name from Goals__c where 
                            Campaign__r.id in :lstEventLocationIds];
                            if(lstGoals.size() <> 0)
                            {
                                sErrorMsg =System.Label.TrackGoalsAt_Event ;
                                //You have already Goals at Event Location level,
                                //Either delete those Goals or Update them.
                                
                                oNewCampaignVar.addError(sErrorMsg );                    
                            }
                        }
                        
                        
                    }                        
                }
            }
        }
    } */
}