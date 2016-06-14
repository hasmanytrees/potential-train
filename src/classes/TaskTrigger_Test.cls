/*****************************************************************************************
    Name             : TaskTrigger_Test
    Description      : Task Trigger test class  to cover all task related trigger  and its helper class                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  30/10/2014            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class TaskTrigger_Test
    {       
    
        static testmethod void Task_trigger()
      { 
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        list<id> listId = new list<id>();
        Set<Id> deliverableId = new Set<Id>();
        List<String> listParentOrder = new List<String>();
                 
        User user = new User();
        user.Username= 'testppusertest@test.com';
        user.Email= 'test@test.com';
        user.Lastname= 'user';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.Authorized_Campaign_Owner__c=true;
        user.UserPermissionsMobileUser = true;
        insert user;
        system.assertEquals('testppusertest@test.com',user.Username);
        
        Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),Launch_Date__c = System.today(),Name='Test Event',Status='Draft',ownerId=user.Id);
        insert campaignTestVar;
        system.assertEquals('Draft',campaignTestVar.Status);
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        insert Agency;
        system.assertEquals('Test',Agency.Name);
                
        List<Deliverable__c> listDeliverable = new List<Deliverable__c>();    
    
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable1',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Override_Task_Dependency__c = false );
        Deliverable__c deliverableTest2=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id, Agency__c = Agency.id, Override_Task_Dependency__c = false );
        Deliverable__c deliverableTest3=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Override_Task_Dependency__c = false );
        listDeliverable.add(deliverableTest1);
        listDeliverable.add(deliverableTest2);
        listDeliverable.add(deliverableTest3);
        insert listDeliverable;
        test.startTest();
        system.assertEquals('In Progress',deliverableTest3.Status__c);
        system.assertEquals(Agency.id,deliverableTest2.Agency__c);
        
        deliverableId.add(listDeliverable[0].id);
        deliverableId.add(listDeliverable[1].id);
        deliverableId.add(listDeliverable[2].id);
        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '951',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '25', 
        Priority__c = 'Medium', Record_Type__c  =System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = null,Dependency__c = '23,27');
        insert dbt;
        system.assertEquals('Medium',dbt.Priority__c);
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '952', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '27', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = null,Dependency__c = '23');
        insert dbt1;
        system.assertEquals('Medium',dbt1.Priority__c);
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '953', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '23', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary New Estimates', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt2;
        system.assertEquals('Medium',dbt2.Priority__c);        
        
        list<DeliverableBasedTaskList__c> listCS = new list<DeliverableBasedTaskList__c>();
        listCS.add(dbt);
        listCS.add(dbt1);
        listCS.add(dbt2);
        
         for(DeliverableBasedTaskList__c d: listCS)
        {
            listParentOrder.add('%'+d.Order__c+'%');
        }
               
       
        list<task> listTask = new list<task>();        
        Task task1=new task(OwnerId=user.id, WhatId=listDeliverable[0].Id, Status='Assigned',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt2.id);
        Task task2=new task(OwnerId=user.id, WhatId=listDeliverable[0].Id, Status='Not Available',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt1.id);  
        Task task3=new task(OwnerId=user.id, WhatId=listDeliverable[0].Id, Status='Not Available',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt.id);        
        listTask.add(task1);
        listTask.add(task2);
        listTask.add(task3);
        insert listTask;
        
        listId.add(listTask[1].Custom_Settings_Linkage__c);
        listId.add(listTask[2].Custom_Settings_Linkage__c);
        
        task1.Status = 'Completed';
         update task1;
         
         task2.Status = 'Completed';
         update task2;
         system.assertEquals('Completed',task2.Status);
         
         Deliverable__c deliverableTest10=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable10',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Override_Task_Dependency__c = false );
         if(deliverableTest10!=null)
             insert deliverableTest10;
         Task oTask1=new task(OwnerId=user.id, WhatId=deliverableTest10.Id, Status='Assigned',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt2.id);
         if(oTask1!=null){
             insert oTask1;
         List<Task> lstTask2= new List<Task>();
         lstTask2.add(oTask1);
         if(lstTask2.size()>0){
             for(Task t: lstTask2){
             
                 t.status = 'Completed';
             }
             update lstTask2;
             TaskTriggerHandler tth2 = new TaskTriggerHandler();
             TaskTriggerHandler.completeDeliverables(lstTask2);
         }
        }       
        Task oTask2 = new task(OwnerId=user.id, WhatId=deliverableTest10.Id, Status='Assigned',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt2.id, Subject = System.Label.Task_Subject);
        if(oTask2!=null){
            insert oTask2;
        }
        
        TaskTriggerHandler tth = new TaskTriggerHandler();
        //TaskTriggerHandler.changeDeliverableStatusToComplete(listTask);
        TaskTriggerHandler.completeDeliverables(listTask);
        TaskTriggerHandler.changeDeliverableStatusToConfirmed(listTask);
        TaskTriggerHandler.changeDeliverableStatus(listTask);
        test.stopTest();
        }
        
        static testmethod void Task_trigger2()
      { 
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        list<id> listId = new list<id>();
        Set<Id> deliverableId = new Set<Id>();
        List<String> listParentOrder = new List<String>();
                 
        User user = new User();
        user.Username= 'testttusertest@test.com';
        user.Email= 'test@test.com';
        user.Lastname= 'user';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.Authorized_Campaign_Owner__c=true;
        user.UserPermissionsMobileUser = true;
        insert user;
        system.assertEquals('testttusertest@test.com',user.userName);
        
        Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),Launch_Date__c = System.today(),Name='Test Event',Status='Draft',ownerId=user.Id);
        insert campaignTestVar;
        system.assertEquals('Draft',campaignTestVar.Status);
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        insert Agency;
        system.assertEquals('Test',Agency.Name);
                
        List<Deliverable__c> listDeliverable = new List<Deliverable__c>();    
    
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable1',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Override_Task_Dependency__c = false );
        Deliverable__c deliverableTest2=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id, Agency__c = Agency.id, Override_Task_Dependency__c = false );
        Deliverable__c deliverableTest3=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Override_Task_Dependency__c = false );
        listDeliverable.add(deliverableTest1);
        listDeliverable.add(deliverableTest2);
        listDeliverable.add(deliverableTest3);
        insert listDeliverable;
        
        system.assertEquals('In Progress',deliverableTest1.Status__c);        
                
        deliverableId.add(listDeliverable[0].id);
        deliverableId.add(listDeliverable[1].id);
        deliverableId.add(listDeliverable[2].id);
        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '951',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '25', 
        Priority__c = 'Medium', Record_Type__c  =System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = null,Dependency__c = '23,27');
        insert dbt;
        
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '952', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '27', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = null,Dependency__c = '23');
        insert dbt1;
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '953', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '23', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary New Estimates', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt2;
        
        system.assertEquals('Medium',dbt.Priority__c);
        system.assertEquals('Medium',dbt1.Priority__c);
        system.assertEquals('Medium',dbt2.Priority__c );        
        
        list<DeliverableBasedTaskList__c> listCS = new list<DeliverableBasedTaskList__c>();
        listCS.add(dbt);
        listCS.add(dbt1);
        listCS.add(dbt2);
        
         for(DeliverableBasedTaskList__c d: listCS)
        {
            listParentOrder.add('%'+d.Order__c+'%');
        }
               
       
        list<task> listTask = new list<task>();        
        Task task1=new task(OwnerId=user.id, WhatId=deliverableTest1.Id, Status='Completed',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt2.id);
        Task task2=new task(OwnerId=user.id, WhatId=deliverableTest1.Id, Status='Completed',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt1.id);  
        Task task3=new task(OwnerId=user.id, WhatId=deliverableTest1.Id, Status='Completed',Related_Object_Reference__c = '1234',Custom_Settings_Linkage__c = dbt.id);        
        listTask.add(task1);
        listTask.add(task2);
        listTask.add(task3);
        insert listTask;
        task1.Status = 'Assigned';
        update task1;
        system.assertEquals('Assigned',task1.Status);
        listId.add(listTask[1].Custom_Settings_Linkage__c);
        listId.add(listTask[2].Custom_Settings_Linkage__c);
        
        deliverableTest1.Status__c = 'Complete';
        update deliverableTest1;
        system.assertEquals('Complete',deliverableTest1.Status__c);
        
        TaskTriggerHandler tth = new TaskTriggerHandler();
        //TaskTriggerHandler.changeDeliverableStatusToComplete(listTask);
        TaskTriggerHandler.completeDeliverables(listTask);
        TaskTriggerHandler.changeDeliverableStatusToConfirmed(listTask);
        TaskTriggerHandler.changeDeliverableStatus(listTask);
        Task taskX=new task(OwnerId=user.id, WhatId=deliverableTest1.Id, Status='Completed',Related_Object_Reference__c = '1234',Subject='Change status to "In Progress" once project has started');
        insert taskX;
        test.stopTest();
        }
    }