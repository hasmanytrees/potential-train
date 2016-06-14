/*
*******************************************************************************
Name             : TaskTriggerHandler
Description      : Trigger Handler class used to perform all Tasks related
                   validations and assignments                  
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                05/12/2014         Created
Sreeja                27/01/2015         Made modifications for bypassing 
                                         validation check of child in case of 
                                         Cancelled Scnearios.
Sumeet                02/02/2015         Modified for code re-factoring & 
                                         optimization which includes proper 
                                         commenting and alignment as well
******************************************************************************
    
*/
public class TaskTriggerHandler
{
    
    
    /**
    * Method name  : changeChildTasksToActiveOnceParentTaskIsComplete
    * Description  : Use this method to change the child task status to assigned
                     from not available once all its  
    *                
    * Return Type  : void
    * Parameter    : List<Task> newTaskList, List<Task> oldTaskList
    **/  
    
    public static void changeChildTasksToActiveOnceParentTaskIsComplete
    (List<Task> lstNewTasks, List<Task> lstoldTasks)
    {
        List<id> lstCompletedTaskId = new List<id>();
        List<id> lstParentWhatId = new List<id>();
        List<String> lstTaskRecurssionReference = new List<String>();
        Id currentParentId; 
        List<String> lstParentOrder = new List<String>();
        List<Id> lstChildIds = new List<Id>();
        Set<Id> setDependentChildIds = new Set<Id>();
        List<DeliverableBasedTaskList__c> lstChild = 
        new List<DeliverableBasedTaskList__c>();
        List<String> lstChildBasedDependency = new List<String>();
        
        for(Task oOldTaskVar: lstoldTasks)
        {
            for(Task oNewTaskVar: lstNewTasks)
            {
                if(oOldTaskVar.Status <> System.Label.Cancelled &&
                oOldTaskVar.Status <> System.Label.Completed && 
                oNewTaskVar.Custom_Settings_Linkage__c <> null && 
                oNewTaskVar.Status == System.Label.Completed)
                {
                 lstCompletedTaskId.add(oNewTaskVar.Custom_Settings_Linkage__c);
                 lstParentWhatId.add(oNewTaskVar.WhatId);
                 currentParentId = oNewTaskVar.id;
                 lstTaskRecurssionReference.add
                 (oNewTaskVar.Related_Object_Reference__c);
                }
            }
        }
        
        //SOQL to retrieve order of the completed tasks from Custom Settings
        List<DeliverableBasedTaskList__c> lstParents = 
        [Select Order__c from DeliverableBasedTaskList__c where 
        id in :lstCompletedTaskId];
        
        //Creating a lst of Order values for the parent List
        for(DeliverableBasedTaskList__c oDeliverableTaskListVar: lstParents)
        {
            lstParentOrder.add('%'+oDeliverableTaskListVar.Order__c+'%');
        }
        
        //SOQL to retrieve the list of corresponding child values
        lstChild  = [select id, Dependency__c from DeliverableBasedTaskList__c
        where Dependency__c like :lstParentOrder];
        
        //Iteration happens on the custom settings data for getting the related 
        //parent tasks
        for(DeliverableBasedTaskList__c oDeliverableTaskListVar:lstChild)
        {
            if(oDeliverableTaskListVar.Dependency__c.contains
            (System.Label.Dependent_Tasks_Split_Parameter))
            {
                List<String> lstOfParent = oDeliverableTaskListVar
            .Dependency__c.split(System.Label.Dependent_Tasks_Split_Parameter);
                for(String sParentListValues: lstOfParent)
                {
                    lstChildBasedDependency.add(sParentListValues);
                }
                setDependentChildIds.add(oDeliverableTaskListVar.id);
            }
            else
            {
                lstChildIds.add(oDeliverableTaskListVar.id);
            }
            
        }
        
        //This section is executed when there are more than one parents for a 
        //particular child in concern
        if(lstChildIds.size() > 0) 
        {
            //SOQL is used for retrieving the child tasks from the parent Task 
            //what id and the child custom linkage id
            List<Task> lstChildTasks = [select id, Status from Task where 
            Related_Object_Reference__c in :lstTaskRecurssionReference and 
            Custom_Settings_Linkage__c in :lstChildIds and WhatId 
            in :lstParentWhatId];
            List<Task> lstUpdateChildTask = new List<Task>();
            for(Task oChildTaskVar: lstChildTasks)
            {
                if(oChildTaskVar.Status <> System.Label.Cancelled && 
               oChildTaskVar.Status <> System.Label.Deliverable_Status_Assigned)
                {
                oChildTaskVar.Status = System.Label.Deliverable_Status_Assigned;
                    lstUpdateChildTask.add(oChildTaskVar);
                }
            }
            if(lstUpdateChildTask.size() > 0)
            {
                try
                {
                    update lstUpdateChildTask;
                }
                catch(Exception ex)
                {
                    //Creating a new Error Log record whenever any exception is
                    //encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex.getMessage()+'\n'
                    +ex.getStackTraceString(),'Task',
                    String.valueOf(lstParentWhatId),'TaskTriggerHandler',
                    'changeChildTasksToActiveOnceParentTaskIsComplete',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstUpdateChildTask),
                    String.valueOf(lstoldTasks));
                   
                }
            }
        }
        else if(lstChildBasedDependency.size() > 0)
        {
            List<DeliverableBasedTaskList__c> lstParent = [select id from 
            DeliverableBasedTaskList__c where Order__c 
            in :lstChildBasedDependency];
            List<Id> lstParentTaskId = new List<Id>();
            
            for(DeliverableBasedTaskList__c oDeliverableTaskListVar: lstParent)
            {
                lstParentTaskId.add(oDeliverableTaskListVar.id);                   
            }
            List<Task> lstParentTasks = [select id, Status from Task where
            Related_Object_Reference__c in :lstTaskRecurssionReference and 
            Custom_Settings_Linkage__c in :lstParentTaskId and WhatId
            in :lstParentWhatId];
           
            Boolean bAllTaskComplete = true;
            for(Task oTaskVar: lstParentTasks)
            {
                if(oTaskVar.Status <> System.Label.Completed)
                {
                    bAllTaskComplete = false;
                }
            }
            
         //This confirms that once both the listParent are complete then only 
         //change the status of the child task for multiple parent scenario
            if(bAllTaskComplete)
            {
                if(setDependentChildIds.size() > 0) 
                {
                 List<Task> lstChildTasks = [select id, Status from Task where 
                 Related_Object_Reference__c in :lstTaskRecurssionReference and 
                 Custom_Settings_Linkage__c in :setDependentChildIds and WhatId
                 in :lstParentWhatId];
                    List<Task> lstUpdateChildTask = new List<Task>();
                    for(Task oChildTaskVar: lstChildTasks)
                    {
                        if(oChildTaskVar.Status <> 
                        System.Label.Deliverable_Status_Assigned)
                        {
                            oChildTaskVar.Status = 
                            System.Label.Deliverable_Status_Assigned;
                            lstUpdateChildTask.add(oChildTaskVar);
                        }
                    }
                    
                    if(lstUpdateChildTask.size() > 0)
                    {
                        try
                        {
                            update lstUpdateChildTask;
                        }
                        catch(Exception ex)
                        {
                       //Creating a new Error Log record whenever any exception 
                       //is encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex
                    .getMessage()+'\n'+ex.getStackTraceString(),'Task',
                    String.valueOf(lstParentWhatId),'TaskTriggerHandler',
                     'changeChildTasksToActiveOnceParentTaskIsComplete',
                      'Application',UserInfo.getUserId(), 
                       String.valueOf(lstUpdateChildTask),
                       String.valueOf(lstoldTasks));
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    /**
    * Method name  : restrictOwnerChange
    * Description  : Use this method to change the deliverable status to 
    *                 confirmed if a single task has been kept opened  
    *                
    * Return Type  : void
    * Parameter    : Set<Id> lstCampaignId, List<Id> lstOwners 
    **/ 
    
    public void restrictOwnerChange(Set<Id> lstCampaignId, List<Id> lstOwners)
    {
        List<Task> lstTasks = [select id, Initial_Task_Owner__c, OwnerId from Task where WhatId in :lstCampaignId];
        for(Task oTaskVar : lstTasks)
        {
            if(oTaskVar.Initial_Task_Owner__c == null)
            oTaskVar.Initial_Task_Owner__c = oTaskVar.OwnerId;
            
            else
            oTaskVar.OwnerId = oTaskVar.Initial_Task_Owner__c;
        }
        update lstTasks;
    }
    
    /**
    * Method name  : changeDeliverableStatusToConfirmed
    * Description  : Use this method to change the deliverable status to 
    *                 confirmed if a single task has been kept opened  
    *                
    * Return Type  : void
    * Parameter    : List<Task> 
    **/ 
    
    //This method is used for changing the Deliverable status back to confirmed 
    //if any one open task is created under it
    public static void changeDeliverableStatusToConfirmed(List<Task> 
    lstProvidedTask)
    {
        List<Id> lstDeliverableId = new List<Id>();
        for(Task t : lstProvidedTask)
        {
            if(t.Status <> System.Label.Completed)
            {
                lstDeliverableId.add(t.WhatId);
            }         
        }
        
        //SOQL to retrieve the Deliverable record based on the related 
        //deliverable id from the task record
        List<Deliverable__c> lstDeliverable = [select id, Status__c from 
        Deliverable__c where id in :lstDeliverableId];
        List<Deliverable__c> lstUpdates = new List<Deliverable__c>();
        if(lstDeliverable.size() > 0)
        {
            for(Deliverable__c deliverableVar: lstDeliverable)
            {
                if(deliverableVar.Status__c <> System.Label.Cancelled && 
                (deliverableVar.Status__c == System.Label.Complete ||
                deliverableVar.Status__c == System.Label.Completed))
                {
               deliverableVar.Status__c = System.Label.CampaignStatus_Confirmed;
                    lstUpdates.add(deliverableVar);
                }
            }
            if(lstUpdates.size() > 0)
            {
                try
                {
                    update lstUpdates;
                }
                catch(Exception ex)
                {
                 //Creating a new Error Log record whenever any exception is 
                 //encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex.getMessage
                    ()+'\n'+ex.getStackTraceString(),'Task',
                    String.valueOf(lstDeliverableId),'TaskTriggerHandler',
                    'changeDeliverableStatusToConfirmed','Application',
                    UserInfo.getUserId(), String.valueOf(lstUpdates),null);
                    
                }
            }
        }
    }
    

    

    
    /**
    * Method name  : changeDeliverableStatus
    * Description  : Use this method to change the deliverable status to 
    *                confirmed once a single task has been created  
    * Return Type  : void
    * Parameter    : List<Task> providedTaskList      
    **/ 
    
    public static void changeDeliverableStatus(List<Task> providedList)
    {
        List<Id> lstDeliverableId = new List<Id>();
        for(Task oTaskVar: providedList)
        {
            if(oTaskVar.Status <> System.Label.Cancelled)
            lstDeliverableId.add(oTaskVar.WhatId);
        }
        List<Deliverable__c> lstDeliverable = [Select id, Status__c, 
        Override_Task_Dependency__c from Deliverable__c where 
        id in :lstDeliverableId];
        List<Deliverable__c> lstUpdates = new List<Deliverable__c>();
        for(Deliverable__c deliverableVar: lstDeliverable)
        {
            if(deliverableVar.Status__c <> System.Label.CampaignStatus_Confirmed
            && (deliverableVar.Status__c == System.Label.Complete || 
            deliverableVar.Status__c == System.Label.Completed)  
            && !deliverableVar.Override_Task_Dependency__c)
            {
              deliverableVar.Status__c = System.Label.CampaignStatus_Confirmed;
                lstUpdates.add(deliverableVar);
            }
        }
        if(lstUpdates.size() > 0)
        {
            try
            {
                update lstUpdates;
            }
            catch(Exception ex)
            {
                //Creating a new Error Log record whenever any exception is
                //encountered while performing DML Operation
                Utility.insertErrorLogApplication(ex.getMessage()
                +'\n'+ex.getStackTraceString(),'Deliverable',
                String.valueOf(lstDeliverableId),'TaskTriggerHandler',
                'changeDeliverableStatus','Application',UserInfo.getUserId(),
                String.valueOf(lstUpdates),null);
                
            }
        }
        
    }
    
    /**
    * Method name  : completeDeliverables
    * Description  : Use this method to change the deliverable status to   
    *                complete once all related tasks has been completed 
    * Return Type  : void
    * Parameter    : List<Task> providedTaskList      
    **/
    public static void completeDeliverables(List<Task> lstTasks)
    {
        Set<Id> lstDeliverableId = new Set<Id>();
        Boolean isAllTaskCompleted = true;
        for(Task oTaskVar: lstTasks)
        {
            if(oTaskVar.Status <> System.Label.Cancelled)
            lstDeliverableId.add(oTaskVar.WhatId);
        }
        List<Task> lstdeliverableTasks = [Select id,Status, WhatId from Task 
        where WhatId in :lstDeliverableId];
        for(Task oTaskVar: lstdeliverableTasks)
        {
            if(oTaskVar.Status <> System.Label.Completed)
            {
                if(lstDeliverableId.contains(oTaskVar.WhatId))
                {
                    lstDeliverableId.remove(oTaskVar.WhatId);
                }
            }
        }
        if(lstDeliverableId.size() > 0)
        {
            List<Deliverable__c> lstUpdates = new List<Deliverable__c>();
            for(Deliverable__c deliverableVar: [select id, Status__c,
            Override_Task_Dependency__c from Deliverable__c where 
            id in :lstDeliverableId])
            {
                if(deliverableVar.Status__c <> System.Label.Complete && 
                !deliverableVar.Override_Task_Dependency__c)
                {
                    deliverableVar.Status__c = System.Label.Complete;
                    lstUpdates.add(deliverableVar);
                }
            }
            
            if(lstUpdates.size() > 0)
            {
                try
                {
                    update lstUpdates;
                }
                catch(Exception ex)
                {
                    //Creating a new Error Log record whenever any exception is
                    //encountered while performing DML Operation
                    Utility.insertErrorLogApplication(ex.getMessage
                    ()+'\n'+ex.getStackTraceString(),'Deliverable',
                    String.valueOf(lstDeliverableId),'TaskTriggerHandler',
                    'completeDeliverables','Application',UserInfo.getUserId(),
                    String.valueOf(lstUpdates),null);
                    
                }
            }
        }
    }
    
    /**
    * Method name  : changeAssignToValueToProjectManager
    * Description  : Use this method to assign the OSR related tasks created 
    *                from workflows to project manager which has been defaulted 
    *                to deliverable owner.
    * Return Type  : void
    * Parameter    : List<Task> lstNewTasksCreated
    **/
    
    //This method is used for changing the Task Assigned To from Deliverable 
    //Owner to Project Manager
    public static void changeAssignToValueToProjectManager(List<Task> 
    lstNewTasksCreated)
    {
        Map<Id, Id> mapRelatedDeliverables = new Map<Id, Id>();
        Map<Id, Id> mapProjectManagers = new Map<Id, Id>();
        
        for(Task oTaskVar : lstNewTasksCreated)
        {
            if(oTaskVar.Status <> System.Label.Cancelled && oTaskVar.Subject 
            == System.Label.Task_Subject)
            {
                mapRelatedDeliverables.put(oTaskVar.Id, oTaskVar.WhatId);
            }
        }
        
        if(mapRelatedDeliverables <> null)
        {
            List<Deliverable__c> lstDeliverables = [select id,
            Campaign__r.Project_Manager__c from Deliverable__c where
            id in :mapRelatedDeliverables.values()];
            if(lstDeliverables <> null && lstDeliverables.size() > 0)
            {
                for(Task oTaskVar: lstNewTasksCreated)
                {
                    for(Deliverable__c oDeliverableVar : lstDeliverables)
                    {
                        if(oDeliverableVar.Campaign__r.Project_Manager__c <> 
                        null && mapRelatedDeliverables.get(oTaskVar.id)
                        == oDeliverableVar.id)
                        {
                            mapProjectManagers.put(oTaskVar.id, 
                            oDeliverableVar.Campaign__r.Project_Manager__c); 
                        }
                    } 
                }
                
                if(mapProjectManagers <> null)
                {
                    
                    for(Task oTaskVar : lstNewTasksCreated)
                    {
                        if(mapProjectManagers.get(oTaskVar.id) <> null )
                        {
                            oTaskVar.OwnerId = 
                            mapProjectManagers.get(oTaskVar.id);                            
                        }
                        
                    }
                    
                }                
            }
        }
    }
    
    /**
    * Method name  : checkStatusDependency
    * Description  : Use this method to check for parent status dependency of 
    *                child tasks when any task status is changed.
    * Return Type  : void
    * Parameter    : List<Task> lstProvidedTasks      
    **/    
    public static void checkStatusDependency(List<Task> lstProvidedTasks)
    {
        List<DeliverableBasedTaskList__c> lstTasks = 
        new List<DeliverableBasedTaskList__c>();
        List<Task> lstFinalChild = new List<Task>();
        List<Id> lstIds = new List<Id>();
        List<String> lstParents = new List<String>();
        Set<id> setParentIds = new Set<id>();
        List<String> lstChildType = new List<String>();
        String sParentRecordReference ='';
        Set<String> setRelatedTo = new Set<String>();
        List<String> lstObjectReference = new List<String>(); 
        List<String> sTaskRecurssionReference = new List<String>();          
        String sDeliverableType;
        for(Task oTaskVar: lstProvidedTasks)
        {
            if(oTaskVar.Status <> System.Label.Cancelled)
            lstIds.add(oTaskVar.Custom_Settings_Linkage__c);
            setRelatedTo.add(oTaskVar.WhatId);
            sDeliverableType = oTaskVar.Task_Type__c;
            sTaskRecurssionReference.add(oTaskVar.Related_Object_Reference__c);
        }
        if(lstIds.size() > 0){
       
        lstTasks = [select id, Assigned_To__c, Object_Name__c, Dependency__c,
        Order__c, Priority__c, Status__c, Subject__c, Type__c from
        DeliverableBasedTaskList__c where id in :lstIds and 
        Dependency__c <> null];
      
        if(lstTasks.size() > 0)
        {
            for(DeliverableBasedTaskList__c oDeliverableTaksVar: lstTasks)
            {
                if(oDeliverableTaksVar.Dependency__c.contains
                (System.Label.Dependent_Tasks_Split_Parameter))
                {
                    List<String> lstOrders = oDeliverableTaksVar.Dependency__c
                    .split(System.Label.Dependent_Tasks_Split_Parameter);
                    for(String sRetrievedListVar: lstOrders)
                    {
                        lstParents.add(sRetrievedListVar);
                    }
                }
                else
                {
                    lstParents.add(oDeliverableTaksVar.Dependency__c);
                }
                for(Task oTaskVar: lstProvidedTasks)
                {
                    if(oTaskVar.Custom_Settings_Linkage__c ==
                    oDeliverableTaksVar.id)
                    {
                        lstFinalChild.add(oTaskVar);
                    }
                }
                
            }
            List<DeliverableBasedTaskList__c> lstParentTaskDetails = [select id,
            Object_Name__c from DeliverableBasedTaskList__c where Order__c
            in :lstParents];
            
           
            
            for(DeliverableBasedTaskList__c oParentIdsReference: 
            lstParentTaskDetails)
            {
                setParentIds.add(oParentIdsReference.id);
            }            
           
            
            List<Task> lstParentTaskStatus = [select id, 
            Related_Object_Reference__c, Status,Subject, WhatId from Task where
            WhatId in :setRelatedTo and Related_Object_Reference__c
            in :sTaskRecurssionReference and Custom_Settings_Linkage__c 
            in :setParentIds];
           
            Set<Task> setInvalidTaskStatus = new Set<Task>();
            
            Set<String> lstOfIds = new Set<String>();
            
            for(Id IdAvailableVar: lstIds)
            {
                lstOfIds.add(String.valueOf(IdAvailableVar));
            }
            
            for(Task oTaskVar: lstParentTaskStatus)
            {
                if(oTaskVar.Status <> System.Label.Completed && 
                setRelatedTo.contains(oTaskVar.WhatId))
                {
                    sParentRecordReference = sParentRecordReference + '  ' 
                + '<a href="/'+ oTaskVar.id +'">'+ oTaskVar.Subject + '</a>';
                }               
                
            }
            
            Set<Task> updateTaskList = new Set<Task>();
            if(lstFinalChild.size() > 0)
            {
                for(Task oCurrentTaskVar: lstFinalChild)
                {
                    for(Task oTaskVar: lstParentTaskStatus)
                    {                       
//Apurva - Incident INC0065337 added check oCurrentTaskVar.WhatId <> oTaskVar.WhatId &&         
                        if(oCurrentTaskVar.WhatId <> oTaskVar.WhatId &&
                        oCurrentTaskVar.WhatId == oTaskVar.WhatId &&
                        oCurrentTaskVar.Related_Object_Reference__c == 
                        oTaskVar.Related_Object_Reference__c &&
                        oCurrentTaskVar.Status <> 
                        System.Label.Task_Status_NotAvailable && 
                        oTaskVar.Status <> System.Label.Completed && 
                        oTaskVar.Status <>System.Label.Cancelled && 
                        oCurrentTaskVar.Status <> System.Label.Cancelled 
                        && lstOfIds.contains(oCurrentTaskVar
                        .Custom_Settings_Linkage__c))
                        {
                  oCurrentTaskVar.addError(System.Label.Child_Task_Validation + 
                          sParentRecordReference, false);
                            
                        }   
                    }                  
                    
                }
            }
            } 
            
        }   
    }
}