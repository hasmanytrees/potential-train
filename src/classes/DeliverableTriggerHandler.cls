/*****************************************************************************************
    Name             : DeliverableTriggerHandler
    Description      : Trigger Helper class used to handle multiple scenario of Deliverable .                   
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
Shanu                   15/09/2015            Changes made for COR0001562
******************************************************************************************/

public without sharing class DeliverableTriggerHandler
{
    /**
    * Method name  : cancelDeliverableTask
    * Description  :This method is initiate helper class to cancel Deliverable Tasks
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Deliverable__c>,Map<Id,Deliverable__c>
    **/   
    public static void cancelDeliverableTask(Map<Id,Deliverable__c> mapOldDeliverable,Map<Id,Deliverable__c>mapNewDeliverable)
    {
        if(mapOldDeliverable!=null)
        {
            DeliverableTriggerHelper.cancelTask(mapOldDeliverable,mapNewDeliverable);
        }
    }
    /**
    * Method name  : updateDeliverableTask
    * Description  :This method is used to call helper class for updating task based on Deliverable Status and other related task on Campaign
    *                
    * Return Type  : void
    * Parameter    : List<Deliverable__c>
    **/  
    public static void updateDeliverableTask(List<Deliverable__c> lstNewDeliverable)
    {
        //September-2015 Shanu- Changes made for COR0001562
        List<Deliverable__c> lstUpdatedNewDeliverable=new List<Deliverable__c>();
        
        for(Deliverable__c deliverableRecordVar: lstNewDeliverable)
        {
            if(deliverableRecordVar.Do_Not_Auto_Populate_Tasks__c == FALSE)
            {
                lstUpdatedNewDeliverable.add(deliverableRecordVar);  
            }
        }
        System.debug('DeliverableTriggerHandler updateDeliverableTask' + lstUpdatedNewDeliverable);
        if(lstUpdatedNewDeliverable.size()>0)
        {
            CampaignTriggerHelper reference = new CampaignTriggerHelper();
            reference.taskAssignment(lstUpdatedNewDeliverable, 'Update');
        }
    }
    
    /**
    * Method name  : createDeliverableTask
    * Description  :This method is used to call helper class for creating Deliverable Task and Assigned to related person based on condition
    *                
    * Return Type  : List<Deliverable__c>
    * Parameter    : void
    **/  
    
    public static void createDeliverableTask(List<Deliverable__c> lstNewDeliverable)
    {
        //September-2015 Shanu- Changes made for COR0001562
        List<Deliverable__c> lstUpdatedNewDeliverable=new List<Deliverable__c>();
        
        for(Deliverable__c deliverableRecordVar: lstNewDeliverable)
        {
            if(!deliverableRecordVar.Do_Not_Auto_Populate_Tasks__c)
            {
                lstUpdatedNewDeliverable.add(deliverableRecordVar);  
            }
        }
        System.debug('DeliverableTriggerHandler createDeliverableTask' + lstUpdatedNewDeliverable);
        if(lstUpdatedNewDeliverable.size()>0)
        {
            CampaignTriggerHelper reference = new CampaignTriggerHelper();
            reference.taskAssignment(lstUpdatedNewDeliverable, 'Insert');
        }
    }
    
    /**
    * Method name  : assignPM
    * Description  :This method is used to call Helper class to Assign PM from Campaign
    *                
    * Return Type  : List<Deliverable__c>
    * Parameter    : void
    **/   

    public static void assignPM(List<Deliverable__c> lstDeliverable){

        Id recordtypeId=Utility.getRecordType(System.label.CampaignDeliverable,System.Label.Deliverable_Object);

        List<Deliverable__c> lstDeliverableFinal=new   List<Deliverable__c>();
        
        for(Deliverable__c oDeliverableVar: lstDeliverable){
            //This functionality only work for Campaign Deliverable type.
            if(oDeliverableVar.recordtypeId==recordtypeId){
                lstDeliverableFinal.add(oDeliverableVar);               
                
            }
            
        }

        if(lstDeliverableFinal.size()>0)
        AssignPMDeliverableHelper.assignPM(lstDeliverableFinal);

    }
    /**
    * Method name  : assignOwner
    * Description  :This method is used for calling helper class to Assign Owner as same as Deliverable Assigned To
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Deliverable__c>,Map<Id,Deliverable__c>,List<Deliverable__c>
    **/ 
    public static void assignOwner(Map<Id,Deliverable__c> mapOldDeliverable,Map<Id,Deliverable__c> mapNewDeliverable,List<Deliverable__c> lstNewDeliverable){

        List<Deliverable__c> lstfinalDeliverable=new List<Deliverable__c>();
        if(mapOldDeliverable==null)
        lstfinalDeliverable.addAll(lstNewDeliverable);
        else{
            for(Deliverable__c oDelievrableVar:mapNewDeliverable.Values()){
                
                //Checking is Assigned To is changed for Deliverable
                if((mapNewDeliverable.get(oDelievrableVar.Id).Assigned_To__c!=mapOldDeliverable.get(oDelievrableVar.Id).Assigned_To__c)&&(oDelievrableVar.Assigned_To__c!=null))
                lstfinalDeliverable.add(mapNewDeliverable.get(oDelievrableVar.Id));
            }
        } 
        if(lstfinalDeliverable.size()>0)
        DeliverableTriggerHelper.assignOwner(lstfinalDeliverable);

    }
    /**
    * Method name  : shareUnshareDeliverable
    * Description  :This method is used to share Deliverable and related campaign with Agency user
    *                
    * Return Type  : void
    * Parameter    : Map<Id,Deliverable__c>,Map<Id,Deliverable__c>,List<Deliverable__c>,boolean
    **/ 
    public static void shareUnshareDeliverable(Map<Id,Deliverable__c> mapNewDeliverable,Map<Id,Deliverable__c> mapOldDeliverable,List<Deliverable__c> lstNewDeliverable,boolean bIsUpdate){

        List<Deliverable__c> lstDelieverable=new List<Deliverable__c>();
        Set<Id> setCampaignId=new Set<Id>();
        Set<Id> setCampaignIdInsert=new Set<Id>();
        Id recorTypeId=Utility.getRecordtype(System.label.CampaignDeliverable,System.label.Deliverable_Object);
        
        if(!bIsUpdate){            
            //For insert scenario
            for(Deliverable__c oDeliverableVar: lstNewDeliverable){
                //Getting list of deliverable which has agency
                if((oDeliverableVar.recordtypeId==recorTypeId)&&(oDeliverableVar.Agency__c!=null))
                lstDelieverable.add(oDeliverableVar);                
            } 
            //Getting related Campaign Ids
            for(Deliverable__c oDeliverableVar: [select Id,Campaign__c,Campaign__r.Agency__c,Agency__c from Deliverable__C where Id IN :mapNewDeliverable.keySet()]){
                setCampaignId.add(oDeliverableVar.campaign__c);                
            }
            if( lstDelieverable.size()>0) 
            ShareUnshareHelper.shareUnshareDeliverable(lstDelieverable,setCampaignId,true);          
        }
        else{
            //For Update Scenario
            for(Id deliverableVarId: mapOldDeliverable.keySet()){
                //Checking if Agency field is changed.
                if((mapnewDeliverable.get(deliverableVarId).Agency__c!=mapOldDeliverable.get(deliverableVarId).Agency__c)&&(mapnewDeliverable.get(deliverableVarId).recordtypeId==recorTypeId))
                lstDelieverable.add(mapnewDeliverable.get(deliverableVarId));
                
            }
            for(Deliverable__c oDeliverableVar: [select Id,Campaign__c,Campaign__r.Agency__c,Agency__c from Deliverable__C where Id IN :mapNewDeliverable.keySet()]){
                if(oDeliverableVar.campaign__r.Agency__c!=mapOldDeliverable.get(oDeliverableVar.Id).Agency__c)
                setCampaignId.add(oDeliverableVar.campaign__c);
                
                setCampaignIdInsert.add(oDeliverableVar.campaign__c);
            }
            
            //Calling Helper classes to share/unShare Deliverable and Agency
            if(lstDelieverable.size()>0){
                ShareUnshareHelper.shareUnshareDeliverable(mapOldDeliverable.values(),setCampaignId,false);
                ShareUnshareHelper.shareUnshareDeliverable(lstDelieverable,setCampaignIdInsert,true);
            }
            
            
            
        }   

    }   
}