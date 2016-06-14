/*
    ***************************************************************************
    Name             : BudgetExpenseRollupTriggerHelper
    Description      : Trigger Helper class used to handle the budget expense 
                       related scenarios, where Budget/Expense is rolled up to
                       Campaign/Event records.                
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                  29/01/2015         Created
    Sumeet                  02/02/2015         Modified for code re-factoring
                                               & optimization
    ****************************************************************************
    
*/
public without Sharing class BudgetExpenseRollupTriggerHelper
{        
    private Id eventRecordTypeId;
    private Id campaignRecordTypeId;        
    
    /**
    * Method name  : identifyRecordTypes
    * Description  : Use this method to retrieve Record Types 
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    
    private void identifyRecordTypes()
    {
        Schema.DescribeSObjectResult campaignSchema = 
        Schema.SObjectType.Campaign; 
        Map<Id,Schema.RecordTypeInfo> mapRecordById= 
        campaignSchema.getRecordTypeInfosById();
        
        Map<String,Schema.RecordTypeInfo> mapRecordByName =
        campaignSchema.getRecordTypeInfosByName();
        
        //Assigning the record type of campaigns
        eventRecordTypeId = 
        mapRecordByName.get(
        System.label.Recordtype_Event).getRecordTypeId();
        campaignRecordTypeId = 
        mapRecordByName.get(
        System.label.Recordtype_Campaign).getRecordTypeId();      
    }
    
    /**
    * Method name  : constructor
    * Description  : Use this method to call a method retrieve Record Types 
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 

    public BudgetExpenseRollupTriggerHelper()
    {
        identifyRecordTypes();
    }
    
    /**
    * Method name  : BudgetExpenseIdTrack
    * Description  : Use this method to retrieve the campaign ids linked 
    *                to the budget and its corresponding records using SOQL.
    *                
    * Return Type  : void
    * Parameter    : List<BudgetExpense__c>, boolean, set<id> 
    **/ 

    public void budgetExpenseIdTrack(List<BudgetExpense__c> 
    lstBudgetExpense,boolean bIsDeleted,set<id> setCampainIds)    
    { 
        list<id> lstParentCampaignIdOfBudgetExpense = new List<id>();
        
        list<campaign> lstCampaignEventBudgetExpenseRollup = 
        new list<Campaign>();
        
        list<campaign> lstEvent = new list<Campaign>();
        list<id> lstEventIds = new List<id>();
        
        List<Campaign> lstCampaignBudgetExpenseRollup = 
        new List<Campaign>();
        
        //Adding of Parent Campaign Id of the Budget Expense Record
        if(!bIsDeleted && setCampainIds.size()>0)
        {
            for(id campaignId : setCampainIds)
            lstParentCampaignIdOfBudgetExpense.add(campaignId);
        }     
        //Adding of Parent Campaign Id of the Budget Expense Record
        if(bIsDeleted && setCampainIds.size()>0)
        {
            for(id CampaignIdVar : setCampainIds)
            lstParentCampaignIdOfBudgetExpense.add(CampaignIdVar);   
        }

        //Retrieving the Campaign record which is linked to the 
        //Budget Expense record 
        list<campaign> lstCampaign = [select id,  recordtypeid  
        from campaign where id in: lstParentCampaignIdOfBudgetExpense];
        for(Campaign oCampaignVar:lstCampaign)
        {
            if(oCampaignVar.recordTypeId == eventRecordTypeId)
            {
                
                lstEventIds.add(oCampaignVar.id);
                lstCampaignEventBudgetExpenseRollup.add(oCampaignVar);
            }
            
            else if(oCampaignVar.recordTypeId == campaignRecordTypeId)
            {                
                lstEventIds.add(oCampaignVar.id);
                lstCampaignEventBudgetExpenseRollup.add(oCampaignVar);
            }
        }

        //Method is called here for calculating rollup scenarios
        if(lstCampaignEventBudgetExpenseRollup.size() > 0)
        {    
            RollUpRelatedBudgetExpenseEvent
            (lstCampaignEventBudgetExpenseRollup);        
        }        
        
    } 
    
    /**
    * Method name  : rollUpRelatedBudgetExpenseEvent
    * Description  : Use this method to calculate the total budgets and roll it 
                     back to the event record followed by updating the records. 
    *                
    * Return Type  : void
    * Parameter    : List<Campaign> 
    **/    

    //Performs Rollup on Event/Campaign records from Budget\Expense records 
    //after insertion, updation, deletion.
    public void rollUpRelatedBudgetExpenseEvent(List<Campaign> lstEvent)
    {
        List<Id> lstEventIds = new List<Id>();
        
        List<Campaign> lstEventUpdate = new List<Campaign>();
        
        integer iTotalBudgetSum = 0;
        integer iTotalExpenseSum = 0;
        
        for(Campaign oCampaignVar: lstEvent)
        {
            if(oCampaignVar.recordTypeId == eventRecordTypeId)
            {
                lstEventIds.add(oCampaignVar.id);                
            }   
            else if(oCampaignVar.recordTypeId == campaignRecordTypeId)
            {
                lstEventIds.add(oCampaignVar.id);  
            }
        }
        
        //---------------------------------------
        //SOQL to retrieve the respective campaign or event record 
        //linked to the budget in concern
        list<Campaign> lstCampaignVar = [select id,Total_Budget__c,
        Total_Expense__c from Campaign where id in :lstEventIds ];  
        list<BudgetExpense__c > lstBudgetExpenses = [select id,Budget__c,
        Expense__c, campaign__c from BudgetExpense__c 
        where Campaign__r.id in :lstEventIds ];
        
        //Loop is executed for calculating the total budget values 
        //which will be rolled up to the concerned event/campaign
         map<id, campaign> mapEventCamp = new map<id, campaign>();
         map<id, list<BudgetExpense__c>> mapEventCampBudgetExpense =
          new map<id, list<BudgetExpense__c>>();
          
        for(Campaign oCampaignVar :lstCampaignVar )
        {
            campaign oCampRecordVar = oCampaignVar;
            id CampRecordId = oCampaignVar.id;   
            mapEventCamp.put(oCampaignVar.id,oCampaignVar);
            
         list<BudgetExpense__c> lstBudgetExpense = new list<BudgetExpense__c>();
            
            for(BudgetExpense__c oBudgetExpenseVar: lstBudgetExpenses)
            {
                if(oBudgetExpenseVar.campaign__c == oCampaignVar.id )
                {
                    lstBudgetExpense.add(oBudgetExpenseVar);
                }                
            }
            mapEventCampBudgetExpense.put(oCampaignVar.id,lstBudgetExpense);
        }
        
         set<id> setEventCampId = new set<id>();
         setEventCampId = mapEventCamp.keyset();
        
          for(id is: setEventCampId)
        {            
            list<BudgetExpense__c> lstBudgetExpense =
            mapEventCampBudgetExpense.get(is);
            campaign oEventCampRecordVar = mapEventCamp.get(is);    

            for(BudgetExpense__c oBudgetVar: lstBudgetExpense)
            {
                       if( oBudgetVar.Budget__c != null )
                    {
                        iTotalBudgetSum = iTotalBudgetSum + 
                        integer.valueof(oBudgetVar.Budget__c);
                    }
                    if( oBudgetVar.Expense__c != null)
                    {
                        iTotalExpenseSum = iTotalExpenseSum + 
                        integer.valueof(oBudgetVar.Expense__c);
                    }        
            }
        //--------------------------
        
        //Rolling up Budget/Expense values to parent Campaign/Event Level.
                oEventCampRecordVar.Total_Budget__c = iTotalBudgetSum ;  
                
                oEventCampRecordVar.Total_Expense__c = iTotalExpenseSum; 
                
                lstEventUpdate.add(oEventCampRecordVar);
                iTotalBudgetSum = 0;
                iTotalExpenseSum = 0;
            }
            
            try
            {
                update lstEventUpdate;      
            }
            catch(Exception ex)
            {
                //Creating a new Error Log record whenever any exception is 
                //encountered while performing DML Operation
               
                String sRelatedRecordIds = '';
                for(Campaign oCampaignVar : lstEventUpdate)
                {
                    sRelatedRecordIds += oCampaignVar.id ;
                }
                 Utility.insertErrorLogApplication(ex.getMessage()+'\n'
                 +ex.getStackTraceString(),'Event',sRelatedRecordIds,
                 'BudgetExpenseRollupTriggerHelper',
                 'rollUpRelatedBudgetExpenseEvent',
                 'Application',UserInfo.getUserId(), 
                 String.valueOf(lstEventUpdate),null);
               
            }
    }  
}