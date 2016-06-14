/******************************************************************************
    Name             : TaskTrigger 
    Description      : Main Trigger to handle multiple scenario on Tasks that 
                       are created once Campaigns, Deliverables and other 
                       objects are Updated.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 30/10/2014        Created
Sumeet                 29/01/2015        Modified for code re-factoring &
                                         optimization
******************************************************************************/



trigger TaskTrigger on Task (before update,before insert, after insert, 
after update) 
{    
    Boolean bIsCancelledScenario = true;
    List<Task> lstTaskOwners = new List<Task>();
    for(Task taskVar: Trigger.new)
            {
                if(taskVar.Status <> 'Cancelled')
                {
                    bIsCancelledScenario = false;
                }
                
                if(!Utility.bIgnoreTaskOwnerChange  && Trigger.isUpdate && Trigger.oldMap <> null && Trigger.oldMap.get(taskVar.id).OwnerId <> taskVar.Ownerid)
                {
                    lstTaskOwners.add(taskVar);
                }
        else if(Trigger.isInsert && taskVar.OwnerId <> null)
        {
            lstTaskOwners.add(taskVar);
        }          
            }
    
    if(Trigger.isBefore && !bIsCancelledScenario)
    {        
        if(Trigger.isUpdate)
        {           
        
        if((Trigger_Methods_Activation__c.getInstance('checkStatusDependency')
        .Is_Trigger_Method_Required_In_Insert__c || 
        Trigger_Methods_Activation__c.getInstance('checkStatusDependency')
        .Is_Trigger_Method_Required_In_Update__c))
        {
            TaskTriggerHandler.checkStatusDependency(Trigger.New); 
        // For checking status of other tasks that is dependent on Parent tasks.
        }
        }
        if(Trigger.isInsert)
        {
            if(Trigger_Methods_Activation__c.getInstance
            ('changeAssignToValueToProjectManager')
            .Is_Trigger_Method_Required_In_Insert__c)
            TaskTriggerHandler.changeAssignToValueToProjectManager(Trigger.New);
        }      
        if(lstTaskOwners.size() > 0)
        {
            for(Task oTaskVar: lstTaskOwners)
            {
                oTaskVar.Initial_Task_Owner__c = oTaskVar.OwnerId;
            }
        }
    }
    
    if(Trigger.isAfter && !bIsCancelledScenario)
    {        
        if(Trigger.isInsert)
        {   
            if(Trigger_Methods_Activation__c.getInstance
            ('changeDeliverableStatus')
            .Is_Trigger_Method_Required_In_Insert__c)
            TaskTriggerHandler.changeDeliverableStatus(Trigger.New);
            
            if(Trigger_Methods_Activation__c.getInstance
            ('changeDeliverableStatusToConfirmed')
            .Is_Trigger_Method_Required_In_Insert__c)
            TaskTriggerHandler.changeDeliverableStatusToConfirmed(Trigger.New);
        }
        
        if(Trigger.isUpdate)
        {    
            /*if(Trigger_Methods_Activation__c
            .getInstance('changeDeliverableStatusToComplete')
            .Is_Trigger_Method_Required_In_Update__c)
            TaskTriggerHandler.changeDeliverableStatusToComplete(Trigger.New);*/
            
            if(Trigger_Methods_Activation__c.getInstance
            ('changeChildTasksToActive')
            .Is_Trigger_Method_Required_In_Update__c)
            TaskTriggerHandler.changeChildTasksToActiveOnceParentTaskIsComplete(Trigger.New, Trigger.old);
            
            if(Trigger_Methods_Activation__c.getInstance
            ('completeDeliverables').Is_Trigger_Method_Required_In_Update__c)
            TaskTriggerHandler.completeDeliverables(Trigger.New);            
        }      
       
    }
}