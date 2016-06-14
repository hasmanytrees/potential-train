/*****************************************************************************************
    Name             : DependentTaskLinksExtension_Test
    Description      : Test class to cover scenario of Class used to handle retrieving and rendering of Parent and Child Task rekated Scenarios .               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Vibhuti               30/10/2014            Created
Vibhuti               29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
private class DependentTaskLinksExtension_Test
{  
    // Create Test Data
    private static Campaign createTestData(){
        //-----test data----------
        User user = new User();
        user.Username= 'testusertest5@test.com';
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
        
         System.assertEquals('test',user.Alias);
         Campaign campaignVar1=new Campaign(ownerId=user.Id,Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));
        insert campaignVar1;
        return campaignVar1;
    }
    
        static testmethod void TaskDependencyWithComma_test()
    {   
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();     
        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '999',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '23', 
        Priority__c = 'Medium', Record_Type__c  = 'Deliverable__c', Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'tooling',
        Dependency__c = '23,24');
        insert dbt;
        system.assertEquals('Medium',dbt.Priority__c);
        
        Campaign campaignTest1 = createTestData();
        Deliverable__c deliverableTest1=new Deliverable__c(RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
                                                    Name='Deliverable1',Status__c='In Progress', Campaign__c = campaignTest1.id);
        insert deliverableTest1;
        system.assertEquals('In Progress',deliverableTest1.Status__c);
        
        Task task1=new task(WhatId=deliverableTest1.Id, Status='Not Available',Custom_Settings_Linkage__c = dbt.id );
        // Task task2=new task(WhatId=deliverableTest1.Id, Status='Not Available' );
        insert task1;
        system.assertEquals('Not Available',task1.Status);
        //  insert task2;
        
        task oTaskVar = [select WhatId, Related_Object_Reference__c, Custom_Settings_Linkage__c from Task where id = :task1.id];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(task1);
        DependentTaskLinksExtension testTask = new DependentTaskLinksExtension(sc);
        testTask.sShowParentTasks='sShowParentTasks';
        test.stopTest();
    }
    
        static testmethod void TaskTaskDependencyWithoutComma_test()
    {   
         test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '999',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7,Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = 'Deliverable__c',Status__c = 'Assigned',Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'tooling',
        Dependency__c = '23');
        insert dbt;
        system.assertEquals('Medium',dbt.Priority__c);
        
        Campaign campaignTest1 = createTestData();
        Deliverable__c deliverableTest1=new Deliverable__c(RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
                                                            Name='Deliverable1',Status__c='In Progress',Campaign__c = campaignTest1.id);
        insert deliverableTest1;
        system.assertEquals('In Progress',deliverableTest1.Status__c);
        
        Task task1=new task(WhatId=deliverableTest1.Id, Status='Not Available',Custom_Settings_Linkage__c = dbt.id );
        insert task1;
        system.assertEquals('Not Available',task1.Status);
        
        task oTaskVar = [select WhatId, Related_Object_Reference__c, Custom_Settings_Linkage__c from Task where id = :task1.id];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(task1);
        DependentTaskLinksExtension testTask = new DependentTaskLinksExtension(sc);
       // testTask.sShowParentTasks;
        test.stopTest();
    }
    
      static testmethod void TaskTaskDependency_NotCustSetLink_test()
    {   
         test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '999',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7,Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = 'Deliverable__c',Status__c = 'Assigned',Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'tooling',
        Dependency__c = '23');
        insert dbt;
        system.assertEquals('Medium',dbt.Priority__c);
        
        Campaign campaignTest1 = createTestData();
        Deliverable__c deliverableTest1=new Deliverable__c(RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
                                                            Name='Deliverable1',Status__c='In Progress', Campaign__c = campaignTest1.id);
        insert deliverableTest1;
        system.assertEquals('In Progress',deliverableTest1.Status__c);
        
        Task task1=new task(WhatId=deliverableTest1.Id, Status='Not Available');//Custom_Settings_Linkage__c = dbt.id );
        insert task1;
        system.assertEquals('Not Available',task1.Status);
        
        task oTaskVar = [select WhatId, Related_Object_Reference__c, Custom_Settings_Linkage__c from Task where id = :task1.id];
        oTaskVar = null;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(task1);
        DependentTaskLinksExtension testTask = new DependentTaskLinksExtension(sc);
       // testTask.sShowParentTasks;
        test.stopTest();
    }
    
}