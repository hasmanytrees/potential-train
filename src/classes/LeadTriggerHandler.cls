/*******************************************************************************
    Name             : LeadTriggerHandler
    Description      : Trigger handler class used to handle the scenario of auto
                       follow, unfollow and custom Lean conversion                    
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Subhojit                29/01/2015       Modified for code re-factoring &
                                         optimization
*******************************************************************************/
public with Sharing class LeadTriggerHandler{

    
    /**
    * Method name  : followAndUnfollowHandler
    * Description  : Use this method to follow and unfollow Lead  record 
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Lead>,Map<Id,Lead>
    **/
    
    public static void performPostDMLScenarios(List<Lead> lstNewLeadRecords, List<Lead> lstOldLeadRecords, Map<Id, Lead> mapNewLeadRecords, Map<Id, Lead> mapOldLeadRecords, Boolean bIsInsert)
    {
        if((bIsInsert && Trigger_Methods_Activation__c.getInstance
                    ('followAndUnfollowHandlerLead').Is_Trigger_Method_Required_In_Insert__c)
                ||(!bIsInsert && Trigger_Methods_Activation__c.getInstance
                    ('followAndUnfollowHandlerLead').Is_Trigger_Method_Required_In_Update__c))
        {
            
            followAndUnfollowHandler(mapNewLeadRecords,mapOldLeadRecords);    
            //Initiating Lead follow and follow scenario by owner
            
        }

        CampaignTriggerHelper triggerHelperReference = new CampaignTriggerHelper(); 
        
        String sDMLType = System.Label.DMLType_Insert;
        if(!(bIsInsert))
        {
            sDMLType = System.Label.DMLType_Update;
        }
        
        List<Lead> lstLeadToCreateTasks = new List<Lead>();
        
        if(!bIsInsert)
        {
            for(Lead oLeadNewValues: lstNewLeadRecords)
            {
                for(Lead oLeadOldValues: lstOldLeadRecords)
                {
                    if(oLeadOldValues.Lead_Score__c <> oLeadNewValues.Lead_Score__c ||
                            (oLeadNewValues.Assign_Task_To_Queue__c && 
                                !oLeadOldValues.Assign_Task_To_Queue__c))
                    {
                        lstLeadToCreateTasks.add(oLeadNewValues);      
                        //If there is a change in Lead Score add Lead to
                        //List for new Task creation
                    }
                }
            }
            
            if(lstLeadToCreateTasks.size() > 0 && 
                    Trigger_Methods_Activation__c.getInstance
                    ('createLeadBasedTasks').Is_Trigger_Method_Required_In_Update__c)
            {        
                triggerHelperReference.createLeadBasedTasks(lstLeadToCreateTasks, sDMLType);  
                //Initiating Class to create Lead based Task for Lead update scenario
            }
        }
        else if(Trigger_Methods_Activation__c.getInstance
                ('createLeadBasedTasks').Is_Trigger_Method_Required_In_Insert__c)
        {
            triggerHelperReference.createLeadBasedTasks(lstNewLeadRecords, sDMLType);   
            //Initiating Class to create Lead based Task for Lead create scenario
        }
    }
    
    
    /**
    * Method name  : followAndUnfollowHandler
    * Description  : Use this method to follow and unfollow Lead  record 
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Lead>,Map<Id,Lead>
    **/ 


    private static void followAndUnfollowHandler(Map<Id,Lead> mapNewLead,
    Map<Id,Lead> mapOldLead){
        
        Map<Id,Lead> mapNewLeadVar=new Map<Id,Lead>();
        Map<Id,Lead> mapOldLeadVar=new Map<Id,Lead>();
        for(Lead oLeadVar: mapNewLead.values()){
            
            if(!mapNewLead.get(oLeadVar.Id).isConverted){
                if((mapOldLead!=null)&&(mapOldLead.get
                (oLeadVar.Id).ownerId!=oLeadVar.ownerId)){
                    //Getting Previous Lead owner for Unconverted Lead
                    //It runs for update,delete scenario.
                    mapNewLeadVar.put(oLeadVar.Id,oLeadVar);
                    mapOldLeadVar.put(oLeadVar.Id,mapOldLead.get(oLeadVar.Id));
                }
                else{
                    //Getting new Lead owner for Unconverted Lead
                    //It runs for insert scenario.
                    mapNewLeadVar.put(oLeadVar.Id,oLeadVar);
                    
                }
            }

        }

        try{
            
            if(mapNewLeadVar <> null && mapNewLeadVar.size()>0){
                FollowUnFollowChatterHelper.autoFollowsObject
          ((Map<Id,sobject>)mapNewLeadVar,System.Label.OwnerId,System.Label.Id); 
                // Calling Helper class to initiate method to follow record
            }
            if(mapOldLeadVar.size()>0){
                FollowUnFollowChatterHelper.autoUnfollowsObject
                ((Map<Id,sobject>)mapOldLeadVar,System.Label.OwnerId);
                // Calling Helper class to initiate method to unfollow record
            } 
            
        }
        catch(Exception ex)
        {
            //Creating a new Error Log record whenever any exception is
            //encountered while performing DML Operation
            Utility.insertErrorLogApplication(ex.getMessage()+
            '\n'+ex.getStackTraceString(),'Lead'
            ,String.valueOf(mapNewLeadVar.keyset()), 'LeadTriggerHandler', 
            'followAndUnfollowHandler', 'Application', UserInfo.getUserId(),
            String.valueOf(mapNewLeadVar), String.valueOf(mapOldLeadVar));
            
        }

    }

}