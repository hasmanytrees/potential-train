public with sharing class DependentTaskLinksExtension
{
    /**************************************************************************
    Name             : DependentTaskLinksExtension
    Description      : Class used to handle retrieving and rendering of Parent 
                      and Child Task rekated Scenarios .                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer         Date              Description
    ---------------------------------------------------------------------------
    Subhojit          30/10/2014         Created
    Subhojit          29/01/2015         Modified for code re-factoring & 
                                         optimization
    ************************************************************************
    */
    
    //Class variables defined for used either across the controller or in the 
    //page when being displayed in the List .
    public String sShowParentTasks{get;set;}
    Id TaskId;
    public List<Task> lstFinalTask{get;set;}
    public List<Task> lstFinalParentTask{get;set;}
    private Id lstRefernceId;
    public boolean bShowTable{get;set;}
    public boolean bAnotherShowTable{get;set;}
    
    /**
    * Method name  : Constructor(Parametrized)
    * Description  :This method is paramterized constrictor for taking in the 
    *                standard id value and reteieving the data.
    * Return Type  : void
    * Parameter    : Standard Constructor Reference
    **/   
    public DependentTaskLinksExtension(ApexPages.StandardController controller) 
    {
        TaskId=controller.getID();
        lstFinalTask=new List<Task>();
        lstFinalParentTask = new List<Task>();
        bShowTable=false;
        bAnotherShowTable=false;
        getDependentTask();
        getParentTask();
    }
    
    /**
    * Method name  : getParentTask
    * Description  : This method is used for retrieving the Parent taks list
    *                related to it or display proper user friendly info on the 
                     page.
    * Return Type  : void
    * Parameter    : void
    **/ 
    private void getParentTask()
    {
        Task oTaskVar=new Task();
        oTaskVar = [select WhatId, Related_Object_Reference__c, 
        Custom_Settings_Linkage__c from Task where id = :TaskId];
        
        //retrieving the Task relevant details and retrieving the corresponding 
        //Custom Setting data for the same.
        if(oTaskVar !=null)
        {
         String sChildTaskDeliverable = oTaskVar.Custom_Settings_Linkage__c;
         String sTaskRecurssionReference = oTaskVar.Related_Object_Reference__c;
            lstRefernceId = oTaskVar.WhatId;
            DeliverableBasedTaskList__c oDeliverableTaskVar = 
            new DeliverableBasedTaskList__c();
            try{
                oDeliverableTaskVar =[select Dependency__c from 
                DeliverableBasedTaskList__c where id = :sChildTaskDeliverable];
            }
            catch(Exception ex){
            
                bAnotherShowTable=false;                
            }
            
            //Condition to check if parent is presrnt then proceed to retireve 
            //them and show it on the page.
            if(oDeliverableTaskVar <> null)
            {
                List<String> lstParentOrdered = new List<String>();
                if(oDeliverableTaskVar.Dependency__c <> null && 
                oDeliverableTaskVar.Dependency__c.contains(','))
                {
                lstParentOrdered = oDeliverableTaskVar.Dependency__c.split(',');
                }
                else
                {
                    lstParentOrdered.add(oDeliverableTaskVar.Dependency__c);
                }
                List<DeliverableBasedTaskList__c> lstMainParent = 
                new List<DeliverableBasedTaskList__c>();
                lstMainParent = [select id from DeliverableBasedTaskList__c
                where Order__c in :lstParentOrdered];

                if(lstMainParent <> null && lstMainParent.size() > 0)
                {
                    List<Id> lstParentIds = new List<Id>();
                    
                    
                    for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
                    lstMainParent)
                    {
                        lstParentIds.add(oDeliverableTaskLstVar.id);
                        
                    }
                    //This identifies the final parent list which has to be 
                    //displayed to the task detail page.
                    lstFinalParentTask = [select id, Subject, Status, 
                    Owner_Name__c, Due_Date_Indicator__c, ActivityDate  from
                    Task where Related_Object_Reference__c
                    = :sTaskRecurssionReference and Custom_Settings_Linkage__c 
                    in :lstParentIds and WhatId = :lstRefernceId];
                    bAnotherShowTable=true;
                }
                
                //Condition which is executed to display no Parent Task and 
                //display suitable page message to the User.
                else
                {    
                    bAnotherShowTable=false;
                    ApexPages.addMessage(new
                    ApexPages.Message(ApexPages.Severity.INFO,
                    System.label.NoParentTaskFound));
                }
            }
        }
        //Condition which checks additional error scenario and is executed to 
        //display no Parent Task and display suitable page message to the User.
        else
        {
            bAnotherShowTable=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.NoParentTaskFound));
            
        }  
        
    }
    
    /**
    * Method name  : getDependentTask
    * Description  : This method is used for retrieving the Child taks list 
    *                related to it or display proper user friendly info on the 
    *                page.
    * Return Type  : void
    * Parameter    : void
    **/ 
    private void getDependentTask(){

        Task oTaskVar=new Task();
        oTaskVar = [select WhatId, Related_Object_Reference__c,
        Custom_Settings_Linkage__c from Task where id = :TaskId];
        if(oTaskVar.Custom_Settings_Linkage__c!=null)
        {
         String sParentTaskDeliverable = oTaskVar.Custom_Settings_Linkage__c;
         String sTaskRecurssionReference = oTaskVar.Related_Object_Reference__c;
         lstRefernceId = oTaskVar.WhatId;
         DeliverableBasedTaskList__c oDeliverableTaskVar = [select Order__c 
         from DeliverableBasedTaskList__c where id = :sParentTaskDeliverable];
            
            //Condition to check if related child is present then proceed to 
            //retrieve them and show it on the page.
            if(oDeliverableTaskVar <> null)
            {
                String sParentOrder = oDeliverableTaskVar.Order__c;
                String sFindValue = '%' + sParentOrder + '%';
              List<DeliverableBasedTaskList__c> lstDependent = [select id from 
              DeliverableBasedTaskList__c where Dependency__c like :sFindValue];

                if(lstDependent.size() > 0)
                {
                    List<Id> lstDependentIds = new List<Id>();                    
                    
                    for(DeliverableBasedTaskList__c oDeliverableTaskLstVar: 
                    lstDependent)
                    {
                        lstDependentIds.add(oDeliverableTaskLstVar.id);
                        
                    }
                    
                    lstFinalTask = [select id, Subject, Status, Owner_Name__c,
                    Due_Date_Indicator__c, ActivityDate  from Task where
                    Related_Object_Reference__c = :sTaskRecurssionReference and 
                    Custom_Settings_Linkage__c in :lstDependentIds and WhatId
                    = :lstRefernceId];
                    if(lstFinalTask.size() > 0)
                    {
                        bShowTable=true;
                    }
                    
                    //Condition which is executed to display no Child Task and 
                    //display suitable page message to the User.
                    else
                    {
                        bShowTable=false;
                        ApexPages.addMessage(new 
                        ApexPages.Message(ApexPages.Severity.INFO,
                        System.label.NoDependentTaskFound));
                    }
                    
                }
      //Condition which checks additional error scenario and is executed to 
      //display no Parent Task and display suitable page message to the User.
                else
                {    
                    bShowTable=false;
                    ApexPages.addMessage(new ApexPages.Message
                  (ApexPages.Severity.INFO,System.label.NoDependentTaskFound));
                }
            }
        }
        //Condition which checks id this task has been created manually or is 
        //not linked to any Object the  the corresponding message is displayed 
        //on it.
        else
        {
            bShowTable=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.NoDependentTaskFound));
            
        }  

    } 

    
}