/*
    ***************************************************************************
    Name             : GoalsTriggerHandler
    Description      : Trigger Helper class used to handle the scenario of Goals 
                       Calculation and roll back to corresponding Event and
                       Campaign.                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                  05/12/2014            Created
    Sumeet                  02/02/2015            Modified for code re-factoring
                                                  & optimization
    **************************************************************************
    
*/
public without Sharing class GoalsTriggerHandler
{
    /**
    * Method name  : goalsRollUpOnCampaignObjectafterUpdate
    * Description  : Use this method for calculating Goals Roll Up on 
                     Event/Event Location object after goal is updated 
    *                
    * Return Type  : void
    * Parameter    : Map<Id, Goals__c> , list<goals__c> , list<goals__c> 
    **/
    
    //This method is used for calculating Goals Roll Up on Event/Event 
    //Location object after goal is updated
    public static void goalsRollUpOnCampaignObjectafterUpdate(Map<Id, Goals__c>
    mapNewGoalsList, Map<Id, Goals__c> mapOldGoalsList, 
    list<goals__c> lstNewGoals, list<goals__c> lstOldGoals)
    {    
        boolean bIsDeleted = false;
        list<Goals__C> lstGoals = new list<goals__c>(); 
        set<Id> setGoalIds = mapNewGoalsList.keySet();
        set<Id> setCampaignId = new set<Id>();
        list<Goals__c> lstGoalsDeletedRecords = new list<goals__c>();   
        
        if(EventTriggerHelper.iRecursiveCheck <= 2)
        {                       
            for(Goals__c oNewGoalsVar : lstNewGoals)
            { 
            if((mapOldGoalsList.get(oNewGoalsVar.id).Status__c <>
            System.label.Cancelled && oNewGoalsVar.Status__c ==
            System.label.Cancelled)||
            (mapOldGoalsList.get(oNewGoalsVar.id).Status__c <> System.label.lost
            && oNewGoalsVar.Status__c == System.label.lost)||
            (mapOldGoalsList.get(oNewGoalsVar.id).CIV_ID__c <> 
            oNewGoalsVar.CIV_ID__c ) ||
            (mapOldGoalsList.get(oNewGoalsVar.id).Funds__c <>
            oNewGoalsVar.Funds__c ) ||
            (mapOldGoalsList.get(oNewGoalsVar.id).Goal_Type__c <> 
            oNewGoalsVar.Goal_Type__c) ||
            (mapOldGoalsList.get(oNewGoalsVar.id).Product__c <> 
            oNewGoalsVar.Product__c  ) || 
            (mapOldGoalsList.get(oNewGoalsVar.id).Rate__c <> 
            oNewGoalsVar.Rate__c ) ||
            (mapOldGoalsList.get(oNewGoalsVar.id).Revenue_Target__c <> 
            oNewGoalsVar.Revenue_Target__c ) ||
            (mapOldGoalsList.get(oNewGoalsVar.id).Target_Number__c <>
            oNewGoalsVar.Target_Number__c )||
            (mapOldGoalsList.get(oNewGoalsVar.id).Description__c<>
            oNewGoalsVar.Description__c)||
            (mapOldGoalsList.get(oNewGoalsVar.id).Status__c <>
            oNewGoalsVar.Status__c ))            
            {  
            setCampaignId.add(mapNewGoalsList.get(oNewGoalsVar.id).campaign__c);  
                lstGoals.add(oNewGoalsVar);  
               
                }
            }           
            
            if(lstGoals.size()>0 && setCampaignId.size()>0)
            {
                EventTriggerHelper helperReference = new EventTriggerHelper();
                helperReference.GoalsIDTrap(lstGoals, false, setCampaignId ); 
            }
        }            
    }
    
    /**
    * Method name  : goalsRollUpOnCampaignObjectafterinsert
    * Description  : Use this method for calculating Goals Roll Up on 
    *                Event/Event Location object after goal is inserted 
    *                
    * Return Type  : void
    * Parameter    : Map<Id, Goals__c> , list<goals__c> 
    **/
    
    //This method is used for calculating Goals Roll Up on Event/Event Location 
    //object after goal is inserted
    public static void goalsRollUpOnCampaignObjectafterinsert(Map<Id, 
    Goals__c> mapNewGoalsList, list<goals__c> lstNewGoals)
    { 
        boolean bIsDeleted = false;
        list<Goals__C> lstGoals = new list<goals__c>(); 
        set<Id> setGoalIds = mapNewGoalsList.keySet();
        set<Id> setCampaignId = new set<Id>();
        list<Goals__c> lstGoalsDeletedRecords = new list<goals__c>();   
        
        //Condition to check for recursive entry of this code execution
        if(EventTriggerHelper.iRecursiveCheck <= 2)
        {              
        //Loop is executed which check if the provided required data are not 
        //null proceed for goal calculation
            for(Goals__c oNewGoalsVar : lstNewGoals)
            { 
                if((oNewGoalsVar.Status__c != null)||
                (oNewGoalsVar.Status__c != null)||
                (oNewGoalsVar.CIV_ID__c  != null ) ||
                (oNewGoalsVar.Funds__c  != null) ||
                (oNewGoalsVar.Goal_Type__c  != null) ||             
                (oNewGoalsVar.Product__c  != null ) ||
                (oNewGoalsVar.Rate__c  != null ) ||
                (oNewGoalsVar.Revenue_Target__c  != null) || 
                (oNewGoalsVar.Target_Number__c != null )||
                (oNewGoalsVar.Status__c  != null))                      
                {         
                    for(Id goalVarId: setGoalIds)
                    {
                        if(goalVarId != null)
                        {
                 setCampaignId.add(mapNewGoalsList.get(goalVarId).campaign__c);  
                            lstGoals.add(mapNewGoalsList.get(goalVarId));                                    
                        }  
                    }          
                }
            }
            
          
            if(lstGoals.size()>0 && setCampaignId.size()>0)
            {
                EventTriggerHelper helperReference = new EventTriggerHelper();
                helperReference.GoalsIDTrap(lstGoals, false, setCampaignId ); 
            }
        }            
    }
    
    /**
    * Method name  : performPostDeleteGoalsRollup
    * Description  : Use this method for assigning goals roll up scenario for
    *                post delete operations 
    *                
    * Return Type  : void
    * Parameter    : Map<Id, Goals__c> 
    **/
    
    //This method is used for assigning goals roll up scenario for post delete
    //operations
    public static void performPostDeleteGoalsRollup(Map<Id, Goals__c> 
    mapOldGoalsList)
    {
        if(EventTriggerHelper.iRecursiveCheck <= 2)
        {
            set<Id> setGoalIds = mapOldGoalsList.keySet();
            set<Id> setCampaignId = new set<Id>();
            list<Goals__C> lstGoals = new list<goals__c>(); 
            
            for(Id goalVarId: setGoalIds)
            {
                if(goalVarId != null)
                {
                  setCampaignId.add(mapOldGoalsList.get(goalVarId).campaign__c);                    
                }  
            }
            
            // Calls the method which does the calculation based on the Business
            //Logic
            if(setCampaignId.size()>0)
            {
                EventTriggerHelper helperReference = new EventTriggerHelper();
                helperReference.GoalsIDTrap(lstGoals , true, setCampaignId );             
            }
        }
    }
    
    
}