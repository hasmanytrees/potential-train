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
public class CampaignTrigger2_Test{

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
        EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, ownerid = listUser[1].id,
        endDate = date.today(),StartDate = date.today());//EVE_Origin__c = EventOrigin.id,
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', 
        EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location',  Program__c = ProgramTestVar.id, ownerid = listUser[1].id,
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
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1',  status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');//EVE_Origin__c = EventOrigin.id,
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location', Program__c = ProgramTestVar.id, Cancellation_Reason__c = 'test Cancel');
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
    
        Campaign EventLocationTest3=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=4, Packet_Pass_Needed__c = true,
        Estimated_Audience_Size__c = 4500 , Cancellation_Reason__c = 'test Cancel'); 
        
        Campaign EventLocationTest4=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=2 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 1250, Cancellation_Reason__c = 'test Cancel');
        
        Campaign EventLocationTest5=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=1 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 1250, Cancellation_Reason__c = 'test Cancel');
        
        Campaign EventLocationTest6=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=2 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 1251, Cancellation_Reason__c = 'test Cancel');
        
        Campaign EventLocationTest7=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=2 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 1249, Cancellation_Reason__c = 'test Cancel');
        
        Campaign EventLocationTest8 =new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=99 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 100 , Cancellation_Reason__c = 'test Cancel');
        
        Campaign EventLocationTest9 =new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=99 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 101 , Cancellation_Reason__c = 'test Cancel');
         
        Campaign EventLocationTest10 =new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=99 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 99 , Cancellation_Reason__c = 'test Cancel');
        
        Campaign EventLocationTest11 =new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2', status ='Scheduled',Event__c = EventTest2.id,
        Venue__c = ven.id, Volunteer_Coordinator__c = null, Event_Volunteer_Manager__c = listUser[3].id, ownerid = listUser[2].id, Number_Of_Booths_Tables__c=1 , Packet_Pass_Needed__c = false,
        Estimated_Audience_Size__c = 99 , Cancellation_Reason__c = 'test Cancel');
        
         
        listEventLocation.add(EventLocationTest1);
        listEventLocation.add(EventLocationTest2);        
        listEventLocation.add(EventLocationTest3);
        listEventLocation.add(EventLocationTest4);
        listEventLocation.add(EventLocationTest5);
        listEventLocation.add(EventLocationTest6);
        listEventLocation.add(EventLocationTest7);
        listEventLocation.add(EventLocationTest8);
        listEventLocation.add(EventLocationTest9);
        listEventLocation.add(EventLocationTest10);
        listEventLocation.add(EventLocationTest11);
        return listEventLocation;
        
        
     }
     
     public static testMethod void createCampaignBasedTasks_Test()
    {  

        Test.startTest();        
        Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event1',  status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event');
        insert EventTest1;
        //Shanu- Changes made for COR0001562
        Deliverable__c deliverableTest1=new Deliverable__c(Campaign__c=EventTest1.Id,RecordTypeId=Utility.getRecordtype('Event Deliverable','Deliverable__c'),Type__c = 'Inventory',Name='Deliverable1',Status__c='Confirmed', Do_Not_Auto_Populate_Tasks__c=false);
        insert deliverableTest1;  
        System.AssertEquals(EventTest1.Id,deliverableTest1.Campaign__c);      
        Test.StopTest() ; 
        
    }  
    
    public static testMethod void ManagerCalcualtionCoverage()
    {
        Test.startTest();
        
        Id pId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User u = [select id from User where ProfileId = :pId LIMIT 1];
        User user6 = new User();
        user6.Username= 'testusertest66@test.com';
        user6.Email= 'test6@test.com';
        user6.Lastname= 'user';
        user6.Firstname= 'test66';
        user6.Alias= 'test';
        user6.ProfileId = pId;
        user6.TimeZoneSidKey= 'GMT';
        user6.LocaleSidKey= 'en_US';
        user6.Managerid = userinfo.getuserid();
        user6.EmailEncodingKey= 'ISO-8859-1';
        user6.LanguageLocaleKey= 'en_US';
        user6.Authorized_Campaign_Owner__c=true;
        user6.UserPermissionsMobileUser = true;
        user6.ManagerId= u.id;
        insert user6;
        
        User user = new User();
        user.Username= 'testuserte212st66@test.com';
        user.Email= 'te121st6@test.com';
        user.Lastname= 'user121';
        user.Firstname= 'test66';
        user.Alias= 'test11';
        user.ProfileId = pId;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.Managerid = userinfo.getuserid();
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.Authorized_Campaign_Owner__c=true;
        user.UserPermissionsMobileUser = true;
        user.ManagerId= u.id;
        insert user;
        
        Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), Name = 'Test Event2', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c='Event Location');
        insert EventTest2;
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        Campaign EventLocationTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Loc2',Event_Volunteer_Manager__c = user.id, Volunteer_Coordinator__c = user6.id , status ='Completed',Event__c = EventTest2.id,
        Venue__c = ven.id);    
        insert EventLocationTest2;
        
        
        List<Volunteer_Shift__c> listVSTest=new List<Volunteer_Shift__c>();    
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest2.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5, Volunteer_Role__c='Developer');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventLocationTest2.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6, Volunteer_Role__c='Coach');
            listVSTest.add(VSTest1);
            listVSTest.add(VSTest2);
            insert listVSTest;
            //-----Volunteer Slot stop------
            
             System.AssertEquals('Developer', listVSTest[0].Volunteer_Role__c);      
            
            Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            
            List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c = :listVSTest[0].Id]; //Getting newly created Volunteer Slots
            listVSlotTest[0].Volunteer__c=volunteerTest.Id;
            listVSlotTest[0].Status__c='Approved';        
            update listVSlotTest[0];
        //EventLocationTest2.Volunteer_Coordinator__c = user6.id;
        //update EventLocationTest2;
        
        EventLocationTest2.Volunteer_Coordinator__c = user.id;
        EventLocationTest2.Event_Volunteer_Manager__c = u.id;
        update EventLocationTest2;
        
        
        
        Test.stopTest();    
    }
    
    
    public static testMethod void createUpdateCampaign_Test()
    {  

        
        List<Campaign>  listCampaign = createTestData_Campaign(); 
        insert listCampaign;
        
        For (Campaign oCampgnRec : listCampaign ) {
            oCampgnRec.ownerID = UserInfo.getUserID () ; 
            
        } 
        Test.startTest();
        update listCampaign ; 
        system.Assert( listCampaign[0].ownerID!= NULL) ; 
        Test.StopTest() ; 
        
    } 
    
    public static testMethod void ShareUnshareCampaign_Test()
    { 
        List<Account> lstAccount = new List<Account> () ; 
        Account oAccountVar1 =new Account(Type='Business',Status__c='Active',Name='Testdata1' , Business_Phone__c='897899999999789' ) ; 
        lstAccount.add( oAccountVar1 ) ;
        Account oAccountVar2 =new Account(Type='Business',Status__c='Active',Name='dataTest1' , Business_Phone__c='123453142334124' ) ; 
        lstAccount.add( oAccountVar2 ) ;
        insert  lstAccount ;      
        List<Campaign>  listCampaign = createTestData_Campaign();
        listCampaign[0].Agency__c =  oAccountVar2.ID ; 
            insert  listCampaign ; 
        Test.StartTest() ;    
        listCampaign[0].Agency__c = oAccountVar1.ID ; 
        update listCampaign ; 
        Test.StopTest() ;  
    }
    
    public static testMethod void eventCampaign_Test()
    {
        Campaign ProgramTestVar=new Campaign(RecordtypeId=Utility.getRecordType('Program','Campaign'),Name='Test Program',Projected_Budget__c=3410);
        insert ProgramTestVar;
        List <Campaign> eventList = createTestData_Event() ;   
        eventList[0].Total_Budget__c = 45234235;  
        eventList[0].Total_Expense__c = 425345 ; 
        eventList[1].Program__c = NULL ; 
      //  Program__c , Total_Budget__c , =    
        Test.StartTest() ; 
            insert eventList ; 
        eventList[0].Program__c = ProgramTestVar.ID; 
        eventList[1].Program__c = ProgramTestVar.ID;    
        Test.StopTest() ;   
    }
    
    public static testMethod void createEventLocation_Test()
    {  
       List<VolunteerSizeDetermination__c> lstVolunteerDataSet = new List<VolunteerSizeDetermination__c> () ;  
       VolunteerSizeDetermination__c oCustomStngData = new VolunteerSizeDetermination__c ( Name = 'Rule 111', Number_Of_Booths_Tables__c=1 , Booth_Operator__c = '=' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 1250 , Event_Audience_Size_Operator__c = '=') ; 
       lstVolunteerDataSet.add(oCustomStngData ) ;  
          
       VolunteerSizeDetermination__c oCustomStngData1 = new VolunteerSizeDetermination__c ( Name = 'Rule 112', Number_Of_Booths_Tables__c=1 , Booth_Operator__c = '>' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 1250 , Event_Audience_Size_Operator__c = '=') ; 
       lstVolunteerDataSet.add(oCustomStngData1 ) ;  
       
       VolunteerSizeDetermination__c oCustomStngData2 = new VolunteerSizeDetermination__c ( Name = 'Rule 113', Number_Of_Booths_Tables__c=1 , Booth_Operator__c = '>' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 1250 , Event_Audience_Size_Operator__c = '>') ; 
       lstVolunteerDataSet.add(oCustomStngData2 ) ; 
       
       VolunteerSizeDetermination__c oCustomStngData3 = new VolunteerSizeDetermination__c ( Name = 'Rule 114', Number_Of_Booths_Tables__c=1 , Booth_Operator__c = '>' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 1250 , Event_Audience_Size_Operator__c = '<') ; 
       lstVolunteerDataSet.add(oCustomStngData3 ) ;
       
       
       VolunteerSizeDetermination__c oCustomStngData4 = new VolunteerSizeDetermination__c ( Name = 'Rule 115', Number_Of_Booths_Tables__c=100 , Booth_Operator__c = '<' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 100 , Event_Audience_Size_Operator__c = '=') ; 
       lstVolunteerDataSet.add(oCustomStngData4 ) ; 
       
       VolunteerSizeDetermination__c oCustomStngData5 = new VolunteerSizeDetermination__c ( Name = 'Rule 116', Number_Of_Booths_Tables__c=100 , Booth_Operator__c = '<' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 100 , Event_Audience_Size_Operator__c = '>') ; 
       lstVolunteerDataSet.add(oCustomStngData5 ) ; 
       
       VolunteerSizeDetermination__c oCustomStngData6 = new VolunteerSizeDetermination__c ( Name = 'Rule 117', Number_Of_Booths_Tables__c=100 , Booth_Operator__c = '<' , 
                                                       Packet_Pass_Needed__c = false , Event_Audience_Size__c = 100 , Event_Audience_Size_Operator__c = '<') ; 
       lstVolunteerDataSet.add(oCustomStngData6 ) ; 
       
       insert lstVolunteerDataSet ; 
                                                           
       List<Campaign>  listCampaign = createTestData_EventLocation(); 
       List<Campaign>  listCampaign2 = listCampaign.deepclone(); 
        Test.startTest();
        insert listCampaign;
        System.Assert( listCampaign != NULL ) ; 
        Test.StopTest() ; 
  
    }    

}