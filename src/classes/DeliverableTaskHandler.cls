/************************************************************************
    Name             : DeliverableTaskHandler
    Description      : Helper class used to handle task related scenario of 
                       Deliverable .                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit               30/10/2014        Created
    Subhojit               29/01/2015        Modified for code re-factoring & 
                                             optimization
    ************************************************************************
    */
public without Sharing class DeliverableTaskHandler
{

    
    /**
    * Method name  : cancelTask
    * Description  :This method is initiate cancellation of all related tasks 
    *               once the cancellation of deliverbale is made. 
    * Return Type  : void
    * Parameter    : Map<Id,Deliverable__c> oldDeliverableMap,Map<Id,
                        Deliverable__c>newDeliverableMap
    **/ 

    public static void cancelTask(Map<Id,Deliverable__c>
    mapOldDeliverable,Map<Id,Deliverable__c> mapNewDeliverable){
        
        Set<Id> setDeliverableId=new Set<Id>();
        
    //Loop is executed which retrives all deliverables whose status has been
    //made as canmcelled or the canceelation tasks has to be created.
        for(Id deliverableIdVar: mapOldDeliverable.keySet()){
            
            if((mapOldDeliverable.get(deliverableIdVar).Status__c!= 
            mapNewDeliverable.get(deliverableIdVar).Status__c)&&
            (mapNewDeliverable.get(deliverableIdVar).Status__c==
            System.label.Cancelled))
            setDeliverableId.add(deliverableIdVar);
        }
        
        List<Task> lstTasks=new List<Task>();
        
        //SOQL to retirieve all tasks which are related to the corresponding 
        //deliverable.
      lstTasks = [select Id,Status from Task where whatId IN :setdeliverableId];
        
        for(Task oTaskVar:  lstTasks)
        oTaskVar.Status=System.label.Cancelled;
        
 //Finally the tasks are updated with current cancelled status into the database
        try{
            update lstTasks;
        }
        catch(Exception ex){
            
          
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'Deliverable__c',String.valueOf
            (mapNewDeliverable.keyset()),'DeliverableTaskHandler','cancelTask',
            'Application',UserInfo.getUserId(), String.valueOf
            (mapNewDeliverable.values()),
            String.valueOf(mapOldDeliverable.values()));
            
        }
        
    }

}