/*****************************************************************************************
    Name             : CampaignTriggerHelperTasks_Test
    Description      : This class is used for testing all tasks related scenarios for events and deliverables                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class CampaignTriggerHelperTasks_Test
{
    public static void createTaskList()
    {
        DeliverableBasedTaskList__c dbtl1 = new DeliverableBasedTaskList__c(Name = 'Sumeet1', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='1000' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c='Test ABC' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl1;
        
        DeliverableBasedTaskList__c dbtl2 = new DeliverableBasedTaskList__c(Name = 'Sumeet2', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,Order__c='1001' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDS' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl2;
        
        
        DeliverableBasedTaskList__c dbtl3 = new DeliverableBasedTaskList__c(Name = 'Sumeet12', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='1004' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c='Test ABCRRR' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl3;
        
        DeliverableBasedTaskList__c dbtl4 = new DeliverableBasedTaskList__c(Name = 'Sumeet21', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,Order__c='1003' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl4;
        
        DeliverableBasedTaskList__c dbtl11 = new DeliverableBasedTaskList__c(Name = 'Sumeet1234', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10001' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c='Test ABC435', Type_Values__c='Confirmed');
        
        insert dbtl11;
        
        DeliverableBasedTaskList__c dbtl21 = new DeliverableBasedTaskList__c(Name = 'Sumeet122', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10011' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDS345', Type_Values__c='Confirmed');
        
        insert dbtl21;
        
        
        DeliverableBasedTaskList__c dbtl31 = new DeliverableBasedTaskList__c(Name = 'Sumeet112', Assigned_To__c='Assigned To',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10041' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c='Test ABCRRR456', Type_Values__c='Confirmed');
        
        insert dbtl31;
        
        DeliverableBasedTaskList__c dbtl41 = new DeliverableBasedTaskList__c(Name = 'Sumeet211', Assigned_To__c='Event Specialist' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Event' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA57', Type_Values__c='Confirmed' );
        
        insert dbtl41;
        
        DeliverableBasedTaskList__c dbtl111 = new DeliverableBasedTaskList__c(Name = 'Sume1et1234', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='101001' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Notify Onsite Facilitator of Cancellation');
        
        insert dbtl111;
        
        DeliverableBasedTaskList__c dbtl121 = new DeliverableBasedTaskList__c(Name = 'Su1meet122', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='101011' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'Notify Onsite Facilitator of Cancellation' );
        
        insert dbtl121;
        
        
        DeliverableBasedTaskList__c dbtl131 = new DeliverableBasedTaskList__c(Name = '1Sumeet112', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10041' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Notify Onsite Facilitator of Cancellation' );
        
        insert dbtl131;
        
        DeliverableBasedTaskList__c dbtl411 = new DeliverableBasedTaskList__c(Name = 'Sumeet2111', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='101031' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'Notify Onsite Facilitator of Cancellation' );
        
        insert dbtl411;
        
         DeliverableBasedTaskList__c dbt511 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask', Assigned_To__c='Event Specialist',
        Due_Date_Calculated_From__c='CreatedDate' ,Due_Date_Object__c='Task' ,Due_Date_Scenario__c='Never' ,
        Due_Date_Value__c=0 ,Object_Name__c='Deliverable__c' ,Object_Type__c='Deliverable__c' ,
        Order__c='10001' ,Priority__c='Medium' ,Record_Type__c='Deliverable__c' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Event',
        Subject__c='Test ABC' ,Type__c='Type__c' ,Type_Values__c='Event Close Out');
        
        insert dbt511;
        
         DeliverableBasedTaskList__c dbt512 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask2', Assigned_To__c=System.label.Event_Specialist,
        Due_Date_Calculated_From__c='CreatedDate' ,Due_Date_Object__c='Task' ,Due_Date_Scenario__c='Never' ,
        Due_Date_Value__c=0 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='10002' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Event',
        Subject__c='Test ABC2' ,Type__c='Type__c' ,Type_Values__c='Event Close Out');
        
        insert dbt512;
        
         DeliverableBasedTaskList__c dbt513 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask3', Assigned_To__c='Campaign Event Specialist',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Never' ,
        Due_Date_Value__c=0 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='10003' ,Priority__c='Medium' ,Record_Type__c='Deliverable__c' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Event',
        Subject__c='Test ABC3' ,Type__c='Type__c' ,Type_Values__c='Digital Asset');
        
        insert dbt513;
        
        
        DeliverableBasedTaskList__c dbt514 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask4', Assigned_To__c=System.label.Event_Specialist,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Never' ,
        Due_Date_Value__c=0 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='10003' ,Priority__c='Medium' ,Record_Type__c='Deliverable__c' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Event',
        Subject__c='Test ABC3' ,Type__c='Type__c' ,Type_Values__c='Digital Asset');
        
        insert dbt514;
    }
    
    public static testmethod void testEventTasksforDeliverable()
    {
        
        createTaskList();
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event');
        insert EventTest2;
        
        User u = [select id,EVE_Specialist__c from User where alias = 'skanj'];
        
        User user6 = new User();
        user6.Username= 'testusertest66@test.com';
        user6.Email= 'test6@test.com';
        user6.Lastname= 'user';
        user6.Firstname= 'test66';
        user6.Alias= 'test';
        user6.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user6.TimeZoneSidKey= 'GMT';
        user6.LocaleSidKey= 'en_US';
        user6.Managerid = userinfo.getuserid();
        user6.EmailEncodingKey= 'ISO-8859-1';
        user6.LanguageLocaleKey= 'en_US';
        user6.Authorized_Campaign_Owner__c=true;
        user6.UserPermissionsMobileUser = true;
        u.EVE_Specialist__c = u.id;
        if(user6!=null){
            insert user6;
        }
        
        Test.startTest();
        System.runas(user6){
        Deliverable__c deliverableTest1=new Deliverable__c(Assigned_To__c=u.id,Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event Deliverable','Deliverable__c'),Type__c ='Inventory',Name='Deliverable1',Status__c='Draft',Do_Not_Auto_Populate_Tasks__c = false);
        insert deliverableTest1;
        Deliverable__c deliverableTest2=new Deliverable__c(Assigned_To__c=u.id,Event__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event Deliverable','Deliverable__c'),Type__c ='Event Close Out',Name='Deliverable2',Status__c='Draft',Do_Not_Auto_Populate_Tasks__c = false);
        insert deliverableTest2;
        Deliverable__c deliverableTest3=new Deliverable__c(Assigned_To__c=u.id,Event__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event Deliverable','Deliverable__c'),Type__c ='Digital Asset',Name='Deliverable3',Status__c='Draft',Do_Not_Auto_Populate_Tasks__c = false);
        insert deliverableTest3;
        deliverableTest1.Status__c='Confirmed';
        update deliverableTest1;
        delete [select id from Task where WhatId = :EventTest2.id];
        EventTest2.Status = 'Confirmed';
        update EventTest2;
        }
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Adak' , State__c ='Alaska', ZIP_Code__c='99546', Country__c='United States');
        insert Ven; // Initializing Venue Record
        
        Campaign eventLocTest1=new Campaign(Name='Event Location1',Cancellation_Reason__c = 'Act Of God', recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3), Volunteer_Coordinator__c = UserInfo.getUserId(), EVE_Start_Time__c = '08:00 AM', EVE_End_Time__c = '08:30 AM', status = 'Cancelled', Event__c = EventTest2.id , Venue__c = ven.id);
        insert eventLocTest1;
        delete [select id from Task where WhatId = :eventLocTest1.id];
        EventTest2.Status = 'Cancelled';
        EventTest2.Cancellation_Reason__c = 'Act Of God';
        update EventTest2;
        System.AssertEquals('Cancelled',EventTest2.Status );
        Test.stopTest();
    }
    
    
    public static void createTaskList2()
    {
        DeliverableBasedTaskList__c dbtl1 = new DeliverableBasedTaskList__c(Name = 'Sumeet1', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='1000' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Test ABC' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl1;
        
        DeliverableBasedTaskList__c dbtl2 = new DeliverableBasedTaskList__c(Name = 'Sumeet2', Assigned_To__c='Event Volunteer Coordinator' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,Order__c='1001' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDS' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl2;
        
        
        DeliverableBasedTaskList__c dbtl3 = new DeliverableBasedTaskList__c(Name = 'Sumeet12', Assigned_To__c='Marketing Web team member',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='1004' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Test ABCRRR' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl3;
        
        DeliverableBasedTaskList__c dbtl4 = new DeliverableBasedTaskList__c(Name = 'Sumeet21', Assigned_To__c='Event Specialist' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,Order__c='1003' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA' ,Type__c='Type__c' ,Type_Values__c='Inventory');
        
        insert dbtl4;
        
        DeliverableBasedTaskList__c dbtl11 = new DeliverableBasedTaskList__c(Name = 'Sumeet1234', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10001' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Test ABC435',Type_Values__c='Scheduled');
        
        insert dbtl11;
        
        DeliverableBasedTaskList__c dbtl21 = new DeliverableBasedTaskList__c(Name = 'Sumeet122', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10011' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDS345',Type_Values__c='Scheduled' );
        
        insert dbtl21;
        
        
        DeliverableBasedTaskList__c dbtl31 = new DeliverableBasedTaskList__c(Name = 'Sumeet112', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10041' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Test ABCRRR456',Type_Values__c='Scheduled' );
        
        insert dbtl31;
        
        DeliverableBasedTaskList__c dbtl41 = new DeliverableBasedTaskList__c(Name = 'Sumeet211', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA57',Type_Values__c='Scheduled' );
        
        insert dbtl41;
        
        DeliverableBasedTaskList__c dbtl111 = new DeliverableBasedTaskList__c(Name = 'Sume1et1234', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='101001' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Notify Onsite Facilitator of Cancellation');
        
        insert dbtl111;
        
        DeliverableBasedTaskList__c dbtl121 = new DeliverableBasedTaskList__c(Name = 'Su1meet122', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='101011' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'Notify Onsite Facilitator of Cancellation' );
        
        insert dbtl121;
        
        
        DeliverableBasedTaskList__c dbtl131 = new DeliverableBasedTaskList__c(Name = '1Sumeet112', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10041' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c='Notify Onsite Facilitator of Cancellation' );
        
        insert dbtl131;
        
        DeliverableBasedTaskList__c dbtl411 = new DeliverableBasedTaskList__c(Name = 'Sumeet2111', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='101031' ,Priority__c='Medium' ,Record_Type__c='Event Location' ,Status__c='Assigned' ,
        Subject__c= 'Notify Onsite Facilitator of Cancellation' );
        
        insert dbtl411;
        
         DeliverableBasedTaskList__c dbt511 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Deliverable__c' ,Object_Type__c='Deliverable__c' ,
        Order__c='1000' ,Priority__c='Medium' ,Record_Type__c='Deliverable__c' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Event',
        Subject__c='Test ABC' ,Type__c='Type__c' ,Type_Values__c='Event Close Out');
        
        insert dbt511;
    }
    
    public static testmethod void testEventLocationTasksforDeliverable()
    {
        Test.startTest();
        
        createTaskList2();
        
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event');
        insert EventTest2;
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Adak' , State__c ='Alaska', ZIP_Code__c='99546', Country__c='United States');
        insert Ven; // Initializing Venue Record
        
        Campaign eventLocTest1=new Campaign(Name='Event Location1',recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3), Volunteer_Coordinator__c = UserInfo.getUserId(), EVE_Start_Time__c = '08:00 AM', EVE_End_Time__c = '08:30 AM', status = 'Scheduled', Event__c = EventTest2.id , Venue__c = ven.id);
        insert eventLocTest1;
        
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=eventLocTest1.Id,RecordTypeId=Utility.getRecordtype('Event Deliverable','Deliverable__c'),Type__c = 'Inventory',Name='Deliverable1',Status__c='Confirmed',Do_Not_Auto_Populate_Tasks__c = false);
        insert deliverableTest1;
        
        eventLocTest1.Status = 'Cancelled';
        eventLocTest1.Cancellation_Reason__c = 'Act Of God';
        update eventLocTest1;
        System.AssertEquals('Cancelled',eventLocTest1.Status );
        Test.stopTest();
    }
    
    public static void createTaskList3()
    {
        DeliverableBasedTaskList__c dbtl1 = new DeliverableBasedTaskList__c(Name = 'Sumeet1', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='1000' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c='Test ABC' ,Type__c='Type__c' ,Type_Values__c='Email');
        
        insert dbtl1;
        
        DeliverableBasedTaskList__c dbtl2 = new DeliverableBasedTaskList__c(Name = 'Sumeet2', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,Order__c='1001' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDS' ,Type__c='Type__c' ,Type_Values__c='Email');
        
        insert dbtl2;
        
        
        DeliverableBasedTaskList__c dbtl3 = new DeliverableBasedTaskList__c(Name = 'Sumeet12', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,
        Order__c='1004' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c='Test ABCRRR' ,Type__c='Type__c' ,Type_Values__c='Email');
        
        insert dbtl3;
        
        DeliverableBasedTaskList__c dbtl4 = new DeliverableBasedTaskList__c(Name = 'Sumeet21', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Deliverable__c' ,Order__c='1003' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA' ,Type__c='Type__c' ,Type_Values__c='Email');
        
        insert dbtl4;
        
        DeliverableBasedTaskList__c dbtl11 = new DeliverableBasedTaskList__c(Name = 'Sumeet1234', Assigned_To__c='Campaign Owner',
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10001' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c='Test ABC435',Type_Values__c='Initiation');
        
        insert dbtl11;
        
        DeliverableBasedTaskList__c dbtl21 = new DeliverableBasedTaskList__c(Name = 'Sumeet122', Assigned_To__c='Campaign Owner' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10011' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDS345',Type_Values__c='Initiation' );
        
        insert dbtl21;
        
        
        DeliverableBasedTaskList__c dbtl31 = new DeliverableBasedTaskList__c(Name = 'Sumeet112', Assigned_To__c='Project Manager',
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,
        Due_Date_Value__c=15 ,Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,
        Order__c='10041' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c='Test ABCRRR456',Type_Values__c='Initiation' );
        
        insert dbtl31;
        
        DeliverableBasedTaskList__c dbtl41 = new DeliverableBasedTaskList__c(Name = 'Sumeet211', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA57',Type_Values__c='Initiation' );
        
        insert dbtl41;
        
        DeliverableBasedTaskList__c dbtl51 = new DeliverableBasedTaskList__c(Name = 'Sumeet511', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA57',Type_Values__c='' );
        
        insert dbtl51;
        
        DeliverableBasedTaskList__c dbtl52 = new DeliverableBasedTaskList__c(Name = 'Sumeet512', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='' );
        
        insert dbtl52;
        
        
        DeliverableBasedTaskList__c dbtl61 = new DeliverableBasedTaskList__c(Name = 'Sumeet611', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='' );
        
        insert dbtl61;
        
        DeliverableBasedTaskList__c dbtl62 = new DeliverableBasedTaskList__c(Name = 'Sumeet612', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='' );
        
        insert dbtl62;
        
        DeliverableBasedTaskList__c dbtl71 = new DeliverableBasedTaskList__c(Name = 'Sumeet711', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='Launch Date' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='' );
        
        insert dbtl71;
        
        DeliverableBasedTaskList__c dbtl72 = new DeliverableBasedTaskList__c(Name = 'Sumeet712', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='Launch Date' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='' );
        
        insert dbtl72;
        
        DeliverableBasedTaskList__c dbtl81_1 = new DeliverableBasedTaskList__c(Name = 'Sumeet811_1', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='Launch Date' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Draft' );
        
        insert dbtl81_1;
        
        DeliverableBasedTaskList__c dbtl82_1 = new DeliverableBasedTaskList__c(Name = 'Sumeet812_1', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='Launch Date' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='Campaign' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Draft' );
        
        insert dbtl82_1;
        
        DeliverableBasedTaskList__c dbtl81 = new DeliverableBasedTaskList__c(Name = 'Sumeet811', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='Launch Date' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Project Manager' );
        
        insert dbtl81;
        
        DeliverableBasedTaskList__c dbtl82 = new DeliverableBasedTaskList__c(Name = 'Sumeet812', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='Launch Date' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Project Manager' );
        
        insert dbtl82;
        
        DeliverableBasedTaskList__c dbtl91 = new DeliverableBasedTaskList__c(Name = 'Sumeet911', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Project Manager' );
        
        insert dbtl91;
        
        DeliverableBasedTaskList__c dbtl92 = new DeliverableBasedTaskList__c(Name = 'Sumeet912', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Project Manager' );
        
        insert dbtl92;
        
        
        DeliverableBasedTaskList__c dbtl101 = new DeliverableBasedTaskList__c(Name = 'Sumeet1011', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Before' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Project Manager' );
        
        insert dbtl101;
        
        DeliverableBasedTaskList__c dbtl102 = new DeliverableBasedTaskList__c(Name = 'Sumeet1012', Assigned_To__c='Project Manager' ,
        Due_Date_Calculated_From__c='EndDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='After' ,Due_Date_Value__c=20 ,
        Object_Name__c='Campaign' ,Object_Type__c='' ,Order__c='10031' ,Priority__c='Medium' ,Record_Type__c='Campaign' ,Status__c='Assigned' ,
        Subject__c= 'TEST CDSAAA58',Type_Values__c='Project Manager' );
        
        insert dbtl102;
    }
    
    public static testmethod void testCampaignTasksforDeliverable()
    {
        Test.startTest();
        
        createTaskList3();
        
        Campaign campaignVar1=new Campaign(Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));        
        insert campaignVar1;
        
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=campaignVar1.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Type__c = 'Email',Name='Deliverable1',Status__c='Confirmed',Do_Not_Auto_Populate_Tasks__c = false);
        insert deliverableTest1;
        
        campaignVar1.Status = 'Initiation';
        update campaignVar1;
        System.AssertEquals('Initiation',campaignVar1.Status );
        Test.stopTest();
        
        DeliverableBasedTaskList__c dbt514 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask514', Assigned_To__c=System.label.Event_Specialist,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Never' ,
        Due_Date_Value__c=0 ,Object_Name__c=System.Label.Deliverable_Object ,Object_Type__c='Deliverable__c' ,
        Order__c='10003' ,Priority__c='Medium' ,Record_Type__c='Deliverable__c' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Revenue',
        Subject__c='Test ABC3' ,Type__c='Type__c' ,Type_Values__c='Email',Status_Condition__c= 'Confirmed',Status_Object__c=System.Label.Deliverable_Object);
        
        insert dbt514;
        
        DeliverableBasedTaskList__c dbt515 = new DeliverableBasedTaskList__c(Name = 'EventDeliverableTask515', Assigned_To__c=System.label.Event_Specialist,
        Due_Date_Calculated_From__c='StartDate' ,Due_Date_Object__c='Campaign' ,Due_Date_Scenario__c='Never' ,
        Due_Date_Value__c=0 ,Object_Name__c=System.Label.Deliverable_Object ,Object_Type__c='Deliverable__c' ,
        Order__c='10003' ,Priority__c='Medium' ,Record_Type__c='Deliverable__c' ,Status__c='Assigned' ,CAMPAIGN_TYPE__C = 'Revenue',
        Subject__c='Test ABC3' ,Type__c='Type__c' ,Type_Values__c='Email',Status_Condition__c= 'Draft',Status_Object__c='Campaign');
        
        insert dbt515;
        
        Id uid = UserInfo.getUserId();
        
        Campaign campaignVar2=new Campaign(Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2),Project_Manager__c = UserInfo.getUserId());        
        insert campaignVar2;
       // campaignVar1.;
       // update 2
        Deliverable__c deliverableTest2=new Deliverable__c(Campaign__c=campaignVar2.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),Type__c = 'Email',Name='Deliverable1',Status__c='Confirmed',Do_Not_Auto_Populate_Tasks__c = false);
        insert deliverableTest2;
        
        
         
    }
   

}