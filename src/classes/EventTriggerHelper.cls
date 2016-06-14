/*******************************************************************************
    Name             : EventTriggerHelper
    Description      : Trigger Helper class used to handle multiple 
                       scenario of Campaign .                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit               11/1/2014            Created
    Sumeet                 02/02/2015           Modified for code optimization 
                                                and Track Goals at logic
    Shanu                  30/10/2015           Changes made for INC0068714                                                                
    ***************************************************************************/
    public without sharing class EventTriggerHelper
    {
    public static integer iRecursiveCheck = 0;
    public static integer iRecursiveCheckGoalsTrapId = 0;  
    public static integer iRecursiveCheckVolunteerCoordinator = 0;
    private Map<Id, DeliverableBasedTaskList__c> mapSettingsId = new Map<Id, DeliverableBasedTaskList__c>([select id from DeliverableBasedTaskList__c where Type_Values__c like '%Cancelled%']);
    String sErrorMsg;
    public string sAllErrorMsg;        
    
    private Id eventRecordTypeId;
    private Id eventLocationRecordTypeId;   
    private Id CampaignRecordTypeId;        
    private Id ProgramRecordTypeId; 
    
    
    private void identifyRecordTypes()
    {
        Schema.DescribeSObjectResult describeSchemaOfCampaign = 
        Schema.SObjectType.Campaign; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = 
        describeSchemaOfCampaign.getRecordTypeInfosById();
        
        Map<String,Schema.RecordTypeInfo> rtMapByName = 
        describeSchemaOfCampaign.getRecordTypeInfosByName();
        
        eventRecordTypeId = rtMapByName.get('Event').getRecordTypeId();
        eventLocationRecordTypeId = 
        rtMapByName.get(System.Label.Recordtype_EventLocation).getRecordTypeId(); 
        CampaignRecordTypeId = rtMapByName.get('Campaign').getRecordTypeId();      
        ProgramRecordTypeId = rtMapByName.get('Program').getRecordTypeId();
    } 
    
    //Defining the constructor
    public EventTriggerHelper()
    {
        identifyRecordTypes();
    }
    
    //Gets Goals record from Goals trigger after Goals insertion/Update/Deletion
    //and sends ids of Event/Campaign to 
    //RollUpRelatedGoalsEvent function for Goals rollup upto 
    //Event/Campaign level, and sends ids of Event Location to 
    //RollUpRelatedGoalsEventLocation 
    //function for Goals rollup upto Event Location level then to Event level.
    public void GoalsIDTrap(List<Goals__c> lstGoals,
    boolean bIsDeleted,set<id> setCampainId)
    { 
        iRecursiveCheckGoalsTrapId++ ;   
        list<id> parentCampaignRelatedToGoalsId = new List<id>();
        list<id> campaignsAllRecordTypeId = new List<id>();
        list<campaign> lstEventLocations = new list<Campaign>();
        list<id> eventLocationsId = new List<id>();
        list<campaign> lstEvents = new list<Campaign>();
        list<id> eventsId = new List<id>();
        list<id> topLevelParentCampaignId = new List<id>();

        List<Campaign> lstCampaignEventGoalsRollup = new List<Campaign>();
        List<Campaign> lstCampaignEventLocationGoalsRollup = 
        new List<Campaign>(); 
       

        if(!setCampainId.isEmpty()){
        list<campaign> lstCampaigns = [select id,  recordtypeid ,
        Event__r.id from campaign where id in: setCampainId];
        for(Campaign oCampaignVar :lstCampaigns){
            if(oCampaignVar.recordtypeid == eventRecordTypeId)
            {
                eventsId.add(oCampaignVar.id);
            }
            else if(oCampaignVar.recordtypeid == eventLocationRecordTypeId)
            {   
                eventsId.add(oCampaignVar.Event__r.id);
            }
            else if(oCampaignVar.recordtypeid == CampaignRecordTypeId)
            {                
                eventsId.add(oCampaignVar.id);
            }
        }
        
        list<campaign> lstEventsCheck =[select id,Track_goals_at__c,
        recordtypeid from Campaign where id in: eventsId];

        for(Campaign oCampaignVar:lstEventsCheck){
            if(oCampaignVar.Track_goals_at__c==System.Label.Recordtype_Event){
                lstCampaignEventGoalsRollup.add(oCampaignVar);
            }
            else if(oCampaignVar.Track_goals_at__c==
            System.Label.Recordtype_EventLocation){
                lstCampaignEventLocationGoalsRollup.add(oCampaignVar);
                
            }
            else if(oCampaignVar.recordtypeid == CampaignRecordTypeId){
                lstCampaignEventGoalsRollup.add(oCampaignVar);
            } 
        }

        if(!lstCampaignEventGoalsRollup.isEmpty())
        {   
       
            RollUpRelatedGoalsEvent(lstCampaignEventGoalsRollup);        
        }
        if(!lstCampaignEventLocationGoalsRollup.isEmpty())
        {    
            RollUpRelatedGoalsEventLocation(lstCampaignEventLocationGoalsRollup);
        }  
        }     
        
    }    
    
    //Performs Rollup on Event/Campaign records from goals records after
    //insertion, update, deletion.
    public void RollUpRelatedGoalsEvent(List<Campaign> lstNewEvents)
    {    
        List<Id> lstEventsId = new List<Id>();
        
        List<Campaign> lstEvents = new List<Campaign>();
        
        List<Campaign> lstEventUpdates = new List<Campaign>();
        
        List<Id> lstEventLocationId = new List<Id>();
        
        Double dEstimatedSponsorshipsSum = 0;
        Double dEstimatedRevenueSum = 0;
        Double dEstimatedContinuitySum = 0;
        Double dEstimatedParticipationSum = 0;    
     
        Double dCDSPLifeTimeRevenue = 0;
        Double dCDSPLifeTimeCostnTargetNumberSum = 0;
        Double dCDSPLifeTimeCost = 0;
    
        Double dContinuityLifeTimeRevenue = 0;
        Double dContinuityLifeTimeCostnTargetNumberSum = 0;
        Double dContinuityLifeTimeCost = 0;
        
        for(Campaign oCampaignVar: lstNewEvents)
        {
            if(oCampaignVar.Track_goals_at__c == System.Label.Recordtype_Event&&
            oCampaignVar.recordtypeid == eventRecordTypeId)
            {              
                lstEventsId.add(oCampaignVar.id); 
                lstEvents.add(oCampaignVar);
              
            }   
            else if(oCampaignVar.recordtypeid == CampaignRecordTypeId)
            {      
                lstEventsId.add(oCampaignVar.id);  
                lstEvents.add(oCampaignVar);                            
            }
        }
        
        list<Campaign> lstCampaigns = [select id,Estimated_Sponsorships__c,
        Estimated_Revenue__c , Estimated_Continuity__c,Actual_Continuity__c,
        Actual_Sponsorships__c ,Actual_Revenue__c,Estimated_Impact__c,
        Total_Estimated_Revenue__c,Total_Actual_revenue__c , 
        Actual_Sponsorships_On_FCD__c, Actual_Revenue_On_FCD__c ,
        Actual_Impact__c, Actual_Impact_On_FCD__c ,
        Actual_Continuity_On_FCD__c, Status, Total_Cost__c, 
        Total_Expense_ROI__c from Campaign where id in :lstEventsId ];  
        list<Goals__c> Goals = [select Target_Number__c,
        Revenue_Target__c, CIV_ID__c, Rate__c, Product__c, Funds__c,Status__c,
        Lifetime_Revenue__c, Lifetime_Cost__c  from Goals__c 
        where Campaign__r.id in :lstEventsId and 
        (Status__c != :System.Label.CampaignStatus_Cancelled and 
        Status__c != :System.Label.Goal_Status)];
       
        
        for(Goals__c oGoalsVar: Goals){
            
            if(oGoalsVar.status__c != System.Label.CampaignStatus_Cancelled &&
            oGoalsVar.status__c != System.Label.Goal_Status  ){ 
                if(oGoalsVar.Product__c == System.Label.GoalsProduct_CDSP )
                {
                    if( oGoalsVar.Target_Number__c != null)
                    {
                        dEstimatedSponsorshipsSum = dEstimatedSponsorshipsSum + 
                        Double.valueof(oGoalsVar.Target_Number__c);
                    }
                    Double dValue = 0;
                    if(oGoalsVar.Target_Number__c != null && 
                    oGoalsVar.Lifetime_Revenue__c != null)
                    {
                        dValue =  Double.valueof(oGoalsVar.Target_Number__c)*
                        Double.valueof(oGoalsVar.Lifetime_Revenue__c);
                    }
                    
                    if( oGoalsVar.Lifetime_Revenue__c != null)
                    {
                     
                        dCDSPLifeTimeRevenue = 
                        Double.valueof(oGoalsVar.Lifetime_Revenue__c);                      
                    }
                       if( oGoalsVar.Lifetime_Cost__c != null)
                        {
                          
                            dCDSPLifeTimeCost = Double.valueof
                            (oGoalsVar.Lifetime_Cost__c );
                        }
                     if( oGoalsVar.Lifetime_Cost__c != null && 
                     oGoalsVar.Target_Number__c != null)
                    {
                      
                        dCDSPLifeTimeCostnTargetNumberSum = 
                        dCDSPLifeTimeCostnTargetNumberSum +
                        Double.valueof(oGoalsVar.Lifetime_Cost__c)*
                        Double.valueof(oGoalsVar.Target_Number__c);                        
                    }
                }    
                
                //Shanu- Oct 2015 Changes made for INC0068714
                if(oGoalsVar.Product__c == System.Label.GoalsProduct_CIV 
                || oGoalsVar.Product__c == System.Label.GoalsProduct_FundDesignation)
                {
                    if( oGoalsVar.Revenue_Target__c!= null)
                    { 
                        dEstimatedRevenueSum = dEstimatedRevenueSum +
                        Double.valueof(oGoalsVar.Revenue_Target__c);    
                    }       
                }
                
                if(oGoalsVar.Product__c == System.Label.GoalsProduct_Continuity)
                {
                    if( oGoalsVar.Target_Number__c != null)
                    {
                        dEstimatedContinuitySum = dEstimatedContinuitySum + 
                        Double.valueof(oGoalsVar.Target_Number__c);
                    }
                    if(oGoalsVar.Lifetime_Revenue__c != null)
                    {
                     
                        dContinuityLifeTimeRevenue = Double.valueof
                        (oGoalsVar.Lifetime_Revenue__c);
                    }
                     if( oGoalsVar.Lifetime_Cost__c != null && 
                     oGoalsVar.Target_Number__c != null)
                    {
                       dContinuityLifeTimeCostnTargetNumberSum = 
                       dContinuityLifeTimeCostnTargetNumberSum +
                       Double.valueof(oGoalsVar.Lifetime_Cost__c)*
                       Double.valueof(oGoalsVar.Target_Number__c);                     
                    }
                     if( oGoalsVar.Lifetime_Cost__c != null )
                    {
                      
                       dContinuityLifeTimeCost =
                       Double.valueof(oGoalsVar.Lifetime_Cost__c);            
                    }
                }
                
                if(oGoalsVar.Product__c == System.Label.GoalsProduct_Number  && 
                oGoalsVar.Target_Number__c != null)
                {
                    dEstimatedParticipationSum = dEstimatedParticipationSum + 
                    Double.valueof(oGoalsVar.Target_Number__c);
                }       
            }
        }  
        if(lstCampaigns.size() == 1) 
        {
            for(Campaign oCampaignVar: lstCampaigns){
                
                oCampaignVar.Estimated_Sponsorships__c = 
                dEstimatedSponsorshipsSum  ;
                
                oCampaignVar.Estimated_Revenue__c = dEstimatedRevenueSum;
                
                oCampaignVar.Estimated_Continuity__c = dEstimatedContinuitySum ;
                
                oCampaignVar.Estimated_Impact__c = dEstimatedParticipationSum ;                  
                
                //Total_Estimated_Revenue__c n 
                //Total_Actual_revenue__c calc starts 
                if(oCampaignVar.Estimated_Sponsorships__c == null)
                {
                    oCampaignVar.Estimated_Sponsorships__c = 0;
                }
                if(oCampaignVar.Estimated_Continuity__c == null)
                {
                    oCampaignVar.Estimated_Continuity__c = 0;
                }
                
               
                if(oCampaignVar.Estimated_Sponsorships__c != null &&
                oCampaignVar.Estimated_Continuity__c != null )
                {Double dContinuity = 0;
                 Double dCDSP = 0;
                 dContinuity = dContinuityLifeTimeRevenue*Double.valueof
                 (oCampaignVar.Estimated_Continuity__c);
                dCDSP = dCDSPLifeTimeRevenue*Double.valueof
                (oCampaignVar.Estimated_Sponsorships__c);
                
                    oCampaignVar.Total_Estimated_Revenue__c = 
                    dContinuity + dCDSP + dEstimatedRevenueSum;                 
                } 
              
                        
                              
                    oCampaignVar.Total_Cost__c = 
                    dContinuityLifeTimeCostnTargetNumberSum + 
                    dCDSPLifeTimeCostnTargetNumberSum;               
             
                 if( oCampaignVar.Actual_Sponsorships__c!= null &&
                 oCampaignVar.Actual_Continuity__c != null) //oCampaignVar.Total_Expense__c!= null
                {                  
                    oCampaignVar.Total_Expense_ROI__c = 
                    dCDSPLifeTimeCost*Double.valueof
                    (oCampaignVar.Actual_Sponsorships__c) +
                    dContinuityLifeTimeCost*Double.valueof
                    (oCampaignVar.Actual_Continuity__c); 
                               
                }  
                
                if(oCampaignVar.Actual_Sponsorships__c == null )
                {
                    oCampaignVar.Actual_Sponsorships__c = 0;              
                }  
                if(oCampaignVar.Actual_Continuity__c == null)
                {
                    oCampaignVar.Actual_Continuity__c = 0;              
                }  
                
                if(oCampaignVar.Actual_Revenue__c == null)
                {
                    oCampaignVar.Actual_Revenue__c = 0;              
                } 
                
                if(oCampaignVar.Actual_Sponsorships__c != null && 
                oCampaignVar.Actual_Continuity__c != null && 
                oCampaignVar.Actual_Revenue__c != null)
                {
                      
                    oCampaignVar.Total_Actual_revenue__c = 
                    dCDSPLifeTimeRevenue*Double.valueof
                    (oCampaignVar.Actual_Sponsorships__c) + 
                    dContinuityLifeTimeRevenue*Double.valueof
                    (oCampaignVar.Actual_Continuity__c) +  
                    Double.valueof(oCampaignVar.Actual_Revenue__c);            
                }
                
                //----------- Total_Estimated_Revenue__c n
                //Total_Actual_revenue__c calc ends
                lstEventUpdates.add(oCampaignVar);
            }
          
            try
            {
                update lstEventUpdates;      
            }
            catch(Exception ex)
            {
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Event',String.valueOf(lstEventsId),
                'EventTriggerHelper','RollUpRelatedGoalsEvent',
                'Application',UserInfo.getUserId(), 
                String.valueOf(lstEventUpdates),null);
            }
        } 
    }    
    
    //Performs Rollup on Event Location records from goals records after 
    //insertion, updation, deletion, and then rolling up 
    //from Event Location to Event level.
    public void RollUpRelatedGoalsEventLocation(List<Campaign> lstNewEvents)
    {
        List<Id> lstEventsId = new List<Id>();

        List<Campaign> lstEvents = new List<Campaign>();

        List<Campaign> lstEventUpdates = new List<Campaign>();

        list<campaign> lstEventLocationUpdate = new list<campaign>();

        id EventRecordId;

        map<id, list<goals__c>> mapEventLocationGoals = 
        new map<id, list<goals__c>>();
        map<id, campaign> mapEventLocation = new map<id, campaign>();

        Double dEstimatedSponsorshipsSum = 0;
        Double dEstimatedRevenueSum = 0;
        Double dEstimatedContinuitySum = 0;
        Double dEstimatedParticipationSum = 0;
        Double dTotalEstimatedReveueSum = 0;
        Double dTotal_Actual_revenueSum = 0;
        Double dTotalEstimatedReveueMultiplySum = 0;
       
         Double dCDSPLifeTimeRevenue = 0;
         Double dContinuityLifeTimeRevenue = 0;
         Double dCDSPLifeTimeCostnTargetNumberSum = 0;
        Double dCDSPLifeTimeCost = 0;
        Double dContinuityLifeTimeCostnTargetNumberSum = 0;
        Double dContinuityLifeTimeCost = 0;

        Double dEstimatedSponsorshipsSumOverAll = 0;
        Double dEstimatedRevenueSumOverAll = 0;
        Double dEstimatedContinuitySumOverAll = 0;
        Double dEstimatedParticipationSumOverAll = 0;  
        Double dTotalEstimatedReveueSumOverAll = 0;
        Double dTotalActualRevenueSumOverAll = 0; 
        Double dRateTargetNumberSumOverAll = 0;
        
        Double dActualSponsorshipsSumOverAll = 0;
        Double dActualSponsorshipsOnEndDateSumOverAll = 0 ; 
        Double dActualRevenueSumOverAll = 0;
        Double dActual_RevenueOnEndDateSumOverAll = 0; 
        Double dActualImpactSumOverAll = 0;
        Double dActualImpactOnEndDateSumOverAll = 0;
        Double dActualContinuitySumOverAll = 0;
        Double dActualContinuityOnEndDateSumOverAll = 0;
        Double dTotalCostSumOverAll = 0;
        Double dTotalExpenseSumOverAll = 0;
        
        
        for(Campaign oCampaignVar: lstNewEvents)
        {
            if(oCampaignVar.Track_goals_at__c == 
            System.Label.Recordtype_EventLocation)
            {
                lstEvents.add(oCampaignVar);
                lstEventsId.add(oCampaignVar.id);  
                EventRecordId = oCampaignVar.id;              
            }            
        }
        
        list<Campaign> lstEventLocationReferences = 
        [select id,Estimated_Sponsorships__c,Estimated_Revenue__c ,
        Estimated_Continuity__c, Actual_Sponsorships__c ,Actual_Revenue__c,
        Estimated_Impact__c,Total_Estimated_Revenue__c,Total_Actual_revenue__c ,
        Actual_Sponsorships_On_FCD__c,  Actual_Revenue_On_FCD__c , 
        Actual_Impact__c, Actual_Impact_On_FCD__c , Actual_Continuity__c,
        Actual_Continuity_On_FCD__c, Total_Cost__c, Total_Expense_ROI__c,
        Status from Campaign where event__r.id in : lstEventsId ]; 
        
        list<Goals__c> Goals1 = [select Status__c,Target_Number__c,
        Revenue_Target__c, CIV_ID__c,Lifetime_Revenue__c, Lifetime_Cost__c,
        Rate__c, Product__c, Funds__c, Campaign__c,Campaign__r.event__r.id 
        from Goals__c where Campaign__r.event__r.id in: lstEventsId]; 
        
        for(Campaign oEventLocationVar :lstEventLocationReferences )
        {
            campaign eventLoactionRecordVar = oEventLocationVar;
            id eventLoactionRecordId = oEventLocationVar.id;   
            mapEventLocation.put(oEventLocationVar.id,oEventLocationVar);
            
            list<goals__c> lstGoals = new list<goals__c>();
            
            for(Goals__c oGoalsVar: Goals1)
            {
                if(oGoalsVar.campaign__r.id == oEventLocationVar.id )
                {
                    lstGoals.add(oGoalsVar);
                }                
            }
            mapEventLocationGoals.put(oEventLocationVar.id,lstGoals );
        }
        
        set<id> setEventLocationId = new set<id>();
        setEventLocationId = mapEventLocation.keyset();
        for(id is:setEventLocationId)
        {            
            list<Goals__c> lstGoals = mapEventLocationGoals.get(is);
            campaign eventLocationRecordVar = mapEventLocation.get(is);    

            for(Goals__c oGoalsVar: lstGoals)
            {
                if(oGoalsVar.status__c != System.Label.CampaignStatus_Cancelled && 
                oGoalsVar.status__c != System.Label.Goal_Status  )
                {                    
                    if(oGoalsVar.Product__c == System.Label.GoalsProduct_CDSP )
                    {
                        if( oGoalsVar.Target_Number__c != null )
                        {
                            dEstimatedSponsorshipsSum = dEstimatedSponsorshipsSum +
                            Double.valueof(oGoalsVar.Target_Number__c);
                        }
                        Double dValue = 0;
                        if( oGoalsVar.Target_Number__c != null &&
                        oGoalsVar.Lifetime_Revenue__c!= null)
                        {
                            dValue =  Double.valueof
                            (oGoalsVar.Target_Number__c)*Double.valueof
                            (oGoalsVar.Lifetime_Revenue__c);
                        } 
                        dTotalEstimatedReveueMultiplySum =
                        dTotalEstimatedReveueMultiplySum + dValue;
                        if( oGoalsVar.Lifetime_Revenue__c!= null)
                        {
                          
                            dCDSPLifeTimeRevenue = Double.valueof
                            (oGoalsVar.Lifetime_Revenue__c);
                        }
                         if( oGoalsVar.Lifetime_Cost__c != null)
                        {
                          
                            dCDSPLifeTimeCost = Double.valueof
                            (oGoalsVar.Lifetime_Cost__c );
                        }
                           if( oGoalsVar.Lifetime_Cost__c != null && 
                           oGoalsVar.Target_Number__c != null)
                        {                        
                            dCDSPLifeTimeCostnTargetNumberSum = 
                            dCDSPLifeTimeCostnTargetNumberSum + 
                            Double.valueof(oGoalsVar.Lifetime_Cost__c)*
                            Double.valueof(oGoalsVar.Target_Number__c);                        
                        }
                    }      
                    
                    //Shanu- Oct 2015 Changes made for INC0068714
                    if(oGoalsVar.Product__c == System.Label.GoalsProduct_CIV 
                    || oGoalsVar.Product__c == System.Label.GoalsProduct_FundDesignation)
                    {
                        if(oGoalsVar.Revenue_Target__c != null){
                            dEstimatedRevenueSum = dEstimatedRevenueSum + 
                            Double.valueof(oGoalsVar.Revenue_Target__c);      
                        }     
                    }
                    
                    if(oGoalsVar.Product__c == 
                    System.Label.GoalsProduct_Continuity )
                    {
                        if( oGoalsVar.Target_Number__c != null)
                        {
                            dEstimatedContinuitySum = dEstimatedContinuitySum + 
                            Double.valueof(oGoalsVar.Target_Number__c);
                        }
                        if( oGoalsVar.Lifetime_Revenue__c!= null)
                        {
                         
                           dContinuityLifeTimeRevenue = Double.valueof
                           (oGoalsVar.Lifetime_Revenue__c);
                        }
                          if( oGoalsVar.Lifetime_Cost__c != null &&
                          oGoalsVar.Target_Number__c != null)
                        {
                           dContinuityLifeTimeCostnTargetNumberSum =
                           dContinuityLifeTimeCostnTargetNumberSum + 
                           Double.valueof(oGoalsVar.Lifetime_Cost__c)*
                           Double.valueof(oGoalsVar.Target_Number__c);                     
                        }
                         if( oGoalsVar.Lifetime_Cost__c != null )
                        {
                           
                            dContinuityLifeTimeCost = Double.valueof
                            (oGoalsVar.Lifetime_Cost__c);            
                        }
                    }
                    
                    if(oGoalsVar.Product__c == 
                    System.Label.GoalsProduct_Number &&
                    oGoalsVar.Target_Number__c != null)
                    {
                        dEstimatedParticipationSum = dEstimatedParticipationSum+
                        Double.valueof(oGoalsVar.Target_Number__c);
                    }  
                }
            }  

            eventLocationRecordVar.Estimated_Sponsorships__c = 
            dEstimatedSponsorshipsSum  ;
            dEstimatedSponsorshipsSumOverAll =dEstimatedSponsorshipsSumOverAll +
            Double.valueof(eventLocationRecordVar.Estimated_Sponsorships__c);
            
            eventLocationRecordVar.Estimated_Revenue__c = dEstimatedRevenueSum;
            dEstimatedRevenueSumOverAll = dEstimatedRevenueSumOverAll + 
            Double.valueof(eventLocationRecordVar.Estimated_Revenue__c) ;
            
            eventLocationRecordVar.Estimated_Continuity__c = 
            dEstimatedContinuitySum ;
            dEstimatedContinuitySumOverAll = dEstimatedContinuitySumOverAll +
            Double.valueof(eventLocationRecordVar.Estimated_Continuity__c);
            
            eventLocationRecordVar.Estimated_Impact__c = 
            dEstimatedParticipationSum ;
            dEstimatedParticipationSumOverAll=dEstimatedParticipationSumOverAll+
            Double.valueof(eventLocationRecordVar.Estimated_Impact__c);
            
            //Total_Estimated_Revenue__c n Total_Actual_revenue__c calc starts 
            if(eventLocationRecordVar.Estimated_Sponsorships__c == null)
            {
                eventLocationRecordVar.Estimated_Sponsorships__c = 0;
            }
            if(eventLocationRecordVar.Estimated_Continuity__c == null)
            {
                eventLocationRecordVar.Estimated_Continuity__c = 0;
            }
            if(eventLocationRecordVar.Estimated_Sponsorships__c != null &&
            eventLocationRecordVar.Estimated_Continuity__c != null )
            {
                eventLocationRecordVar.Total_Estimated_Revenue__c = 
                dCDSPLifeTimeRevenue*Double.valueof
                (eventLocationRecordVar.Estimated_Sponsorships__c) + 
                dContinuityLifeTimeRevenue*Double.valueof
                (eventLocationRecordVar.Estimated_Continuity__c) + 
                dEstimatedRevenueSum; 
            } 
           
                eventLocationRecordVar.Total_Cost__c = 
                dContinuityLifeTimeCostnTargetNumberSum +
                dCDSPLifeTimeCostnTargetNumberSum; 
                
         dContinuityLifeTimeCostnTargetNumberSum = 0;
         dCDSPLifeTimeCostnTargetNumberSum = 0;
         
          if( eventLocationRecordVar.Actual_Sponsorships__c!= null && 
          eventLocationRecordVar.Actual_Continuity__c != null  )
          
            {                  
                eventLocationRecordVar.Total_Expense_ROI__c = 
                dCDSPLifeTimeCost*Double.valueof
                (eventLocationRecordVar.Actual_Sponsorships__c) +
                dContinuityLifeTimeCost*Double.valueof
                (eventLocationRecordVar.Actual_Continuity__c); 
                            
            }  
            dTotalEstimatedReveueSumOverAll = dTotalEstimatedReveueSumOverAll +
            Double.valueof(eventLocationRecordVar.Total_Estimated_Revenue__c);
            
            IF(eventLocationRecordVar.Actual_Sponsorships__c == null )
            {
                eventLocationRecordVar.Actual_Sponsorships__c = 0;              
            }
            
            IF(eventLocationRecordVar.Actual_Continuity__c == null)
            {
                eventLocationRecordVar.Actual_Continuity__c = 0;              
            }
            
            IF(eventLocationRecordVar.Actual_Revenue__c == null)
            {
                eventLocationRecordVar.Actual_Revenue__c = 0;              
            }             
            
            IF(eventLocationRecordVar.Actual_Sponsorships__c != null &&
            eventLocationRecordVar.Actual_Continuity__c != null && 
            eventLocationRecordVar.Actual_Revenue__c != null)
            {
                eventLocationRecordVar.Total_Actual_revenue__c = 
                dContinuityLifeTimeRevenue*Double.valueof
                (eventLocationRecordVar.Actual_Continuity__c) + 
                Double.valueof(eventLocationRecordVar.Actual_Revenue__c) +
                dCDSPLifeTimeRevenue*Double.valueof
                (eventLocationRecordVar.Actual_Sponsorships__c);              
            }
            
            IF(eventLocationRecordVar.Total_Actual_revenue__c != null )
            {
                dTotalActualRevenueSumOverAll = dTotalActualRevenueSumOverAll +
                Double.valueof(eventLocationRecordVar.Total_Actual_revenue__c) ;   
            }
            //Total_Estimated_Revenue__c n Total_Actual_revenue__c calc ends
            
            
            IF(eventLocationRecordVar.Actual_Sponsorships__c!= null ){
                dActualSponsorshipsSumOverAll = dActualSponsorshipsSumOverAll +
                Double.valueof(eventLocationRecordVar.Actual_Sponsorships__c);
            }
            IF(eventLocationRecordVar.Actual_Sponsorships_On_FCD__c != null ){
                dActualSponsorshipsOnEndDateSumOverAll = 
                dActualSponsorshipsOnEndDateSumOverAll + 
                Double.valueof
                (eventLocationRecordVar.Actual_Sponsorships_On_FCD__c) ; 
            }
            IF(eventLocationRecordVar.Actual_Revenue__c!= null ){
                dActualRevenueSumOverAll = dActualRevenueSumOverAll + 
                Double.valueof(eventLocationRecordVar.Actual_Revenue__c);
            }
            IF(eventLocationRecordVar.Actual_Revenue_On_FCD__c!= null ){
                dActual_RevenueOnEndDateSumOverAll = 
                dActual_RevenueOnEndDateSumOverAll + Double.valueof
                (eventLocationRecordVar.Actual_Revenue_On_FCD__c); 
            }
            IF(eventLocationRecordVar.Actual_Impact__c!= null ){
                dActualImpactSumOverAll = dActualImpactSumOverAll + 
                Double.valueof(eventLocationRecordVar.Actual_Impact__c);
            }
            IF(eventLocationRecordVar.Actual_Impact_On_FCD__c!= null ){
                dActualImpactOnEndDateSumOverAll = 
                dActualImpactOnEndDateSumOverAll + 
                Double.valueof(eventLocationRecordVar.Actual_Impact_On_FCD__c);
            }
            IF(eventLocationRecordVar.Actual_Continuity__c!= null ){
                dActualContinuitySumOverAll =  
                dActualContinuitySumOverAll + 
                Double.valueof(eventLocationRecordVar.Actual_Continuity__c);
            }
            IF(eventLocationRecordVar.Actual_Continuity_On_FCD__c!= null ){
                dActualContinuityOnEndDateSumOverAll = 
                dActualContinuityOnEndDateSumOverAll + 
                Double.valueof(eventLocationRecordVar.Actual_Continuity_On_FCD__c);     
            }
            IF(eventLocationRecordVar.Total_Cost__c!= null ){
                dTotalCostSumOverAll = 
                dTotalCostSumOverAll + 
                Double.valueof(eventLocationRecordVar.Total_Cost__c);     
            }
            IF(eventLocationRecordVar.Total_Expense_ROI__c != null ){
                dTotalExpenseSumOverAll = dTotalExpenseSumOverAll + 
                Double.valueof(eventLocationRecordVar.Total_Expense_ROI__c);     
            }
            
            lstEventLocationUpdate.add(eventLocationRecordVar) ;    
            
            dEstimatedSponsorshipsSum = 0;
            dEstimatedRevenueSum = 0;
            dEstimatedContinuitySum = 0;
            dEstimatedParticipationSum = 0;
            
        }
        
        try
        {
            update lstEventLocationUpdate;
        }
        catch(Exception ex)
        {
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'Event Location',
            String.valueOf(setEventLocationId),
            'EventTriggerHelper','RollUpRelatedGoalsEventLocation',
            'Application',UserInfo.getUserId(),
            String.valueOf(lstEventLocationUpdate),null);
        }
        
        Campaign finalCampaignRecordVar = [select id,Estimated_Sponsorships__c,
        Estimated_Revenue__c , Estimated_Continuity__c, 
        Actual_Sponsorships__c ,Actual_Revenue__c,Estimated_Impact__c,
        Total_Estimated_Revenue__c,Total_Actual_revenue__c , 
        Actual_Sponsorships_On_FCD__c, Actual_Revenue_On_FCD__c , 
        Actual_Impact__c, Actual_Impact_On_FCD__c ,
        Actual_Continuity__c, Actual_Continuity_On_FCD__c,
        Total_Cost__c, Total_Expense_ROI__c,
        Status from Campaign where campaign.id =:EventRecordId and 
        RecordTypeId =: eventRecordTypeId ]; 
        
        finalCampaignRecordVar.Estimated_Sponsorships__c = 
        dEstimatedSponsorshipsSumOverAll ;
        finalCampaignRecordVar.Estimated_Revenue__c = 
        dEstimatedRevenueSumOverAll;
        finalCampaignRecordVar.Estimated_Continuity__c = 
        dEstimatedContinuitySumOverAll ;
        finalCampaignRecordVar.Estimated_Impact__c = 
        dEstimatedParticipationSumOverAll ;
        finalCampaignRecordVar.Total_Estimated_Revenue__c = 
        dTotalEstimatedReveueSumOverAll;
        finalCampaignRecordVar.Total_Actual_revenue__c = 
        dTotalActualRevenueSumOverAll ;
        
        finalCampaignRecordVar.Actual_Sponsorships__c = 
        dActualSponsorshipsSumOverAll;
        finalCampaignRecordVar.Actual_Sponsorships_On_FCD__c =
        dActualSponsorshipsOnEndDateSumOverAll;
        finalCampaignRecordVar.Actual_Revenue__c = 
        dActualRevenueSumOverAll;
        finalCampaignRecordVar.Actual_Revenue_On_FCD__c = 
        dActual_RevenueOnEndDateSumOverAll; 
        finalCampaignRecordVar.Actual_Impact__c = 
        dActualImpactSumOverAll;
        finalCampaignRecordVar.Actual_Impact_On_FCD__c = 
        dActualImpactOnEndDateSumOverAll;
        finalCampaignRecordVar.Actual_Continuity__c =
        dActualContinuitySumOverAll;
        finalCampaignRecordVar.Actual_Continuity_On_FCD__c = 
        dActualContinuityOnEndDateSumOverAll;
         finalCampaignRecordVar.Total_Cost__c = 
         dTotalCostSumOverAll;
          finalCampaignRecordVar.Total_Expense_ROI__c = 
          dTotalExpenseSumOverAll;
        
        try
        {
            update finalCampaignRecordVar;
        }
        catch(Exception ex)
        {
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'Campaign',
            String.valueOf(EventRecordId),'EventTriggerHelper',
            'RollUpRelatedGoalsEventLocation','Application',
            UserInfo.getUserId(), String.valueOf(finalCampaignRecordVar),null);
        }
    }


    // Cancels all records subsequent to Event/Campaign record when Event or Campaign record is Cancelled.
    public void closeRelatedEvents(List<Campaign> lstNewEvents)
    {    
        Utility.bDeliverableStopCancel=true;
        Utility.bVShiftStopCancel=true;
        Utility.bVSlotStopCancel=true;
        List<Campaign> lstEventLocations = new List<Campaign>();
        List<Id> eventLocationsId = new List<Id>();
        
        List<Campaign> lstEventsWithIsPublishToWeb = new List<Campaign>();
        List<Id> lstEventsWithIsPublishToWebId = new List<Id>();    
        List<Campaign> lstEventLocationIsPublishToWeb = new List<Campaign>();
        
        List<Id> lstEventsId = new List<Id>();       
        List<Campaign> lstEvents = new List<Campaign>();
        
        List<Id> lstCompassionContactEventIds = new List<Id>();   
        List<Campaign> lstCompassionContactEvents = new List<Campaign>();   
        
        List<Id> lstDeliverableIds = new List<Id>();
        
        for(Campaign oCampaignVar: lstNewEvents)
        {
            if(oCampaignVar.RecordTypeId == eventLocationRecordTypeId &&
            ( oCampaignVar.Status == System.Label.CampaignStatus_Cancelled ||
            oCampaignVar.Status == System.Label.CampaignStatus_Event_Location) )
            {
                lstEventLocations.add(oCampaignVar);
                eventLocationsId.add(oCampaignVar.id);
            }
            else if(oCampaignVar.RecordTypeId == eventRecordTypeId &&
            (oCampaignVar.Status == System.Label.CampaignStatus_Cancelled ||
            oCampaignVar.Status == System.Label.Status_Event_Lost))
            {
                lstEvents.add(oCampaignVar);
                lstEventsId.add(oCampaignVar.Id); 
            }
            else if(oCampaignVar.Publish_to_Web__c == true && 
            oCampaignVar.RecordTypeId == eventRecordTypeId)
            {
                lstEventsWithIsPublishToWeb.add(oCampaignVar);
                lstEventsWithIsPublishToWebId.add(oCampaignVar.Id);
            }
            else if(oCampaignVar.RecordTypeId == CampaignRecordTypeId && 
            oCampaignVar.Status == System.Label.CampaignStatus_Cancelled)
            {
                lstEvents.add(oCampaignVar);
                lstEventsId.add(oCampaignVar.Id);
            }
        }
        
        if(!lstEventsId.isEmpty() || !lstEventsWithIsPublishToWebId.isEmpty())
        { 
            /* ------- event location logic starts--------------*/
            List<Campaign> lstNewEventLocations = new List<Campaign>();
            list<Campaign> lstCampaigns = [select id, Status,
            Cancellation_Reason__c from Campaign where
            (Event__r.id in :lstEventsId or id in :lstEventsId) and
            recordtypeid =: eventLocationRecordTypeId];
            List<goals__c> lstUpadateGoals = new List<goals__c>();
            string sCancelReason = '' ;
            if( lstEvents.size() > 0 ){             
                sCancelReason = lstEvents[0].Cancellation_Reason__c;
            }
            for(Campaign oCampaignVar : lstCampaigns)
            { 
                eventLocationsId.add(oCampaignVar.id);                
                oCampaignVar.Status = System.Label.CampaignStatus_Cancelled;
                oCampaignVar.Cancellation_Reason__c = sCancelReason ;
               
                lstNewEventLocations.add(oCampaignVar);
            } 
        
            try
            {
                update lstNewEventLocations; 
                iRecursiveCheckVolunteerCoordinator++;
            }
            catch(Exception ex)
            {
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Event Location',
                String.valueOf(lstEventsWithIsPublishToWebId),
                'EventTriggerHelper','closeRelatedEvents',
                'Application',UserInfo.getUserId(),
                String.valueOf(lstNewEventLocations),null);
            }              
            
            /* ------- event location logic ends --------------------- */   
            
            /*   --------------- goals logic start ---------------- */
            
            
            List<goals__c> lstGoals = [select id , status__c from Goals__c 
            where Campaign__r.id in : lstEventsId];
            for(goals__c oGoalsVar : lstGoals)
            {                
                oGoalsVar.status__c = System.Label.CampaignStatus_Cancelled;            
                lstUpadateGoals.add(oGoalsVar);                
            } 
            
            if(!lstUpadateGoals.isEmpty())
            {
                iRecursiveCheck ++ ;
                try
                {
                    update lstUpadateGoals;
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'Goals',
                    String.valueOf(lstEventsId),
                    'EventTriggerHelper','closeRelatedEvents',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstUpadateGoals),null);
                }
            }
            /*   --------------- goals logic end ---------------- */
            
            /* ------- listDeliverableIds logic starts----------------------- */
            List<Deliverable__c> lstDeliverable = new List<Deliverable__c>();
            
            list<Deliverable__c> lstDeliverableReference = [select id, 
            Status__c from Deliverable__c 
            where campaign__r.id in :lstEventsId or 
            Event__r.id in :lstEventsId];
            for(Deliverable__c oDeliverableVar : lstDeliverableReference)
            {   
                oDeliverableVar.Status__c=System.Label.CampaignStatus_Cancelled;
                lstDeliverable.add(oDeliverableVar);
            }
            
            if(!lstDeliverable.isEmpty())
            {
                try
                {
                    update lstDeliverable;                   
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'Deliverable',
                    String.valueOf(lstEventsId),'EventTriggerHelper',
                    'closeRelatedEvents','Application',UserInfo.getUserId(), 
                    String.valueOf(lstDeliverable),null);
                }
            }              
            /* ------- listDeliverableIds logic ends ----------------------- */     
            
            /* ------- Activities logic starts----------------------------- */
            List<task> lstTasks = new List<task>();
            
          
            list<task> lstTaskReference = [select id, 
            Status, Custom_Settings_Linkage__c from task where whatid in: lstEventsId and Status <> 'Completed'];
            for(task oTaskVar : lstTaskReference)
            {
                //Apurva- Null check oTaskVar.Custom_Settings_Linkage__c <> null added for Incident INC0065448
                //if(mapSettingsId <> null && !String.valueOf(mapSettingsId.keyset()).contains(oTaskVar.Custom_Settings_Linkage__c))
                if(mapSettingsId <> null && oTaskVar.Custom_Settings_Linkage__c <> null && !String.valueOf(mapSettingsId.keyset()).contains(oTaskVar.Custom_Settings_Linkage__c))
                {
                    oTaskVar.Status = System.Label.CampaignStatus_Cancelled;
                    lstTasks.add(oTaskVar);
                }
            }
            if(!lstTasks.isEmpty())
            {
                try
                {
                    update lstTasks;                   
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'Task',
                    String.valueOf(lstEventsId),'EventTriggerHelper',
                    'closeRelatedEvents','Application',UserInfo.getUserId(),
                    String.valueOf(lstTasks),null);
                }
            }               
            /* ------- Activities logic ends ------------------------------- */   
                       
            
        }  

        if(!eventLocationsId.isEmpty())
        {         
            id eventLocationId = eventLocationsId[0];
            campaign eventLocationRecordVar = [select id , 
            status from campaign where id =: eventLocationId];
            
            /*   --------------- goals logic start ---------------- */
            List<goals__c> lstUpadateGoals = new List<goals__c>();
            
            List<goals__c> lstGoals = [select id , 
            status__c from Goals__c where Campaign__r.id in : eventLocationsId];
            for(goals__c oGoalsVar : lstGoals){
                if(eventLocationRecordVar.status == 
                System.Label.CampaignStatus_Cancelled )
                {
                    oGoalsVar.status__c = System.Label.CampaignStatus_Cancelled; 
                }
                else if(eventLocationRecordVar.status == 
                System.Label.CampaignStatus_Event_Location )
                {
                    oGoalsVar.status__c = System.Label.Goal_Status;
                }   
                lstUpadateGoals.add(oGoalsVar);                
            } 
            if(!lstUpadateGoals.isEmpty())
            { 
                iRecursiveCheck++;
                try
                {
                    update lstUpadateGoals;
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'Goals',
                    String.valueOf(eventLocationsId),'EventTriggerHelper',
                    'closeRelatedEvents','Application',
                    UserInfo.getUserId(), String.valueOf(lstUpadateGoals),null);
                }
                
            }
            /*   --------------- goals logic end ---------------- */
            
            
            /* ------- VolunteerShift logic starts--------------------------- */
            List<Id> lstVolunteerShiftIds = new List<Id>();

            list<Volunteer_Shift__c> lstVolunteerShift = 
            [select id from Volunteer_Shift__c where 
            EventLocation__r.id in :eventLocationsId];
            for(Volunteer_Shift__c oVslot : lstVolunteerShift)
            { 
                lstVolunteerShiftIds.add(oVslot.id);               
            }             

            List<Volunteer_Slot__c> lstVolunteerSlots = 
            new List<Volunteer_Slot__c>();
            list<Volunteer_Slot__c> lstNewVolunteerSlots = [select id, 
            Status__c from Volunteer_Slot__c where
            Volunteer_Shift__r.id in :lstVolunteerShiftIds ];
            for(Volunteer_Slot__c oVolunteerSlotVar : lstNewVolunteerSlots)
            { 
                if(oVolunteerSlotVar.status__c == 
                System.Label.VolunteerSlotStatus || 
                oVolunteerSlotVar.status__c == 
                System.Label.VolunteerSlotStatus_Approved || 
                oVolunteerSlotVar.status__c == 
                System.Label.VolunteerSlotStatus_PendingApproval
                        || oVolunteerSlotVar.status__c == 
                        System.Label.VolunteerSlotStatus_Pending_Approval_First_Time ||
                        oVolunteerSlotVar.status__c == 
                        System.Label.VolunteerSlotStatus_Pending_Approval_Guest)
                {
                    oVolunteerSlotVar.Status__c = 'Cancelled - Event Cancelled';
                }
                lstVolunteerSlots.add(oVolunteerSlotVar);
            }
            if(!lstVolunteerSlots.isEmpty()){
                
                try
                {
                    update lstVolunteerSlots ; 
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'Volunteer Slots',
                    String.valueOf(lstVolunteerShiftIds),
                    'EventTriggerHelper','closeRelatedEvents',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstVolunteerSlots),null);
                }
            }   
            /* ------- VolunteerShift logic ends--------------------- */
            
            /* ------- Activities logic starts---------------------------- */
            List<task> lstTasks = new List<task>();
            list<task> lstTaskReference = [select id,
            Status, Custom_Settings_Linkage__c from task where  whatid in :eventLocationsId and Status <> 'Completed'];
            for(task oTaskVar : lstTaskReference)
            {
                //Apurva- Null check oTaskVar.Custom_Settings_Linkage__c <> null added for Incident INC0065448
                //if(mapSettingsId <> null && !String.valueOf(mapSettingsId.keyset()).contains(oTaskVar.Custom_Settings_Linkage__c))
                if(mapSettingsId <> null && oTaskVar.Custom_Settings_Linkage__c <> null && !String.valueOf(mapSettingsId.keyset()).contains(oTaskVar.Custom_Settings_Linkage__c))
                {
                    oTaskVar.Status = System.Label.CampaignStatus_Cancelled;
                    lstTasks.add(oTaskVar);
                }
            }
            if(!lstTasks.isEmpty()){
                
                try
                {
                    update lstTasks;    
                }
                catch(Exception ex)
                {
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'Task',
                    String.valueOf(eventLocationsId),
                    'EventTriggerHelper','closeRelatedEvents',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstTasks),null);
                }
            }               
            /* ------- Activities logic ends ------------------------------- */
               
            eventLocationsId = new list<id>();
        }   
    }  
    
    // Updates Program record for rollup of Budget and Expense 
    //when Event/Campaign records are added deleted removed from Program record.
    public void UpdateProgramEventCampaignRollup(List<campaign> lstCampaigns,
    set<id> setProgramId)
    {  
        List<Campaign> lstEventCampaignUpdate = new List<Campaign>();
        List<Campaign> lstEventCampaign = new List<Campaign>();
        List<Campaign> lstRetrievePrograms =  new List<Campaign>();
        List<Campaign> lstPrograms =  new List<Campaign>();
        list<id> lstProgramIds = new list<id>();
        integer iTotalExpenseSum = 0;
        integer iTotalBudgetSum = 0;
        
        if(!setProgramId.isEmpty())
        {
            for(id oCampaignVar: setProgramId)
            lstProgramIds.add(oCampaignVar);               
        }
        
        if(!lstProgramIds.isEmpty()){
            lstPrograms = [select id, Roll_Up_Budget__c, 
            Actual_Expenses__c from campaign where
            id in: lstProgramIds and recordtypeid =: ProgramRecordTypeId ];
            
            lstEventCampaign = [select id, Total_Expense__c, 
            Total_Budget__c from campaign where 
            Program__r.id in : lstProgramIds and 
            (recordtypeid =: CampaignRecordTypeId or 
            recordtypeid =: eventRecordTypeId) ];
            
        }
        
        if(!lstEventCampaign.isEmpty()){
            for(campaign oCampaignVar : lstEventCampaign){
                if(oCampaignVar.Total_Expense__c != null){
                    iTotalExpenseSum = iTotalExpenseSum + 
                    integer.valueof(oCampaignVar.Total_Expense__c);    
                }
                if(oCampaignVar.Total_Budget__c != null){
                    iTotalBudgetSum = iTotalBudgetSum +
                    integer.valueof(oCampaignVar.Total_Budget__c);   
                }
            }
        }
        
        if(!lstPrograms.isEmpty()){
            
            for(campaign oCampaignVar : lstPrograms){     
                oCampaignVar.Roll_Up_Budget__c = iTotalBudgetSum;
                oCampaignVar.Actual_Expenses__c = iTotalExpenseSum;
                lstEventCampaignUpdate.add(oCampaignVar);
            }
            try
            {
                update lstEventCampaignUpdate;
            }
            catch(Exception ex)
            {
                Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
                ex.getStackTraceString(),'Program',
                String.valueOf(lstProgramIds),'EventTriggerHelper',
                'UpdateProgramEventCampaignRollup',
                'Application',UserInfo.getUserId(), 
                String.valueOf(lstEventCampaignUpdate),null);
            }
            iRecursiveCheckVolunteerCoordinator ++;
        }            
    } 
    
}