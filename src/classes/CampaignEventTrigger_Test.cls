/*****************************************************************************************
    Name             : CampaignEventTrigger_Test
    Description      : Test Class to cover all Campaign/Event/Event Location/Program scenarios               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAlldata = true)
public class CampaignEventTrigger_Test{
  

        public static testMethod void TriggerCampaign_Test()
    {   
          test.startTest();
       //   List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       // upsert listTriggerActivation;  
        
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
        insert user6;
        
           //Create Data
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar; // inserting first Program record       
        
        //------------Campaign record start---------------------      
        List<Campaign> listCampaign = new List<Campaign>();
        
        Campaign CampaignTest1=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'), status = 'Completed', Name = 'Test Campaign1', type = 'Acquisition',endDate = date.today(),
         Launch_Date__c = date.today(), Program__c = ProgramTestVar.id,Project_Manager__c = null, ownerid = user6.id,Overview__c = 'abcd',StartDate = date.today());//
       
        Campaign CampaignTest2=new Campaign(RecordtypeId=Utility.getRecordType('Campaign','Campaign'),status = 'Completed', Name = 'Test Campaign2', type = 'Acquisition', endDate = date.today(),
        Launch_Date__c = date.today(),Program__c = ProgramTestVar.id,Project_Manager__c = user6.id,Overview__c = 'abcd', ownerid = user6.id,StartDate = date.today());// 
        
        listCampaign.add(CampaignTest1);
        listCampaign.add(CampaignTest2);
        insert listCampaign;
        //------------Campaign record End---------------------      
        
          System.AssertEquals('Completed',listCampaign[0].status );
        
         //---------------Budget/Expense record start-----------
        List<BudgetExpense__c >  listBudgetExpense = new List<BudgetExpense__c >();  
        BudgetExpense__c BudgetExpenseTest1=new BudgetExpense__c(Campaign__c=CampaignTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign','BudgetExpense__c'),Name='BudgetExpense',Category__c = 'Travel', Budget__c = 23, Expense__c = 23 );
        BudgetExpense__c BudgetExpenseTest2=new BudgetExpense__c(Campaign__c=CampaignTest2.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense2',Category__c = 'Postage', Budget__c = 23, Expense__c = 23  );
        BudgetExpense__c BudgetExpenseTest3=new BudgetExpense__c(Campaign__c=CampaignTest2.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense3',Category__c = 'Displays', Budget__c = 23, Expense__c = 23  );
        listBudgetExpense.add(BudgetExpenseTest1);
        listBudgetExpense.add(BudgetExpenseTest2);
        listBudgetExpense.add(BudgetExpenseTest3);
         insert listBudgetExpense;
        //---------------Budget/Expense record start----------- 
         System.AssertEquals('Travel',listBudgetExpense[0].Category__c );
         
        Campaign ProgramTestVar2=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program2',Projected_Budget__c=2300);
        insert ProgramTestVar2; // inserting second Program record    
        
        CampaignTest1.Program__c = ProgramTestVar2.id; 
        update CampaignTest1;   // updating campaign record with new Program     
        CampaignTest2.Program__c = ProgramTestVar2.id;       
        update CampaignTest2;   // updating campaign record with new Program     
        
        listBudgetExpense[0].Budget__c = 27;        
        listBudgetExpense[1].Budget__c = 27;
        listBudgetExpense[2].Budget__c = 27;        
        update listBudgetExpense;   //Updating Budget in BudgetExpense object.    
        System.AssertEquals(27,listBudgetExpense[0].Budget__c );    
        delete listBudgetExpense[0]; // delete BudgetExpense scenario.
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        insert Agency;
        
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=CampaignTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        //Shanu- Changes made for COR0001562
        Name='Deliverable1',Status__c='In Progress',Assigned_To__c = user6.id,Agency__c = Agency.id,Do_Not_Auto_Populate_Tasks__c=false );
        insert deliverableTest1;
        
        //Task task1=new task(WhatId=CampaignTest1.Id, Status='Not Available');
        //insert task1;
        
        CampaignTest1.status ='Cancelled';
        CampaignTest1.Status_Reason__c = 'test reason';
        update CampaignTest1;
        
        //CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        //CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        //EventTriggerHelper etHelper = new EventTriggerHelper();
         
        test.stopTest(); 
     }
         
        public static testMethod void TriggerEvent_Test()
    {   
    
       //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       // upsert listTriggerActivation; 
        
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
        insert user6;
        
           //Create Data
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar; // inserting Program record     
        
      //  Account EventOrigin =new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test',Business_Email__c='test@test.com');
      //  insert EventOrigin;   //Creating EventOrigin
        
         //------------Event record start---------------------    
        List<Campaign> listEvent=new List<Campaign>();
        
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition',
        EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, ownerid = user6.id,
        endDate = date.today(),StartDate = date.today());//EVE_Origin__c = EventOrigin.id,
        
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', 
        EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, ownerid = user6.id,
        endDate = date.today(),StartDate = date.today());//, EVE_Origin__c = EventOrigin.id
        
        listEvent.add(EventTest1);
        listEvent.add(EventTest2);
        
        test.startTest();
        insert listEvent; 
        test.stopTest();
         //------------Event record End---------------------   
         System.AssertEquals('Acquisition',listEvent[0].type);     
         
        //---------------Budget/Expense record start-----------
        List<BudgetExpense__c >  listBudgetExpense = new List<BudgetExpense__c >();  
        //BudgetExpense__c BudgetExpenseTest1=new BudgetExpense__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense',Category__c = 'Travel', Budget__c = 23, Expense__c = 23 );
        BudgetExpense__c BudgetExpenseTest2=new BudgetExpense__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense2',Category__c = 'Postage', Budget__c = 23, Expense__c = 23  );
        BudgetExpense__c BudgetExpenseTest3=new BudgetExpense__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense3',Category__c = 'Displays', Budget__c = 23, Expense__c = 23  );
        //listBudgetExpense.add(BudgetExpenseTest1);
        listBudgetExpense.add(BudgetExpenseTest2);
        listBudgetExpense.add(BudgetExpenseTest3);
        insert listBudgetExpense;
        //---------------Budget/Expense record start-----------   
         System.AssertEquals('Postage',listBudgetExpense[0].Category__c );   
        
        Campaign ProgramTestVar2=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program2',Projected_Budget__c=2300);
        insert ProgramTestVar2; // inserting second Program record    
        
       
        EventTest1.Program__c = ProgramTestVar2.id; 
        update EventTest1;   // updating Event record with new Program     
        EventTest1.Program__c = ProgramTestVar2.id;      
        update EventTest2;   // updating Event record with new Program  
         
        
        listBudgetExpense[0].Budget__c = 27;        
        listBudgetExpense[1].Budget__c = 27;
        //listBudgetExpense[2].Budget__c = 27;        
        update listBudgetExpense;    //Updating Budget in BudgetExpense object.   
          System.AssertEquals(27,listBudgetExpense[0].Budget__c );        
        delete listBudgetExpense[0]; // delete BudgetExpense scenario.
        
        Goals__c GoalsTest5=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        Goals__c GoalsTest6=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        Goals__c GoalsTest7=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Revenue' ,Product__c = 'Number', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        Goals__c GoalsTest8=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'Continuity', Funds__c = 'Bibles', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        insert GoalsTest5;
        //insert GoalsTest6;
        //insert GoalsTest7;
        //insert GoalsTest8;
        
         System.AssertEquals(23,GoalsTest5.Rate__c);   
        
        Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        insert Agency;
        
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        //Shanu- Changes made for COR0001562
        Name='Deliverable1',Status__c='In Progress',Assigned_To__c = user6.id,Agency__c = Agency.id, Do_Not_Auto_Populate_Tasks__c=false );
    
        insert deliverableTest1;
        /*
         System.AssertEquals('In Progress',deliverableTest1.Status__c);   
        
        Task task1=new task(WhatId=EventTest1.Id, Status='Not Available');
        insert task1;
        
        EventTest1.status ='Cancelled';
        EventTest1.Status_Reason__c = 'test reason';
        EventTest1.Cancellation_Reason__c = 'Test Cancel Reason';
        update EventTest1;
    
        System.AssertEquals('Cancelled',EventTest1.status);   
        
        CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        EventTriggerHelper etHelper = new EventTriggerHelper();
        */
              
         
     }
     public static testMethod void TriggerEvent_Test2()
     {
         test.startTest();
    
       //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       // upsert listTriggerActivation; 
        
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
        insert user6;
        
           //Create Data
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar; // inserting Program record     
        
      //  Account EventOrigin =new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test',Business_Email__c='test@test.com');
      //  insert EventOrigin;   //Creating EventOrigin
        
         //------------Event record start---------------------    
        List<Campaign> listEvent=new List<Campaign>();
        
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition',
        EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, ownerid = user6.id,
        endDate = date.today(),StartDate = date.today());//EVE_Origin__c = EventOrigin.id,
        
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', 
        EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, ownerid = user6.id,
        endDate = date.today(),StartDate = date.today());//, EVE_Origin__c = EventOrigin.id
        
        listEvent.add(EventTest1);
        //listEvent.add(EventTest2);
        insert listEvent; 
         //------------Event record End---------------------   
         System.AssertEquals('Acquisition',listEvent[0].type);     
         
        //---------------Budget/Expense record start-----------
        List<BudgetExpense__c >  listBudgetExpense = new List<BudgetExpense__c >();  
        BudgetExpense__c BudgetExpenseTest1=new BudgetExpense__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense',Category__c = 'Travel', Budget__c = 23, Expense__c = 23 );
        //BudgetExpense__c BudgetExpenseTest2=new BudgetExpense__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense2',Category__c = 'Postage', Budget__c = 23, Expense__c = 23  );
        //BudgetExpense__c BudgetExpenseTest3=new BudgetExpense__c(Campaign__c=EventTest2.Id,RecordTypeId=Utility.getRecordtype('Event','BudgetExpense__c'),Name='BudgetExpense3',Category__c = 'Displays', Budget__c = 23, Expense__c = 23  );
        listBudgetExpense.add(BudgetExpenseTest1);
        //listBudgetExpense.add(BudgetExpenseTest2);
        //listBudgetExpense.add(BudgetExpenseTest3);
        insert listBudgetExpense;
        //---------------Budget/Expense record start-----------   
         System.AssertEquals('Travel',listBudgetExpense[0].Category__c );   
        
        //Campaign ProgramTestVar2=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program2',Projected_Budget__c=2300);
        //insert ProgramTestVar2; // inserting second Program record    
        
        EventTest1.Program__c = ProgramTestVar.id; 
        //update EventTest1;   // updating Event record with new Program     
        //EventTest1.Program__c = ProgramTestVar2.id;      
        //update EventTest2;   // updating Event record with new Program     
        
        listBudgetExpense[0].Budget__c = 27;        
        //listBudgetExpense[1].Budget__c = 27;
        //listBudgetExpense[2].Budget__c = 27;        
        update listBudgetExpense;    //Updating Budget in BudgetExpense object.   
          System.AssertEquals(27,listBudgetExpense[0].Budget__c );        
        delete listBudgetExpense[0]; // delete BudgetExpense scenario.
        
        Goals__c GoalsTest5=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        //Goals__c GoalsTest6=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        //Goals__c GoalsTest7=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Revenue' ,Product__c = 'Number', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        //Goals__c GoalsTest8=new Goals__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'Continuity', Funds__c = 'Bibles', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        insert GoalsTest5;
        //insert GoalsTest6;
        //insert GoalsTest7;
        //insert GoalsTest8;
        
         System.AssertEquals(23,GoalsTest5.Rate__c);   
        
        //Account Agency = new Account(recordtypeId=Utility.getRecordType('Agency','Account'),Name='Test',Business_Email__c='test@test.com');
        //insert Agency;
        
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Deliverable','Deliverable__c'),
        //Shanu- Changes made for COR0001562
        Name='Deliverable1',Status__c='In Progress',Assigned_To__c = user6.id , Do_Not_Auto_Populate_Tasks__c=false);
        insert deliverableTest1;
        
         System.AssertEquals('In Progress',deliverableTest1.Status__c);   
        
        //Task task1=new task(WhatId=EventTest1.Id, Status='Not Available');
        //insert task1;
        
        EventTest1.status ='Cancelled';
        EventTest1.Status_Reason__c = 'test reason';
        EventTest1.Cancellation_Reason__c = 'Test Cancel Reason';
        update EventTest1;
        test.stopTest();
        System.AssertEquals('Cancelled',EventTest1.status);   
        
        CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        EventTriggerHelper etHelper = new EventTriggerHelper();
     }
     
     
        public static testMethod void TriggerEventLocation_Test()
    {    
       
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
     //   upsert listTriggerActivation; 
        
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
        insert user6;
        
           //Create Data
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3400);
        insert ProgramTestVar; // inserting Program record 
        
      //  Account EventOrigin =new Account(recordtypeId=Utility.getRecordType('Partner','Account'),Name='Test',Business_Email__c='test@test.com');
      //  insert EventOrigin;   //Creating EventOrigin
        
         //------------Event record start---------------------    
        List<Campaign> listEvent=new List<Campaign>();
        
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1', status ='Draft', type = 'Acquisition',
        EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, ownerid = user6.id,
        endDate = date.today(),StartDate = date.today());//EVE_Origin__c = EventOrigin.id,
        
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', 
        EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, ownerid = user6.id,
        endDate = date.today(),StartDate = date.today());// EVE_Origin__c = EventOrigin.id,
        
        listEvent.add(EventTest1);
        //listEvent.add(EventTest2);
        insert listEvent; 
         //------------Event record End--------------------- 
          System.AssertEquals('Event',listEvent[0].Track_Goals_At__c);             
         
         Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        //--------------Event Location record start-----------
         List<Campaign> listEventLocation=new List<Campaign>();
         
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc1', status ='Scheduled', 
        Event__c = EventTest1.id,Venue__c = ven.id, Volunteer_Coordinator__c = user6.id, ownerid = user6.id,//Event_Volunteer_Manager__c = user6.id,Number_Of_Booths_Tables__c=23,
        Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel', Estimated_Sponsorships__c = 23,Estimated_Continuity__c = 23,
        Actual_Sponsorships_On_FCD__c = 23, Actual_Revenue__c = 23, Actual_Revenue_On_FCD__c = 23, Actual_Impact__c = 23, Actual_Impact_On_FCD__c = 23,
        Actual_Continuity_On_FCD__c = 23);
             
        //Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
       // Venue__c = ven.id, Volunteer_Coordinator__c = null,// Event_Volunteer_Manager__c = user6.id, ownerid = user6.id, Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true,
       // Estimated_Audience_Size__c = 23, Cancellation_Reason__c = 'test Cancel');
                
        listEventLocation.add(EventLocationTest1);
        //listEventLocation.add(EventLocationTest2);
        insert listEventLocation;
         //--------- event Location record end----------------   
        
        //-----Volunteer Slot start------
        List<Volunteer_Shift__c> listVSTest=new List<Volunteer_Shift__c>();    
        Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
        Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
        listVSTest.add(VSTest1);
        //listVSTest.add(VSTest2);
        insert listVSTest;
        //-----Volunteer Slot stop------
        Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
        insert volunteerTest;   //Creating Volunteer
        
        List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c = :listVSTest[0].Id]; //Getting newly created Volunteer Slots
        //system.debug('>>>>>>>'+ listVSlotTest);
        listVSlotTest[0].Volunteer__c=volunteerTest.Id;
        listVSlotTest[0].Status__c='Approved';        
        update listVSlotTest[0];
         List<Goals__c> goal = new List<Goals__c>();       
        Goals__c GoalsTest9=new Goals__c(Campaign__c=EventLocationTest1.Id,RecordTypeId=Utility.getRecordtype('Campaign Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'CDSP', Funds__c = 'Designated Support', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        Goals__c GoalsTest10=new Goals__c(Campaign__c=EventLocationTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Awareness' ,Product__c = 'CIV', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        //Goals__c GoalsTest11=new Goals__c(Campaign__c=EventLocationTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Revenue' ,Product__c = 'Number', Funds__c = 'Bibles',  Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        //Goals__c GoalsTest12=new Goals__c(Campaign__c=EventLocationTest1.Id,RecordTypeId=Utility.getRecordtype('Event Goals','Goals__c'),Goal_Type__c ='Acquisition' ,Product__c = 'Continuity', Funds__c = 'Bibles', Rate__c = 23 , Revenue_Target__c = 23, Target_Number__c = 23 ,CIV_ID__c = '23', Status__c = 'Scheduled',Lifetime_Cost__c = 23, Lifetime_Revenue__c = 23 );
        goal.add(GoalsTest9);
        goal.add(GoalsTest10);
        //goal.add(GoalsTest11);
        //goal.add(GoalsTest12);
        insert goal;
        //Task task1=new task(WhatId=EventLocationTest1.Id, Status='Not Available');
        //insert task1;
        
        test.startTest();
        EventLocationTest1.status ='Cancelled';
        update EventLocationTest1;
        
        //EventLocationTest1.status ='Location Lost';
        //update EventLocationTest1;
        
        // EventTest1.status ='Cancelled';
        //EventTest1.Status_Reason__c = 'test reason';
       // EventTest1.Cancellation_Reason__c = 'Test Cancel Reason';
       // update EventTest1;
      //  Id EvLocRecTypeId = new id();
        // list<Campaign> listCampaigns = [select id, Status,Cancellation_Reason__c from Campaign where Event__r.id =:EventTest1.id and recordtypeid =: Utility.getRecordType('Event Location','Campaign')];
        
       // EventTest1.Status = 'Confirmed';
        //EventTest1.Publish_to_Web__c = true;
        //update EventTest1;
        
         //System.AssertEquals('Confirmed',EventTest1.Status);    
        
         //list<Campaign> listNewEvLoc = [select id, Status from Campaign where Event__r.id =:EventTest1.id];
                 
        //CampaignTriggerHandler ctHandler = new CampaignTriggerHandler();
        //CampaignTriggerHelper ctHelper = new CampaignTriggerHelper();
        //EventTriggerHelper etHelper = new EventTriggerHelper();
        
        test.stopTest(); 
     }
         
   }