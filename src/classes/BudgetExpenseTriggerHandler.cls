/*
    ****************************************************************************
    Name             : BudgetExpenseTriggerHandler
    Description      : Trigger Helper class used to handle the scenario of 
    Budget Calculation and roll back to corresponding Event and Campaign.                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                  05/12/2014         Created
    Sumeet                  02/02/2015         Modified for code re-factoring 
                                               & optimization
    ***************************************************************************
    
*/

public without Sharing class BudgetExpenseTriggerHandler
{   
    /**
    * Method name  : performBudgetExpenseRollUp
    * Description  : Use this method to calculate 
      the corresponding Budget Expense 
      and roll it back to corresponding Event or Campaign record type record
    *                
    * Return Type  : void
    * Parameter    : Map<Id, BudgetExpense__c> 
    **/  
    
    //This method is used for calculating Budget 
    //during Insert and Update operations
    public static void performBudgetExpenseRollUp
    (Map<Id, BudgetExpense__c> mapNewBudgetExpense)
    {
        boolean bIsDeleted = false;
        
        list<BudgetExpense__c> lstBudgetExpense = 
        new List<BudgetExpense__c>();
        
        set<Id> setCampaignId = new set<Id>();
        set<Id> setAvailableIds = new set<Id>();
        
        if(mapNewBudgetExpense <> null)
        {
            setAvailableIds = mapNewBudgetExpense.keySet();
        }
        
        //Loop is executed to retrieve the Campaign id and put it in a List
        for(Id varId: setAvailableIds)
        {
            if(varId != null)
            {
                setCampaignId.add(mapNewBudgetExpense.get(varId).campaign__c);  
                lstBudgetExpense.add(mapNewBudgetExpense.get(varId));                                    
            }  
        }
        
        //Another class method is called which performs all the 
        //budget expense calculation 
        //based on the Business rules    
        if(lstBudgetExpense <> null && setCampaignId <> null 
        && lstBudgetExpense.size()>0 && setCampaignId.size()>0)
        {
            BudgetExpenseRollupTriggerHelper helperReference = 
            new BudgetExpenseRollupTriggerHelper();
            helperReference.budgetExpenseIdTrack(lstBudgetExpense , 
            false, setCampaignId ); 
        }        
    }
    
    
    /**
    * Method name  : performPostDeleteOperations
    * Description  : Use this method to calculate the corresponding  
    Budget Expense on deletion of budget and roll it back 
    to corresponding Event 
    or Campaign record type record
    *                
    * Return Type  : void
    * Parameter    : Map<Id, BudgetExpense__c> 
    **/
    
    //This method is used for performing post delete operations 
    //for budgetexpense roll up
    public static void performPostDeleteOperations
    (Map<Id, BudgetExpense__c> mapBudgetExpense)
    {
        boolean bIsDeleted = false;
        list<BudgetExpense__c> lstBudgetExpense = new List<BudgetExpense__c>();
        
        set<Id> setCampaignId = new set<Id>();
        set<Id> setAvailableIds = new set<Id>();
        
        if(mapBudgetExpense <> null)
        {
            setAvailableIds = mapBudgetExpense.keySet();
        }
        
        if(setAvailableIds.size() > 0)
        {
            for(Id varId: setAvailableIds)
            {
                setCampaignId.add(mapBudgetExpense.get(varId).campaign__c);   
                lstBudgetExpense.add(mapBudgetExpense.get(varId));           
            }
        }
        
        if(setCampaignId.size()>0 && lstBudgetExpense <> null)
        {
            BudgetExpenseRollupTriggerHelper helperReference = 
            new BudgetExpenseRollupTriggerHelper();
            helperReference.budgetExpenseIdTrack(lstBudgetExpense , 
            true, setCampaignId );
        }
        
    }
    
    
    
}