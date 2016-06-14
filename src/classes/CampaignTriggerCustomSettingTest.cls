/*****************************************************************************************
    Name             : CampaignTriggerCustomSettingTest
    Description      : Test Class to cover all Campaign/Event/Event Location/Program scenarios where custom setting is used           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAlldata = true)
public class CampaignTriggerCustomSettingTest{

        private static List<User> createTestData_User()
    {  List<User> listUser=new List<User>();
    //----------------
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
        listUser.add(user6);
        //--------------
     //----------------
        User user5 = new User();
        user5.Username= 'testusertest5@test.com';
        user5.Email= 'test5@test.com';
         user5.Managerid = userinfo.getuserid();
        user5.Lastname= 'user';
        user5.Firstname= 'test5';
        user5.Alias= 'test';
        user5.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user5.TimeZoneSidKey= 'GMT';
        user5.LocaleSidKey= 'en_US';
        user5.EmailEncodingKey= 'ISO-8859-1';
        user5.LanguageLocaleKey= 'en_US';
        user5.Authorized_Campaign_Owner__c=true;
        user5.UserPermissionsMobileUser = true;
       listUser.add(user5);
        //  ---------------  
         //----------------
        User user = new User();
        user.Username= 'testusertest56@test.com';
        user.Email= 'test56@test.com';
        user.Lastname= 'user';
         user.Managerid = userinfo.getuserid();
        user.Firstname= 'test56';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.Authorized_Campaign_Owner__c=true;
        user.UserPermissionsMobileUser = true;
        listUser.add(user);
        
        //  User user = [select id from User where alias = 'skanj'];
        //  ---------------
        User user1 = new User();
        user1.Username= 'testusertest11@test.com';
        user1.Email= 'test11@test.com';
        user1.Lastname= 'user';
        user1.Firstname= 'test11';
        user1.Alias= 'test';
        user1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user1.TimeZoneSidKey= 'GMT';
         user1.Managerid = user.id;
        user1.LocaleSidKey= 'en_US';
        user1.EmailEncodingKey= 'ISO-8859-1';
        user1.LanguageLocaleKey= 'en_US';
        user1.Authorized_Campaign_Owner__c=true;
        user1.UserPermissionsMobileUser = true;
        listUser.add(user1);
        //----------------  
        
         //  ---------------
        User user19 = new User();
        user19.Username= 'testusertest19@test.com';
        user19.Email= 'test19@test.com';
        user19.Lastname= 'user';
        user19.Firstname= 'test19';
        user19.Alias= 'test';
        user19.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user19.TimeZoneSidKey= 'GMT';
         user19.Managerid = user.id;
        user19.LocaleSidKey= 'en_US';
        user19.EmailEncodingKey= 'ISO-8859-1';
        user19.LanguageLocaleKey= 'en_US';
        user19.Authorized_Campaign_Owner__c=true;
        user19.UserPermissionsMobileUser = true;
        listUser.add(user19);
        //----------------  
        
        return listUser; 
    }
    
        private static List<Campaign> createTestData_Campaign()
    {   
       // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    
        List<User>  listUser = createTestData_User(); 
        insert listUser[0];
        
        //Create Data
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar;     
        
        System.AssertEquals(3400,ProgramTestVar.Projected_Budget__c);    
              
        List<Campaign> listCampaign = new List<Campaign>();
        
        Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), status = 'Completed', Name = 'Test Campaign1', type = 'Acquisition',endDate = date.today(),
         Launch_Date__c = date.today(),Overview__c = 'abcd', Program__c = ProgramTestVar.id,Project_Manager__c = null, ownerid = listUser[0].id,StartDate = date.today() );//
       
        Campaign CampaignTest2=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),status = 'Completed', Name = 'Test Campaign2', type = 'Acquisition', endDate = date.today(),
        Launch_Date__c = date.today(),Overview__c = 'abcd',Program__c = ProgramTestVar.id,Project_Manager__c = listUser[0].id, ownerid = listUser[0].id,StartDate = date.today()); // 
        listCampaign.add(CampaignTest1);
        //listCampaign.add(CampaignTest2);       
         
         return listCampaign;
    }

        private static List<Campaign> createTestData_Event()
    {  
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        //Create Data
        List<User>  listUser = createTestData_User(); 
        insert listUser[1];
       
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar; // Initializing Prgram record
        
         System.AssertEquals(3400,ProgramTestVar.Projected_Budget__c); 
            
        List<Campaign> listEvent=new List<Campaign>();
        
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition',
        EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, ownerid = listUser[1].id,endDate = date.today(),StartDate = date.today());
        //,EVE_Origin__c = EventOrigin.id);
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', 
        EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, ownerid = listUser[1].id,endDate = date.today(),StartDate = date.today());
       // EVE_Origin__c = EventOrigin.id,
        listEvent.add(EventTest1);
        listEvent.add(EventTest2);
        return listEvent;             
    }

        private static List<Campaign> createTestData_EventLocation()
    {              
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        //Create Data
         List<User>  listUser = createTestData_User(); 
        insert listUser[2];
        insert listUser[3];
        
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar;// Initializing Prgram record
        
        System.AssertEquals(3400,ProgramTestVar.Projected_Budget__c); 
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        System.AssertEquals('Andheri',ven.City__c);  
            
        List<Campaign> listEvent=new List<Campaign>();
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');
     
        listEvent.add(EventTest1);
        listEvent.add(EventTest2);
        insert listEvent; // Initializing Event Record
        
        List<Campaign> listEventLocation=new List<Campaign>();
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', override_venue_conflict__c = true, status ='Scheduled', 
        Event__c = EventTest1.id,Venue__c = ven.id, Volunteer_Coordinator__c = listUser[2].id, ownerid = listUser[3].id,//Event_Volunteer_Manager__c = listUser[3].id,
        Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel',
        StartDate = System.today().addDays(-2),EndDate = date.today() );
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', override_venue_conflict__c = true, status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, //Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,
        Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel', StartDate = date.today(),EndDate = System.today().addDays(+2) );
                  
        listEventLocation.add(EventLocationTest1);
        listEventLocation.add(EventLocationTest2);
        return listEventLocation;       
     }
     
       public static testMethod void taskAssignment_Test1()
    {   Test.startTest();  
    
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       
        List<User>  listUser = createTestData_User(); 
        insert listUser[2];
        listUser[2].ManagerId = listUser[2].id;
        
        List<Campaign>  listCampaign = createTestData_Campaign(); 
        insert listCampaign;
        listCampaign[0].ownerid = listUser[2].id;
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='skmsmsu2test@test.com');
        insert Agency; 
        /*
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '999',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c  = 'Deliverable__c', Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'tooling');
        insert dbt;
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '951', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt1;
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '915', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt2;
        
         DeliverableBasedTaskList__c dbt3 = new DeliverableBasedTaskList__c(name = '995', Assigned_To__c = System.Label.Campaign_Specialist , Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt3;
        
         DeliverableBasedTaskList__c dbt4 = new DeliverableBasedTaskList__c(name = '991', Assigned_To__c = System.Label.Agency , Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt4;
        */
        //---creating Deliverable record start---------      
        List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
        Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'), Campaign__c = listCampaign[0].id, Name = 'Test Deliverable1',Status__c ='Confirmed',Type__c= 'Email', Agency__c = Agency.id);
        Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listCampaign[0].id, Name = 'Test Deliverable2', Status__c ='Confirmed', Type__c= 'Inventory');
        listDeliverable.add(DeliverableTest1);
        listDeliverable.add(DeliverableTest2);
         insert listDeliverable;
        //---creating Deliverable record end------------
        
        System.AssertEquals('Email',listDeliverable[0].Type__c);    
        
        Map<Id, String> mapDeliverableCampaignType = new Map<Id, String>();
        mapDeliverableCampaignType.put(DeliverableTest1.id, listCampaign[0].Type);
        mapDeliverableCampaignType.put(DeliverableTest2.id, listCampaign[0].Type);
        
        listDeliverable[0].Name = 'test del';
        update listDeliverable[0];        
        
        System.AssertEquals('test del',listDeliverable[0].Name);  
        
        //CampaignTriggerHelper cth = new CampaignTriggerHelper();      
        
        //cth.taskAssignment(listDeliverable, 'Update');
        test.stoptest();
    }
    
          public static testMethod void taskAssignment_Test2()
    {      Test.startTest();  
    
       //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       List<Campaign>  listCampaign = createTestData_Campaign(); 
       insert listCampaign[0];
       //insert listCampaign[0];
       
        List<User>  listUser = createTestData_User(); 
        insert listUser[2];
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='newsumeettest@test.com');
        insert Agency; 
          
        //---creating Deliverable record start---------      
        List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
        Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'), Campaign__c = listCampaign[0].id, Name = 'Test Deliverable1',Status__c ='Confirmed',Type__c= 'tooling', Agency__c = Agency.id);
        Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listCampaign[0].id, Name = 'Test Deliverable2', Status__c ='Confirmed', Type__c= 'Inventory');
        listDeliverable.add(DeliverableTest1);
        listDeliverable.add(DeliverableTest2);
         insert listDeliverable;
        //---creating Deliverable record end------------
         System.AssertEquals('tooling',listDeliverable[0].Type__c);
        /*
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '999',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date', Status_Object__c = System.Label.Deliverable_Object,
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '394', Status_Condition__c = 'Confirmed',
        Priority__c = 'Medium', Record_Type__c  = 'Deliverable__c', Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'tooling', Campaign_Type__c = 'OSR');
        insert dbt;
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '951', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = 'Created Date',Status_Object__c = System.Label.Deliverable_Object, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', Status_Condition__c =  'Confirmed',
        Priority__c = 'Medium', Record_Type__c  = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory', Campaign_Type__c = 'OSR');
        insert dbt1;
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '915', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c = 'Created Date', Status_Object__c = System.Label.Deliverable_Object,
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', Status_Condition__c =  'Confirmed',
        Priority__c = 'Medium', Record_Type__c  = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory', Campaign_Type__c = 'OSR');
        insert dbt2;
        
         DeliverableBasedTaskList__c dbt3 = new DeliverableBasedTaskList__c(name = '995', Assigned_To__c = System.Label.Campaign_Specialist , Due_Date_Calculated_From__c = 'Created Date', Status_Object__c = System.Label.Deliverable_Object,
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', Status_Condition__c =  'Confirmed',
        Priority__c = 'Medium', Record_Type__c = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory', Campaign_Type__c = 'OSR');
        insert dbt3;
        
         DeliverableBasedTaskList__c dbt4 = new DeliverableBasedTaskList__c(name = '991', Assigned_To__c = System.Label.Agency , Due_Date_Calculated_From__c = 'Created Date', Status_Object__c = System.Label.Deliverable_Object,
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', Status_Condition__c =  'Confirmed',
        Priority__c = 'Medium', Record_Type__c = 'Event', Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory', Campaign_Type__c = 'OSR');
        insert dbt4;
        */
        Map<Id, String> mapDeliverableCampaignType = new Map<Id, String>();
        mapDeliverableCampaignType.put(DeliverableTest1.id, listCampaign[0].Type);
        mapDeliverableCampaignType.put(DeliverableTest2.id, listCampaign[0].Type);
        
        listDeliverable[0].Name = 'test del';
        update listDeliverable[0];
        
        System.AssertEquals('test del',listDeliverable[0].Name);  
        
        //CampaignTriggerHelper cth = new CampaignTriggerHelper();      
        
        //cth.taskAssignment(listDeliverable, 'Update');
        test.stoptest();
    }
    
    
    
       public static testMethod void createCampaignUserList_CampaignTest()
    { Test.startTest();
    
       //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
                       
       /*
                            
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '951',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c  =System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt;
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '952', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt1;
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '953', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt2;
        
         DeliverableBasedTaskList__c dbt3 = new DeliverableBasedTaskList__c(name = '954',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt3;
        
        DeliverableBasedTaskList__c dbt4= new DeliverableBasedTaskList__c(name = '955', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt4;
        
        DeliverableBasedTaskList__c dbt5 = new DeliverableBasedTaskList__c(name = '956', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = null);
        insert dbt5;
        //----------
         DeliverableBasedTaskList__c dbt6 = new DeliverableBasedTaskList__c(name = '957',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = null, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = System.Label.Project_Manager);
        insert dbt6;
        
        DeliverableBasedTaskList__c dbt7 = new DeliverableBasedTaskList__c(name = '958', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = null, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.Project_Manager);
        insert dbt7;
        
        DeliverableBasedTaskList__c dbt8 = new DeliverableBasedTaskList__c(name = '959', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = null, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.Project_Manager);
        insert dbt8;
        
         DeliverableBasedTaskList__c dbt9 = new DeliverableBasedTaskList__c(name = '960',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =null, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = System.Label.Project_Manager);
        insert dbt9;
        
        DeliverableBasedTaskList__c dbt10= new DeliverableBasedTaskList__c(name = '961', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = null, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.Project_Manager);
        insert dbt10;
        
        DeliverableBasedTaskList__c dbt11 = new DeliverableBasedTaskList__c(name = '962', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = null, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.Project_Manager);
        insert dbt11;
        //-------------------
         DeliverableBasedTaskList__c dbt12 = new DeliverableBasedTaskList__c(name = '963',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = System.Label.CampaignStatus_Completed);
        insert dbt12;
        
        DeliverableBasedTaskList__c dbt13 = new DeliverableBasedTaskList__c(name = '964', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.CampaignStatus_Completed);
        insert dbt13;
        
        DeliverableBasedTaskList__c dbt14 = new DeliverableBasedTaskList__c(name = '965', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.CampaignStatus_Completed);
        insert dbt14;
        
         DeliverableBasedTaskList__c dbt15 = new DeliverableBasedTaskList__c(name = '966',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = System.Label.CampaignStatus_Completed);
        insert dbt15;
        
        DeliverableBasedTaskList__c dbt16= new DeliverableBasedTaskList__c(name = '967', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.CampaignStatus_Completed);
        insert dbt16;
        
        DeliverableBasedTaskList__c dbt17 = new DeliverableBasedTaskList__c(name = '968', Assigned_To__c = System.Label.Campaign_Specialist, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Campaign, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = System.Label.CampaignStatus_Completed);
        insert dbt17;
        */
        //-------------------   
        //System.AssertEquals('13',dbt17.Order__c);  
        
         List<Campaign>  listCampaign = createTestData_Campaign(); 
       insert listCampaign[0];
        
        //CampaignTriggerHelper cth = new CampaignTriggerHelper();
        //cth.createCampaignUserList(listCampaign,'insert');        
        
        test.stoptest();
    }
    
        public static testMethod void createCampaignUserList_EventTest1()
    {   
    
       // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
                       
          
       
        List<User>  listUser = createTestData_User(); 
        //insert listUser[2];
        /*        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '951',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c  =System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt;
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '952', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt1;
        
         DeliverableBasedTaskList__c dbt3 = new DeliverableBasedTaskList__c(name = '954',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt3;
        
        DeliverableBasedTaskList__c dbt4= new DeliverableBasedTaskList__c(name = '955', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = 'Deliverable__c', Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Event  , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt4;        
    
        //----------
         DeliverableBasedTaskList__c dbt6 = new DeliverableBasedTaskList__c(name = '957',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt6;
        
        DeliverableBasedTaskList__c dbt7 = new DeliverableBasedTaskList__c(name = '958', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt7;
        
        DeliverableBasedTaskList__c dbt8 = new DeliverableBasedTaskList__c(name = '959',Assigned_To__c = System.Label.Marketing_Web_Team_Member, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt8;
        
         DeliverableBasedTaskList__c dbt9 = new DeliverableBasedTaskList__c(name = '960',Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =System.Label.Deliverable_Object, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Event, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Type__c', Type_Values__c = 'Inventory');
        insert dbt9;
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '953', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt2;    
        
        DeliverableBasedTaskList__c dbt14 = new DeliverableBasedTaskList__c(name = '975', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt14;

        DeliverableBasedTaskList__c dbt5 = new DeliverableBasedTaskList__c(name = '956', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c  = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt5;    

       DeliverableBasedTaskList__c dbt10= new DeliverableBasedTaskList__c(name = '961', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt10;
        //-------
        DeliverableBasedTaskList__c dbt11 = new DeliverableBasedTaskList__c(name = '962', Assigned_To__c = System.Label.Marketing_Web_Team_Member, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation,Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt11;
       
         DeliverableBasedTaskList__c dbt12 = new DeliverableBasedTaskList__c(name = '963',Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Ad Assignment', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt12;
        
        DeliverableBasedTaskList__c dbt13 = new DeliverableBasedTaskList__c(name = '964', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_Event , Status__c = 'Assigned', Subject__c = 'Beneficiary Estimates', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Draft');
        insert dbt13;
        */
         //-------------------
        List<Campaign>  listEvent = createTestData_Event();
        insert listEvent[0];          
        
        List<Campaign>  listEventLocation = createTestData_EventLocation();
        insert listEventLocation[1];
         Test.startTest();
        //---creating Deliverable record start---------      
        List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
        Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'), Campaign__c = listEvent[0].id, Name = 'Test Deliverable1',Status__c ='Confirmed',Type__c= 'Inventory');
        Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listEvent[0].id, Name = 'Test Deliverable2', Status__c ='Confirmed', Type__c= 'Inventory');
        Deliverable__c DeliverableTest3=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'), Campaign__c = listEventLocation[1].id, Name = 'Test Deliverable3',Status__c ='Confirmed',Type__c= 'Inventory');
        Deliverable__c DeliverableTest4=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listEventLocation[1].id, Name = 'Test Deliverable4', Status__c ='Confirmed', Type__c= 'Inventory');
        
        listDeliverable.add(DeliverableTest1);
        listDeliverable.add(DeliverableTest2);
        listDeliverable.add(DeliverableTest3);
        listDeliverable.add(DeliverableTest4);
        insert listDeliverable;
        
        System.AssertEquals('Inventory',listDeliverable[0].Type__c);  
        
        List<Deliverable__c> listDeliverableRelatedRecords = [select id, Type__c from Deliverable__c where Event__c =:listEvent[0].id];
        
        id EvLocRecType=Utility.getRecordType('Event Location','Campaign') ;
        
        List<Campaign> listEventLocationRelated = [select id, Status, Volunteer_Coordinator__c from Campaign where recordTypeId =: EvLocRecType and Event__c =:listEvent[0].id];
        
        //CampaignTriggerHelper cth = new CampaignTriggerHelper();
        //cth.createCampaignUserList(listEvent,'insert');        
        
        test.stoptest();
    }    
    
 
        public static testMethod void createCampaignUserList_EventLocationTest()
    {
        Test.startTest();
                       
         // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
                       
        List<Campaign>  listEventLocation = createTestData_Event();
        insert listEventLocation;  
       
        List<User>  listUser = createTestData_User(); 
        insert listUser[2];
        /*        
        DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '951',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =  System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt;
        
        DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '952', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =  System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt1;
        
         DeliverableBasedTaskList__c dbt3 = new DeliverableBasedTaskList__c(name = '953',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =  System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt3;
        
        DeliverableBasedTaskList__c dbt4= new DeliverableBasedTaskList__c(name = '954', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =  System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation  , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt4;        
    
        //----------
         DeliverableBasedTaskList__c dbt5 = new DeliverableBasedTaskList__c(name = '955',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt5;
        
        DeliverableBasedTaskList__c dbt7 = new DeliverableBasedTaskList__c(name = '956', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =  System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt7;
        
        DeliverableBasedTaskList__c dbt8 = new DeliverableBasedTaskList__c(name = '957',Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c =  System.Label.Campaign_Lanch_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c =  System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt8;
        
         DeliverableBasedTaskList__c dbt9 = new DeliverableBasedTaskList__c(name = '958',Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Type__c', Type_Values__c = 'Scheduled');
        insert dbt9;
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        DeliverableBasedTaskList__c dbt2 = new DeliverableBasedTaskList__c(name = '959', Assigned_To__c =  System.Label.Marketing_Web_Team_Member , Due_Date_Calculated_From__c =  System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Scheduled');
        insert dbt2;    
        
        DeliverableBasedTaskList__c dbt14 = new DeliverableBasedTaskList__c(name = '960', Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c =  System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Recordtype_Campaign, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Scheduled');
        insert dbt14;

        DeliverableBasedTaskList__c dbt6 = new DeliverableBasedTaskList__c(name = '961', Assigned_To__c = System.Label.Project_Manager, Due_Date_Calculated_From__c =  System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = System.Label.Volunteer_Coordinator_Based_First_Task, Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt6;    

       DeliverableBasedTaskList__c dbt10= new DeliverableBasedTaskList__c(name = '962', Assigned_To__c = System.Label.Campaign_Owner, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.After_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt10;
        //-------
        
         DeliverableBasedTaskList__c dbt12 = new DeliverableBasedTaskList__c(name = '963',Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt12;
        
        DeliverableBasedTaskList__c dbt13 = new DeliverableBasedTaskList__c(name = '964', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt13;
        
          DeliverableBasedTaskList__c dbt22 = new DeliverableBasedTaskList__c(name = '965',Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt22;
        
        DeliverableBasedTaskList__c dbt15 = new DeliverableBasedTaskList__c(name = '966', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt15;
        
        DeliverableBasedTaskList__c dbt17 = new DeliverableBasedTaskList__c(name = '967', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt17;
        
          DeliverableBasedTaskList__c dbt18 = new DeliverableBasedTaskList__c(name = '968',Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt18;
        
        DeliverableBasedTaskList__c dbt19 = new DeliverableBasedTaskList__c(name = '969', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt19;
        
            DeliverableBasedTaskList__c dbt20 = new DeliverableBasedTaskList__c(name = '970',Assigned_To__c = System.Label.Event_Volunteer_Coordinator, Due_Date_Calculated_From__c = System.Label.Start_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '394', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation , Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt20;
        
        DeliverableBasedTaskList__c dbt21 = new DeliverableBasedTaskList__c(name = '971', Assigned_To__c = System.Label.Event_Specialist, Due_Date_Calculated_From__c = System.Label.End_Date, 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = System.Label.Before_Condition, Due_Date_Value__c = 7, Object_Name__c = 'Deliverable__c', Object_Type__c = System.Label.Deliverable_Object, Order__c = '13', 
        Priority__c = 'Medium', Record_Type__c = System.Label.Recordtype_EventLocation, Status__c = 'Assigned', Subject__c = 'Confirm Venue', Type__c = 'Order_Child_Packets__c', Type_Values__c = 'Inventory');
        insert dbt21;
        */
         //-------------------
        //---creating Deliverable record start---------      
        List<Deliverable__c> listDeliverable=new List<Deliverable__c>();
        Deliverable__c DeliverableTest1=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'), Campaign__c = listEventLocation[0].id, Name = 'Test Deliverable1',Status__c ='Confirmed',Type__c= 'Inventory');
        Deliverable__c DeliverableTest2=new Deliverable__c(RecordtypeId=Utility.getRecordType('Event Deliverable','Deliverable__c'),Campaign__c = listEventLocation[1].id, Name = 'Test Deliverable2', Status__c ='Confirmed', Type__c= 'Inventory');
        listDeliverable.add(DeliverableTest1);
        listDeliverable.add(DeliverableTest2);
        insert listDeliverable;
        
        System.AssertEquals('Inventory',listDeliverable[0].Type__c);  
        
        List<Id> listIds = new List<Id>();
        listIds.add(DeliverableTest1.id); 
        listIds.add(DeliverableTest2.id); 
        
        List<Task> tList = [select id, Status, Custom_Settings_Linkage__c, WhatId from Task where WhatId in :listIds];
        
        CampaignTriggerHelper cth = new CampaignTriggerHelper();
        cth.createCampaignUserList(listEventLocation ,'insert');
        
        test.stoptest();
    }
    
      public static testMethod void AssignEstimatedVolunteerNeedEqualto_test()
    {
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Campaign>  listEventLocation = createTestData_EventLocation(); 
        insert listEventLocation;
        
        //VolunteerSizeDetermination__c cs = new VolunteerSizeDetermination__c(Name = 'test1',Booth_Operator__c = '=', Event_Audience_Size__c=23, Event_Audience_Size_Operator__c = '=',
        //Number_Of_Booths_Tables__c = 23, Number_Of_Volunteers_Needed__c = 2, Packet_Pass_Needed__c = true);       
        //insert cs;
        //VolunteerSizeDetermination__c cs1 = new VolunteerSizeDetermination__c(Name = 'test2',Booth_Operator__c = '=', Event_Audience_Size__c=21, Event_Audience_Size_Operator__c = '>',
        //Number_Of_Booths_Tables__c = 23, Number_Of_Volunteers_Needed__c = 2, Packet_Pass_Needed__c = true);       
        //insert cs1;
        //VolunteerSizeDetermination__c cs2 = new VolunteerSizeDetermination__c(Name = 'test3',Booth_Operator__c = '=', Event_Audience_Size__c=25, Event_Audience_Size_Operator__c = '<',
        //Number_Of_Booths_Tables__c = 23, Number_Of_Volunteers_Needed__c = 2, Packet_Pass_Needed__c = true);       
        //insert cs2;
        
        //System.AssertEquals(2,cs.Number_Of_Volunteers_Needed__c );  
        
        //CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        //CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        //ctHelper.assignEstimatedVolunteerNeed(listEventLocation);
        
        test.stoptest();
    }
    
         public static testMethod void AssignEstimatedVolunteerNeedGreaterThan_test()
    {
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
          
        List<Campaign>  listEventLocation = createTestData_EventLocation(); 
        insert listEventLocation;
        //CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        //CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        //ctHelper.assignEstimatedVolunteerNeed(listEventLocation);
        
        test.stoptest();
    }
    
     public static testMethod void AssignEstimatedVolunteerNeedLessThan_test()
    {
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Campaign>  listEventLocation = createTestData_EventLocation(); 
        insert listEventLocation;
        /*
        VolunteerSizeDetermination__c cs6 = new VolunteerSizeDetermination__c(Name = 'test7',Booth_Operator__c = '<', Event_Audience_Size__c=23, Event_Audience_Size_Operator__c = '=',
        Number_Of_Booths_Tables__c = 25, Number_Of_Volunteers_Needed__c = 2, Packet_Pass_Needed__c = true);       
        insert cs6;
        VolunteerSizeDetermination__c cs7 = new VolunteerSizeDetermination__c(Name = 'test8',Booth_Operator__c = '<', Event_Audience_Size__c=21, Event_Audience_Size_Operator__c = '>',
        Number_Of_Booths_Tables__c = 25, Number_Of_Volunteers_Needed__c = 2, Packet_Pass_Needed__c = true);       
        insert cs7;
        VolunteerSizeDetermination__c cs8 = new VolunteerSizeDetermination__c(Name = 'test9',Booth_Operator__c = '<', Event_Audience_Size__c=25, Event_Audience_Size_Operator__c = '<',
        Number_Of_Booths_Tables__c = 25, Number_Of_Volunteers_Needed__c = 2, Packet_Pass_Needed__c = true);       
        insert cs8;
        
        System.AssertEquals(2,cs6.Number_Of_Volunteers_Needed__c );  
        
        CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        ctHelper.assignEstimatedVolunteerNeed(listEventLocation);
        */
        test.stoptest();
    }
    
     
  }