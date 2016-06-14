/*****************************************************************************************
    Name             : DeliverableTrigger_Test
    Description      : Test class to cover scenario of Deliverable Trigger           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
    @isTest(seeAllData=true)
    private class DeliverableTrigger_Test 
    {
        // Create Test Data
    
            private static List<Deliverable__c> createTestData()
        {     
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();      
        
        List<Deliverable__c >  listDeliverable = new List<Deliverable__c >();    
        User user = new User();
        user.Username= 'testuserededtest@test.com';
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
        system.assertEquals('testuserededtest@test.com',user.Username);
        
        Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),Name='Test Event',Launch_Date__c = System.today(),Status='Draft',ownerId=user.Id);
        insert campaignTestVar;
        system.assertEquals('Test Event',campaignTestVar.Name);
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        insert Agency;
        system.assertEquals('Test',Agency.Name);
        
        //Shanu- Changes made for COR0001562
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Type__c = 'Email',Name='Deliverable1',Status__c='Confirmed',Assigned_To__c = user.id,Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
        Deliverable__c deliverableTest2=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id, Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
        Deliverable__c deliverableTest3=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
        listDeliverable.add(deliverableTest1);
        listDeliverable.add(deliverableTest2);
        listDeliverable.add(deliverableTest3);
        
        return listDeliverable;        
    }
    private static List<Deliverable__c> createTestData2()
        {     
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();      
        
        List<Deliverable__c >  listDeliverable = new List<Deliverable__c >();    
        User user = new User();
        user.Username= 'testuserqwqwtest@test.com';
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
        system.assertEquals('testuserqwqwtest@test.com',user.Username);
        
        Campaign campaignTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),Name='Test Event',Launch_Date__c = System.today(),Status='Draft',ownerId=user.Id);
        insert campaignTestVar;
        system.assertEquals('Test Event',campaignTestVar.Name);
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        insert Agency;
        system.assertEquals('Test',Agency.Name);
        
        //Shanu- Changes made for COR0001562
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Name='Deliverable1',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
        Deliverable__c deliverableTest2=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id, Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
        Deliverable__c deliverableTest3=new Deliverable__c(Campaign__c=campaignTestVar.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Name='Deliverable2',Status__c='In Progress',Assigned_To__c = user.id,Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
        listDeliverable.add(deliverableTest1);
        listDeliverable.add(deliverableTest2);
        listDeliverable.add(deliverableTest3);
        
        return listDeliverable;        
    }
        static testmethod void Deliverable_trigger()
    {  
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    
        List<Deliverable__c>  listDeliverable = createTestData(); 
        insert listDeliverable;    //Checking insert scenarios.
        
         List<id>  listDeliverableIds= new list<id>(); 
         List<Deliverable__c>  listNewDeliverable = new list<Deliverable__c>(); 
         list<task> listTask = new list<task>();        
        
        Map<Id,Deliverable__c> oldDeliverableMap=new Map<Id,Deliverable__c>();
        Map<Id,Deliverable__c> newDeliverableMap=new Map<Id,Deliverable__c>();
        
         for(Deliverable__c dVar: listDeliverable)
        {
            oldDeliverableMap.put(dVar.id,dVar);
        }
        
        User user = new User();
        user.Username= 'testuserssstest2@test.com';
        user.Email= 'test@test.com';
        user.Lastname= 'user';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.UserPermissionsMobileUser = false;
        insert user;
        system.assertEquals('testuserssstest2@test.com',user.Username);
        
        Task task1=new task(WhatId=listDeliverable[0].Id, Status='Not Available');
        Task task2=new task(WhatId=listDeliverable[2].Id, Status='Assigned');        
        listTask.add(task1);
        listTask.add(task2);
        insert listTask;
        system.assertEquals('Assigned',task2.Status);
        
        listDeliverable[0].Status__c='Cancelled'; 
        listDeliverable[1].Status__c='Confirmed';   
        listDeliverable[1].Assigned_To__c=user.Id;
        listDeliverable[2].Status__c='Complete';
        
        listNewDeliverable.add(listDeliverable[0]);
        listNewDeliverable.add(listDeliverable[1]);
        listNewDeliverable.add(listDeliverable[2]);
        
        update listNewDeliverable;   //Checking Cancel and update assigned To scenario.
        system.assertEquals('Confirmed',listDeliverable[1].Status__c);               
        
         for(Deliverable__c dVar: listNewDeliverable)
         {
            listDeliverableIds.add(dVar.Id);
            newDeliverableMap.put(dVar.id,dVar);
         }
        
        List<Task> listTaskUpdated = [Select id, Status, WhatId  from Task where WhatId =:listDeliverable[2].id];
               
        List<Task> listTaskCanceledUpdated = [Select id, Status, WhatId  from Task where WhatId =:listDeliverable[0].id]; 
                       
        DeliverableTriggerHandler dtHandler = new DeliverableTriggerHandler();    //Covering constructor   
        DeliverableTriggerHandler.cancelDeliverableTask(oldDeliverableMap,newDeliverableMap);
        DeliverableTriggerHelper dtHelper = new DeliverableTriggerHelper();    //Covering constructor 
        DeliverableTriggerHelper.updateTaskAssignmentScenario(listDeliverable,listNewDeliverable);
        DeliverableTriggerHelper.cancelTask(oldDeliverableMap,newDeliverableMap);
        
        AssignPMDeliverableHelper aPMdHelper = new AssignPMDeliverableHelper();    //Covering constructor 
        
        
        test.stopTest();
    }
    
     
}