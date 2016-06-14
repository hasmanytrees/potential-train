/*
    ****************************************************************************
    Name             : CampaignTriggerHandler
    Description      : Trigger Handler class used to handle the scenario of 
                       task creation, influencer creation, RM Manager Assignment, 
                       Validations, Goals and Budget Calculation.                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit                05/12/2014            Created
    Sumeet                  02/02/2015            Modified for code re-factoring 
                                                  & optimization
    ***************************************************************************/
 


public without sharing class CampaignTriggerHandler
{   
    
    //Class Variable defined for initializing and using the 
    //same reference of the class over again.
    private CampaignTriggerHelper helperReference;
    
    /**
    * Method name  : Constructor
    * Description  : Used for Initializing the Trigger Helper Class
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    
    //Defining the constructor
    public CampaignTriggerHandler()
    {
        //Initializing the helper class reference
        helperReference = new CampaignTriggerHelper();
    }
    
    /**
    * Method name  : initiateCancelScenarios
    * Description  : This method is used for calling 
    *                all cancel related scenarios
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign>
    **/  
   
    public void initiateCancelScenarios(List<Campaign> listOldCampaign, 
    List<Campaign> lstNewCampaign, Map<Id, Campaign> mapNewCampaign, 
    Map<Id, Campaign> mapOldCampaign)
    { 
        if(Trigger_Methods_Activation__c.getInstance('createCampaignUserList').
        Is_Trigger_Method_Required_In_Update__c)
        helperReference.createCampaignUserList(lstNewCampaign, 
        System.Label.DMLType_Update);
        
        if(Trigger_Methods_Activation__c.getInstance('calculateGoalsInUpdateScenario').
        Is_Trigger_Method_Required_In_Update__c)
        helperReference.calculateGoalsInUpdateScenario(listOldCampaign,
        lstNewCampaign,mapNewCampaign, mapOldCampaign); 
        //for Goals Rollup Scenario sending new and 
        //old list to CampaignTriggerHandler class
        
        
    }
    
    /**
    * Method name  : setEventLocationOwnerFuture
    * Description  : This method is called from the change Event Location Owner 
    *                   as same as Event Owner on creation
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign>
    **/  
   
    public static void setEventLocationOwner(Map<Id,Campaign> lstEventLocation)
    { 
        CampaignTriggerHelper.setEventLocationOwnerFuture(lstEventLocation.keyset());
    }
    
    
    
    /**
    * Method name  : handleRecordFilteringCriteriaOnBeforeUpdate
    * Description  : This method is called from the Trigger to handle all the 
    *                filtering criteria on the data present in the records
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign>
    **/  

    //This method is called from the Trigger to handle all the filtering criteria
    //on the data present in the records
    public void handleRecordFilteringCriteriaOnBeforeUpdate(
    List<Campaign> lstNewCampaigns,
    List<Campaign> lstOldCampaigns, Map<Id, Campaign> mapCampaigns)
    {
        
            if(Trigger_Methods_Activation__c.getInstance
            ('CheckValidationOnEventLocation').
            Is_Trigger_Method_Required_In_Update__c)
                helperReference.CheckValidationOnEventLocation(lstNewCampaigns,
                true,mapCampaigns); 
                //before update for EventLocation Validations scenario 
                //sending list to CampaignTriggerHandler class
            
        
        if(Trigger_Methods_Activation__c.getInstance('autopopulatePublishedVC').
        Is_Trigger_Method_Required_In_Update__c)
        {
            helperReference.autopopulatePublishedVolunteerCoordinator(
            lstNewCampaigns,lstOldCampaigns);
        }
    }
    /**
    * Method name  : assignRMManagerScenario
    * Description  : This method is used for assigning Relationship Manager 
    *                Manager
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign>
    **/  
    //This method is used for assigning Relationship Manager Manager
    public void assignRMManagerScenario(List<Campaign> lstNewCampaigns, 
    List<Campaign> lstOldCampaigns)
    {
            if(Trigger_Methods_Activation__c.getInstance
            ('assignRelationshipManager').
            Is_Trigger_Method_Required_In_Update__c)
            
                helperReference.assignRelationshipManager(lstOldCampaigns, 
                lstNewCampaigns); 
                //before update for assigning RM Manager scenario sending old 
                //and new list to CampaignTriggerHandler class
        
    }
    /**
    * Method name  : performPostInsertOperations
    * Description  : This method is used for filtering and performing Business 
    *                processes on After Insert Scenario
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,Map<Id,Campaign>
    **/  
    //This method is used for filtering and performing Business processes
    //on After Insert Scenario
    public void performPostInsertOperations(List<Campaign> lstNewCampaign, 
    Map<Id,Campaign> mapNewCampaign)
    {        
            //handling after insert scenarios      
            
            if(Trigger_Methods_Activation__c.getInstance
            ('goalsAssignmentOnInsert').
            Is_Trigger_Method_Required_In_Insert__c)
                helperReference.goalsAssignmentOnInsert
                (lstNewCampaign,mapNewCampaign);
            
            if(Trigger_Methods_Activation__c.getInstance('shareUnshareCampaign').
            Is_Trigger_Method_Required_In_Insert__c)
                helperReference.shareUnshareCampaign(mapNewCampaign, null, 
                lstNewCampaign, false);
        
        if(Trigger_Methods_Activation__c.getInstance('createCampaignUserList').
        Is_Trigger_Method_Required_In_Insert__c)
            helperReference.createCampaignUserList(lstNewCampaign, 
            System.Label.DMLType_Insert);
    }
    
    
    /**
    * Method name  : performPostUpdateOperations
    * Description  : This method is used for filtering and performing Business 
    *                processes on After Update Scenario
    * Return Type  : void
    * Parameter    : List<Campaign>,List<Campaign> ,Map<Id,Campaign>,Map<Id,Campaign>
    **/  
    //This method is used for filtering and performing Business processes 
    //on After Update Scenario
    public void performPostUpdateOperations(List<Campaign> listOldCampaign,
    List<Campaign> lstNewCampaign, Map<Id,Campaign> mapNewCampaign, 
    Map<Id,Campaign> mapOldCampaign)
    {
        //handling after Update scenarios
     
        if(Trigger_Methods_Activation__c.getInstance('calculateGoalsInUpdateScenario').
        Is_Trigger_Method_Required_In_Update__c)
        helperReference.calculateGoalsInUpdateScenario
        (listOldCampaign,lstNewCampaign, 
        mapNewCampaign, mapOldCampaign); 
        //for Goals Rollup Scenario sending new and
        //old list to CampaignTriggerHandler class
        
        if(Trigger_Methods_Activation__c.getInstance('createCampaignUserList').
        Is_Trigger_Method_Required_In_Update__c)
        helperReference.createCampaignUserList(lstNewCampaign,
        System.Label.DMLType_Update);
        
       
            if(Trigger_Methods_Activation__c.getInstance
            ('trackGoalsAtValidationRule').
            Is_Trigger_Method_Required_In_Update__c)
            helperReference.trackGoalsAtValidationRule(mapOldCampaign, 
            mapNewCampaign); 
            /*
            if(Trigger_Methods_Activation__c.getInstance
            ('trackGoalsAtValidationRule').
            Is_Trigger_Method_Required_In_Update__c)
            helperReference.trackGoalsAtValidationRule(listOldCampaign, 
            lstNewCampaign); 
            */
            //after update for track Goals At Validation Scenario sending new 
            //and old list to CampaignTriggerHandler class
            //Oct-2015 Shanu- Changes made for COR0001497
            if(Trigger_Methods_Activation__c.getInstance
            ('trackInfluencersAtValidationRule').
            Is_Trigger_Method_Required_In_Update__c)
            helperReference.trackInfluencersAtValidationRule(mapOldCampaign, 
            mapNewCampaign); 
            //after update for track Influencers At Validation Scenario sending new 
            //and old list to CampaignTriggerHandler class
                       
            if(Trigger_Methods_Activation__c.getInstance('shareUnshareCampaign').
            Is_Trigger_Method_Required_In_Update__c)
            helperReference.shareUnshareCampaign(mapNewCampaign,mapOldCampaign,
            lstNewCampaign,true);
            
            if(Trigger_Methods_Activation__c.getInstance
            ('calculateRollUpForRateCalculation').
            Is_Trigger_Method_Required_In_Update__c)
            helperReference.calculateRollUpForRateCalculation
            (listOldCampaign, lstNewCampaign);
       
        
    }
    /**
    * Method name  : performAllDeleteOperations
    * Description  : This method is used for handling all post delete operations 
    *                and changes required in Goals calculation scenario
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,Map<Id,Campaign>
    **/ 
    //This method is used for filtering and performing all Post Delete
    //  business operations
    //This method is used for handling all post delete operations and
    //changes required in Goals calculation scenario
    public void performAllDeleteOperations(List<Campaign> lstOldCampaign, 
    Map<Id, Campaign> mapOldCampaign)
    {
        if(Trigger_Methods_Activation__c.getInstance
        ('calculateRollUpForRateCalculation').
        Is_Trigger_Method_Required_In_Delete__c)
        helperReference.calculateRollUpForRateCalculation(lstOldCampaign, null);
        
        if(Trigger_Methods_Activation__c.getInstance
        ('performPostDeleteOperations').
        Is_Trigger_Method_Required_In_Delete__c)
        helperReference.performPostDeleteOperations(mapOldCampaign);
    } 
    
  
    /* Method name  : assignEstimatedVolunteersNeeded
    * Description  : This method is used for assigning Estimated Volunteer 
    *                Needed based on the Table present in Custom Settings
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>
    **/ 
    
    //This method is used for assigning Estimated Volunteer Needed based on the 
    //Table present in Custom Settings
    public void assignEstimatedVolunteersNeeded(List<Campaign> lstEventLocation)
    {        
            if(Trigger_Methods_Activation__c.getInstance('assignEstimatedVolunteerNeed').
        Is_Trigger_Method_Required_In_Insert__c || Trigger_Methods_Activation__c.getInstance('assignEstimatedVolunteerNeed').
        Is_Trigger_Method_Required_In_Update__c)
            helperReference.assignEstimatedVolunteerNeed(lstEventLocation);
       
    }
    /**
    * Method name  : updateDateTime
    * Description  : This method is used to update fields with Date and time 
    *                of Event and Event Location
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>
    **/ 
    public void updateDateTime(List<Campaign> lstEventLocation)
    {
        List<Campaign> lstNewData = new List<Campaign>();  
        Id recordTypeId=Utility.getRecordType(System.Label.EventLocationName, 
        System.Label.DeliverableRecordType_Campaign);      
        for(Campaign oCampaignVar: lstEventLocation)
        {
            if(oCampaignVar.recordtypeId==recordTypeId && 
            oCampaignVar.Status <> System.Label.Cancelled && 
            oCampaignVar.Status <> System.Label.Status_Event_Lost && 
            oCampaignVar.Status <> System.Label.CampaignStatus_Event_Location) 
            // Checking campaign records for status Cancelled,
            //Event Lost,Location Lost before update
            {
                lstNewData.add(oCampaignVar);
            }
        }
        
        if(lstNewData.size() >0)
        {        
            EventLocationValidatorHelper.updateDateTime(lstEventLocation);
        }
    } 
    /**
    * Method name  : updateVolunteerCoordinatorLookup
    * Description  : This method is used to update fields with Date and time
    *                of Event and Event Location
    *                
    * Return Type  : void
    * Parameter    : List<Campaign>,Map<Id,Campaign>,Map<Id,Campaign>
    **/ 
    /* commented as - 7/28/2015 : not used !! 
    public void updateVolunteerCoordinatorLookup(
    List<Campaign> lstNewEventLocation,
    Map<Id,Campaign> mapOldEventLocation,Map<Id,Campaign> mapNewEventLocation){

        Map<String,Campaign> mapVCNameEventLocationId=new Map<String,Campaign>();
        Id recordtypeId=Utility.getRecordtype(System.Label.EventLocationName, 
        System.Label.DeliverableRecordType_Campaign);
        
        for(Campaign oCampaignVar: lstNewEventLocation){
            
            if(mapOldEventLocation==null){      
                
                if((recordtypeId==oCampaignVar.recordtypeId)&&
                (oCampaignVar.Published_Volunteer_Coordinator_Name__c!=null)){
                    
                    mapVCNameEventLocationId.put(oCampaignVar.Published_Volunteer_Coordinator_Name__c.toUpperCase(),
                    oCampaignVar); 
                } 
            }
            else{
                
                if((recordtypeId==oCampaignVar.recordtypeId)&&
                (oCampaignVar.Published_Volunteer_Coordinator_Name__c!=null)&&
                (mapOldEventLocation.get(oCampaignVar.Id).
                Published_Volunteer_Coordinator_Name__c!=
                mapNewEventLocation.get
                (oCampaignVar.Id).Published_Volunteer_Coordinator_Name__c)){
                    
                    mapVCNameEventLocationId.put(oCampaignVar.Published_Volunteer_Coordinator_Name__c.toUpperCase(),
                    oCampaignVar); 
                }                
                
            }
            
        }
        if(mapVCNameEventLocationId.size()>0)
            EventLocationValidatorHelper.updateVolunteerCoordinatorLookup
            (mapVCNameEventLocationId);
    } 
    */
}