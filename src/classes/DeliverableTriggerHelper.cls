/*******************************************************************************
    Name             : DeliverableTriggerHelper
    Description      : Trigger Helper class used to handle multiple 
                       scenario of Deliverable .                   
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring
                                              & optimization
******************************************************************************/

public with sharing class DeliverableTriggerHelper
{
    /**
    * Method name  : updateTaskAssignmentScenario
    * Description  :This method is used for task Assignment process on 
    *               deliverable update 
    * Return Type  : List<Deliverable__c>,List<Deliverable__c>
    * Parameter    : void
    **/   

    public static void updateTaskAssignmentScenario(List<Deliverable__c> 
    lstOldDeliverable, List<Deliverable__c> lstNewDeliverable)
    {
        List<id> lstDeliverableIds = new List<id>();
        for(Deliverable__c oOldDelVar: lstOldDeliverable)
        {
            for(Deliverable__c oNewValueVar: lstNewDeliverable)
            {
                if(oOldDelVar.Status__c <> System.label.Complete &&
                oNewValueVar.Status__c ==  System.label.Complete &&
                !oNewValueVar.Override_Task_Dependency__c)
                {
                    lstDeliverableIds.add(oNewValueVar.id);
                }                
                
            }
        }
        if(lstDeliverableIds.size() > 0)
        {
            List<Task> lstTask = [Select id, Status, WhatId  from Task where 
            WhatId in :lstDeliverableIds]; 
            //Checking for related task of deliverable 
            //which are marked as completed.
            
            for(Deliverable__c oUpdatedDeliverable: lstNewDeliverable)
            {
                for(Task oTaskVar: lstTask)
                {
                    if(oTaskVar.WhatId == oUpdatedDeliverable.id && 
                    oTaskVar.Status <> System.label.Completed)
                    {
                        oUpdatedDeliverable.addError
                        (System.Label.TaskDependencyError1);
                        //Please complete the Related Tasks first before 
                        //marking the Deliverable Status as Complete.
                    }
                }
            }
        }
    }
    /**
    * Method name  : cancelTask
    * Description  : This method is used for cancelling all 
    *                deliverable based tasks 
    * Return Type  : List<Deliverable__c>,Map<Id,Deliverable__c>
    * Parameter    : void
    **/   
    
    public static void cancelTask(Map<Id,Deliverable__c> mapOldDeliverable,
    Map<Id,Deliverable__c>mapNewDeliverable)
    {
        
        Set<Id> setDeliverableId=new Set<Id>();
        
        for(Id deliverableIdVar: mapOldDeliverable.keySet())
        {
            if((mapOldDeliverable.get(deliverableIdVar).Status__c!=
            mapNewDeliverable.get(deliverableIdVar).Status__c)&&
            mapNewDeliverable.get(deliverableIdVar).Status__c=='Cancelled')
            {
                //Looking for Deliverable of Status Change and
                //filtering out Cancelled Deliverable
                setDeliverableId.add(deliverableIdVar);
            }
        }
        
        List<Task> lstAllTask=new List<Task>();
        
        lstAllTask=[select Id,Status from Task where whatId IN :setDeliverableId and Status <> 'Completed'];
        
        for(Task oTaskVar: lstAllTask)
        {
            oTaskVar.Status=System.label.Cancelled;  
            //Setting all task as Cancelled
        }
        
        try
        {
            update lstAllTask;
        }
        catch(Exception ex)
        {
      
            Utility.insertErrorLogApplication(ex.getMessage()+
            '\n'+ex.getStackTraceString(),'Deliverable__c', String.valueOf
            (setDeliverableId),'DeliverableTriggerHelper',
            'cancelTask','Application',UserInfo.getUserId(), 
            String.valueOf(lstAllTask),
            String.valueOf(mapOldDeliverable.values()));
        }
        
    }
    /**
    * Method name  : assignOwner
    * Description  : This method is used assign Deliverable Owner 
    *                as same as Assigned To
    * Return Type  : List<Deliverable__c>,Map<Id,Deliverable__c>
    * Parameter    : void
    **/   
    public static void assignOwner(List<Deliverable__c> lstNewDeliverable){

        for(Deliverable__c oDeliverableVar: lstNewDeliverable){
            
            if(oDeliverableVar.Assigned_To__c!=null)
            oDeliverableVar.OwnerId=oDeliverableVar.Assigned_To__c;  
            //Assigning Assigned To value to Owner Field
        }
    }
}