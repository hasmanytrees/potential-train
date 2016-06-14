/*******************************************************************************
    Name             : DeliverableTrigger
    Description      : Main Trigger to handle multiple scenario in Deliverable                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
*******************************************************************************/

trigger DeliverableTrigger on Deliverable__c (after insert,after update,
before insert,before update) {
    List<Deliverable__c> lstFinalNewDeliverable = new List<Deliverable__c>();
    List<Deliverable__c> lstFinalOldDeliverable = new List<Deliverable__c>();
    Map<Id, Deliverable__c> mapNewDeliverable = new Map<Id, Deliverable__c>();
    
    if((Trigger.isBefore)&&(!Utility.bDeliverableStopCancel)){
        
        for(Deliverable__c oDeliverNew: Trigger.New){
            if(oDeliverNew.Status__c <> System.label.Cancelled)
            {
                lstFinalNewDeliverable.add(oDeliverNew);
                mapNewDeliverable.put(oDeliverNew.id, oDeliverNew);
            }
        }
        
        if(lstFinalNewDeliverable.size() > 0 &&
        (Trigger_Methods_Activation__c.getInstance('assignPM').
        Is_Trigger_Method_Required_In_Insert__c ||
        Trigger_Methods_Activation__c.getInstance
        ('assignPM').Is_Trigger_Method_Required_In_Update__c)){
            DeliverableTriggerHandler.assignPM(lstFinalNewDeliverable); 
            // Calling Handler method to assign PM and Campaign Owner field 
            //on Deliverable Object
        }
        
        if(lstFinalNewDeliverable.size() > 0 && 
        (Trigger_Methods_Activation__c.getInstance('assignOwner').
        Is_Trigger_Method_Required_In_Insert__c || 
        Trigger_Methods_Activation__c.getInstance('assignOwner').
        Is_Trigger_Method_Required_In_Update__c))
        DeliverableTriggerHandler.assignOwner
        (Trigger.oldMap,mapNewDeliverable,lstFinalNewDeliverable); 
        
    }
    if(Trigger.isAfter)
    {
        List<Deliverable__c > lstFinalNewUpdateTaskDeliverable = 
        new List<Deliverable__c>();
        
        if(Trigger.isUpdate)
        {
            
          if(!Utility.bDeliverableStopCancel){   
            for(Deliverable__c oDeliverNew: Trigger.New)
            {
                if(oDeliverNew.Status__c <> System.label.Cancelled)
                {
                    lstFinalNewUpdateTaskDeliverable.add(oDeliverNew);
                }
            }
            if(lstFinalNewUpdateTaskDeliverable.size() > 0)
            {
            if(!Trigger.IsDelete){
        
          if(Trigger.isUpdate && Trigger_Methods_Activation__c.getInstance
          ('shareUnshareDeliverable').Is_Trigger_Method_Required_In_Update__c)
            DeliverableTriggerHandler.shareUnshareDeliverable(Trigger.newMap,
            Trigger.OldMap,Trigger.New,Trigger.isUpdate);
          
        }
            if(lstFinalNewUpdateTaskDeliverable.size() > 0 && 
            Trigger_Methods_Activation__c.getInstance
            ('updateDeliverableTask').Is_Trigger_Method_Required_In_Update__c)
            {
                DeliverableTriggerHandler.updateDeliverableTask
                (lstFinalNewUpdateTaskDeliverable); 
                //Calling handler class to handle update in task based on deliverable 
            }
            //else if(Trigger_Methods_Activation__c.getInstance
            //('cancelDeliverableTask').Is_Trigger_Method_Required_In_Update__c)
            //{
                //DeliverableTriggerHandler.cancelDeliverableTask(
                //Trigger.oldMap,Trigger.newMap);
            //}
            DeliverableTriggerHandler.createDeliverableTask(Trigger.New);
            }
           }
            DeliverableTriggerHandler.cancelDeliverableTask(Trigger.oldMap,
            Trigger.newMap);
        }

        if(Trigger.isInsert && Trigger_Methods_Activation__c.getInstance
        ('createDeliverableTask').Is_Trigger_Method_Required_In_Insert__c)
        {
           if(!Utility.bDeliverableStopCancel){
            DeliverableTriggerHandler.createDeliverableTask(Trigger.New);
            //Calling Handler class to create task on creation of deliverable.
            }
        }
        if(Trigger.IsInsert && Trigger_Methods_Activation__c.getInstance
        ('shareUnshareDeliverable').Is_Trigger_Method_Required_In_Insert__c)
            DeliverableTriggerHandler.shareUnshareDeliverable
            (Trigger.newMap,Trigger.OldMap,Trigger.New,Trigger.isUpdate);
        
    }


}