/*****************************************************************************************
    Name             : CampaignTrigger_Test
    Description      : Test Class to cover all Campaign/Event/Event Location/Program scenarios               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAlldata = true)
public class CampaignTrigger_Test{

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
    
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        List<User>  listUser = createTestData_User(); 
        insert listUser[0];
        
        //Create Data
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar;        
        
        System.AssertEquals(3400, ProgramTestVar.Projected_Budget__c);   
              
        List<Campaign> listCampaign = new List<Campaign>();
        
        Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), status = 'Completed', Name = 'Test Campaign1', type = 'Acquisition',
        endDate=date.today(),Launch_Date__c= date.today(),Program__c=ProgramTestVar.id,Project_Manager__c=null,ownerid=listUser[0].id,Overview__c='abcd',StartDate = date.today()); //
       
        Campaign CampaignTest2=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),status='Completed',Name='Test Campaign2',type='Acquisition',endDate=date.today(),
        Launch_Date__c = date.today(), Program__c = ProgramTestVar.id,Project_Manager__c = listUser[0].id, ownerid = listUser[0].id,Overview__c = 'abcd',StartDate = date.today()); //
        listCampaign.add(CampaignTest1);
        listCampaign.add(CampaignTest2);        
     
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
        
        System.AssertEquals(3400, ProgramTestVar.Projected_Budget__c);         
           
        List<Campaign> listEvent=new List<Campaign>();
        
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition',
        EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Track_Influencer_At__c='Event Location',Program__c = ProgramTestVar.id, ownerid = listUser[1].id,
        endDate = date.today(),StartDate = date.today());//EVE_Origin__c = EventOrigin.id,
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', 
        EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location',Track_Influencer_At__c='Event Location',  Program__c = ProgramTestVar.id, ownerid = listUser[1].id,
        endDate = date.today(),StartDate = date.today());//EVE_Origin__c = EventOrigin.id,
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
        
         System.AssertEquals(3400, ProgramTestVar.Projected_Budget__c);   
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record  
        
         System.AssertEquals('Andheri', ven.City__c);         
             
        List<Campaign> listEvent=new List<Campaign>();
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1',  status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Track_Influencer_At__c='Event Location', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');//EVE_Origin__c = EventOrigin.id,
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Track_Influencer_At__c='Event Location', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');
        listEvent.add(EventTest1);
        listEvent.add(EventTest2);
        insert listEvent; // Initializing Event Record
        
         System.AssertEquals('Draft', listEvent[1].status );       
        
        List<Campaign> listEventLocation=new List<Campaign>();
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', status ='Scheduled', 
        Event__c = EventTest1.id,Venue__c = ven.id, Volunteer_Coordinator__c = listUser[2].id, ownerid = listUser[3].id,Event_Volunteer_Manager__c = listUser[3].id,
        Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel');
      
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,
        Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel');     
        
        listEventLocation.add(EventLocationTest1);
        listEventLocation.add(EventLocationTest2);        
     
        return listEventLocation;
        
        
     }
     /*   public static testMethod void CampaignMainTrigger_Test()
    {
       Test.StartTest() ;
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        List<Campaign>  listCampaign = createTestData_Campaign();     
        
        List<Campaign>  listEvent = createTestData_Event();
        insert listEvent;
        
        list<id> listEventIds = new list<id>();
        
        for(Campaign c: listEvent)
        listEventIds.add(c.Id);
        
        List<Campaign>  listEventLocation = createTestData_EventLocation();     
        
        list<id> listEventLocationIds = new list<id>();
        
         
        for(Campaign c: listEventLocation)
        listEventLocationIds.add(c.Id);        
        
        //  ---------------User Record start
        User user2 = new User();
        user2.Username= 'testusertest2@test.com';
        user2.Email= 'test@test.com';
        user2.Lastname= 'user';
        user2.Firstname= 'test2';
        user2.Alias= 'test';
        user2.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user2.TimeZoneSidKey= 'GMT';
        user2.LocaleSidKey= 'en_US';
        user2.EmailEncodingKey= 'ISO-8859-1';
        user2.LanguageLocaleKey= 'en_US';
         user2.Managerid = userinfo.getuserid();
        user2.Authorized_Campaign_Owner__c=true;
        user2.UserPermissionsMobileUser = true;
        insert user2; // creating user record for updating Event Location record(Event_Volunteer_Manager__c,Volunteer_Coordinator__c,ownerid)
        //----------------User Record end
        System.AssertEquals(userinfo.getuserid(), user2.Managerid);   
        
         List<Campaign> listOldCampaigns = new list<campaign>();
        List<Campaign> listNewCampaign  = new list<campaign>(); 
        listOldCampaigns =  listEvent.clone();  
        
        
        listEvent[0].ownerid = user2.id;
        listEvent[0].Status = 'Cancelled';
        listEvent[0].Status_Reason__c = 'Act Of God';       
        Update listEvent[0];// Upadting Event record
        
        System.AssertEquals(user2.id ,listEvent[0].ownerid);
        
        //listNewCampaign.add(listEvent[0]);
        
        //-- initializing methods and class-------- 
        //CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        //CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        //EventTriggerHelper etHelper = new EventTriggerHelper();
        //etHelper.closeRelatedEvents(listEvent);
  
        
        Test.stopTest();
    }
    */
        public static testMethod void createLeadBasedTasks_NoTypeValue_Test()
    {   
        Test.startTest();
    
       //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        //  ---------------User Record start------------------------------
        User user3 = new User();
        user3.Username= 'testusertest34@test.com';
        user3.Email= 'test@test.com';
        user3.Lastname= 'user';
        user3.Firstname= 'test34';
        user3.Alias= 'test';
        user3.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user3.TimeZoneSidKey= 'GMT';
        user3.LocaleSidKey= 'en_US';
        user3.EmailEncodingKey= 'ISO-8859-1';
        user3.Managerid = userinfo.getuserid();
        user3.LanguageLocaleKey= 'en_US';
        user3.Authorized_Campaign_Owner__c=true;
        user3.UserPermissionsMobileUser = true;
        insert user3;
        //----------------User Record end-----------------------------        
                 
          DeliverableBasedTaskList__c dbt1 = new DeliverableBasedTaskList__c(name = '787',Assigned_To__c = 'Campaign Owner', Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = System.Label.Lead_Object, Object_Type__c = 'Lead', Order__c = '30', 
        Priority__c = 'Medium', Record_Type__c  = 'Lead', Status__c = 'Assigned', Subject__c = 'Lead Score Threshold Reached', Type__c = 'Lead_Score__c',
         Type_Values__c = '50');
        insert dbt1;
    
          System.AssertEquals('Lead_Score__c',dbt1.Type__c);
    
        Group College_Queue = [Select Id from Group where Name = 'College Queue' and Type = 'Queue' limit 1];
    
        //---creating Lead record list start---------
        List<lead> listLead=new List<Lead>();
        lead leadTest1=new lead(status = 'Active', Lead_Type__c = 'Event', LastName = 'test', Company = 'test Company',OwnerId = College_Queue.id, Lead_Score__c = 70);
        Lead LeadTest2=new lead(status = 'Active', Lead_Type__c = 'Church', LastName = 'test1', Company = 'test Company1',OwnerId = College_Queue.id, Lead_Score__c = 70);
        listLead.add(leadTest1);
        listLead.add(leadTest2);
        insert listLead;
        //---creating Lead record end------------
        
        System.AssertEquals(70,listLead[0].Lead_Score__c );
        
        CampaignTriggerHelper cth = new CampaignTriggerHelper();
        
        cth.createLeadBasedTasks(listLead, System.Label.DMLType_Insert);
         Test.stopTest();
    }
    
        public static testMethod void createLeadBasedTasks_typeValue_Test()
    {   Test.startTest();
    
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        //  ---------------User Record start
        User user3 = new User();
        user3.Username= 'testusertest34@test.com';
        user3.Email= 'test@test.com';
        user3.Lastname= 'user';
        user3.Firstname= 'test34';
        user3.Alias= 'test';
        user3.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user3.TimeZoneSidKey= 'GMT';
        user3.LocaleSidKey= 'en_US';
        user3.EmailEncodingKey= 'ISO-8859-1';
        user3.Managerid = userinfo.getuserid();
        user3.LanguageLocaleKey= 'en_US';
        user3.Authorized_Campaign_Owner__c=true;
        user3.UserPermissionsMobileUser = true;
        insert user3;
        //----------------User Record end
        
         DeliverableBasedTaskList__c dbt = new DeliverableBasedTaskList__c(name = '786',Assigned_To__c = 'Campaign Owner', Due_Date_Calculated_From__c = 'Created Date', 
        Due_Date_Object__c = 'task', Due_Date_Scenario__c = 'After', Due_Date_Value__c = 7, Object_Name__c = System.Label.Lead_Object, Object_Type__c = 'Lead', Order__c = '30', 
        Priority__c = 'Medium', Record_Type__c  = 'Lead', Status__c = 'Assigned', Subject__c = 'Lead Score Threshold Reached', Type__c = 'Lead_Score__c');
       //  Type_Values__c = '50');
        insert dbt;
        
          System.AssertEquals('Lead_Score__c',dbt.Type__c);
        
        Group College_Queue = [Select Id from Group where Name = 'College Queue' and Type = 'Queue' limit 1];
    
        //---creating Lead record list start---------
        List<lead> listLead=new List<Lead>();
        lead leadTest1=new lead(status = 'Active', Lead_Type__c = 'Event', LastName = 'test', Company = 'test Company',OwnerId = College_Queue.id, Lead_Score__c = 70);
        Lead LeadTest2=new lead(status = 'Active', Lead_Type__c = 'Church', LastName = 'test1', Company = 'test Company1',OwnerId = College_Queue.id, Lead_Score__c = 70);
        listLead.add(leadTest1);
        listLead.add(leadTest2);
        insert listLead;
        //---creating Lead record end------------
        
         System.AssertEquals(70,listLead[0].Lead_Score__c );
        
        CampaignTriggerHelper cth = new CampaignTriggerHelper();
        
        cth.createLeadBasedTasks(listLead, System.Label.DMLType_Insert);
         Test.stopTest();
    }
    
        public static testMethod void createCampaignBasedTasks_Test()
    {  
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Campaign>  listCampaign = createTestData_Campaign(); 
        insert listCampaign;
    
        //---creating Task record list start---------
        List<Task> listTask=new List<Task>();
        task taskTest1=new task(status = 'Assigned',WhatId = listCampaign[0].id );
        task taskTest2=new task(status = 'Assigned', WhatId = listCampaign[1].id );
        listTask.add(taskTest1);
        listTask.add(taskTest2);
        insert listTask;
        //---creating Task record end------------
        
          System.AssertEquals('Assigned',listTask[0].status );
        
        CampaignTriggerHelper cth = new CampaignTriggerHelper();
        CampaignTriggerHelper.CampaignCompletionCheck(listCampaign);
        
       Test.stopTest();
    }
        
 
      public static testMethod void ConfirmEvent()
    {
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Campaign>  listEvent = createTestData_Event();
        insert listEvent;  
        
        List<Campaign> listOldCampaigns = new list<campaign>();
        List<Campaign> listNewCampaign  = new list<campaign>(); 
        listOldCampaigns =  listEvent.clone();  
        
        //  ---------------User Record start
        User user2 = new User();
        user2.Username= 'testusertest22@test.com';
        user2.Email= 'test@test.com';
        user2.Lastname= 'user';
        user2.Firstname= 'test22';
        user2.Alias= 'test';
        user2.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user2.TimeZoneSidKey= 'GMT';
        user2.LocaleSidKey= 'en_US';
        user2.EmailEncodingKey= 'ISO-8859-1';
        user2.LanguageLocaleKey= 'en_US';
         user2.Managerid = userinfo.getuserid();
        user2.Authorized_Campaign_Owner__c=true;
        user2.UserPermissionsMobileUser = true;
        insert user2; // creating user record for updating Event Location record(Event_Volunteer_Manager__c,Volunteer_Coordinator__c,ownerid)
        //----------------User Record end
          System.AssertEquals(userinfo.getuserid(), user2.Managerid);   
        
        listEvent[0].Status = 'Confirmed';
        listEvent[0].Publish_to_Web__c = true;
        listEvent[0].ownerid = user2.id;
        Update listEvent[0];// Upadting Event record  
        
         System.AssertEquals('Confirmed', listEvent[0].Status );      
        
        listNewCampaign.add(listEvent[0]);        
                
         CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        ctHelper.assignRelationshipManager(listOldCampaigns,listNewCampaign);   
        
        test.stoptest();
    }
    
      public static testMethod void EventOrigin_testMethod()
    {
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Campaign>  listEvent = createTestData_Event();
        insert listEvent;  
         
         List<Campaign> listOldCampaigns = new list<campaign>();
        List<Campaign> listNewCampaign  = new list<campaign>(); 
        listOldCampaigns =  listEvent.clone();           
         
        Account EventOrigin1 =new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test1',Business_Email__c='test1@test.com');
        insert EventOrigin1;   //Creating EventOrigin for updating Event record(EVE_Origin__c)     
        
         System.AssertEquals('test1@test.com',EventOrigin1.Business_Email__c);         
        
        List<Influencer__c> listInfluencer = [select id from Influencer__c where Campaign__c =: listEvent[0].id and Influencer__c =:EventOrigin1.id];
    
        listInfluencer.clear();
        
        delete listEvent;
        
        CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();

        test.stoptest();
    }
    
             public static testMethod void VolunteerSlot_test()
        {
            
            
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            
            List<Campaign>  listEventLocation = createTestData_EventLocation(); 
            insert listEventLocation;
            
            List<Id> lstCoordinatorIds = new List<Id>();
            for(Campaign oC :listEventLocation)
            lstCoordinatorIds.add(oC.Volunteer_Coordinator__c);
                        
                  //-----Volunteer Slot start------
            List<Volunteer_Shift__c> listVSTest=new List<Volunteer_Shift__c>();    
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=listEventLocation[0].Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5, Volunteer_Role__c='Developer');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=listEventLocation[0].Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6, Volunteer_Role__c='Coach');
            listVSTest.add(VSTest1);
            listVSTest.add(VSTest2);
            insert listVSTest;
            //-----Volunteer Slot stop------
            
             System.AssertEquals('Developer', listVSTest[0].Volunteer_Role__c);      
            Test.startTest();
            Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            
            List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c = :listVSTest[0].Id]; //Getting newly created Volunteer Slots
            listVSlotTest[0].Volunteer__c=volunteerTest.Id;
            listVSlotTest[0].Status__c='Approved';        
            update listVSlotTest[0];
            
              System.AssertEquals('Approved', listVSlotTest[0].Status__c);      
            
            Set<Id> evLocIds=new Set<Id> ();
            for(campaign elVar: listEventLocation)
            evLocIds.add(elVar.Id);
            
            List<Campaign> listEvloc=[select Id, Total_Number_Of_Volunteer_Slots__c, Booked_Volunteer_Slots__c,recordtypeid,Event_Volunteer_Manager__c,status,
            Volunteer_Coordinator__c from Campaign where id  IN :evLocIds];
           
            
           list<user> LstUser = [select id, Volunteer_Coordinator_Coverage_Rate__c from User where id = :lstCoordinatorIds];
            
            //classes coverage
            CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
            CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
            ctHelper.calculateRollUpForRateCalculation(listEventLocation,listEvloc);
           
            test.stoptest();
        }
    
           public static testMethod void CampaignTriggerSwitch_test()
            {
                Test.StartTest() ; 
                 List<Campaign>  listEventLocation = createTestData_EventLocation(); 
                 insert listEventLocation;
                Test.StopTest() ;            
            }
}