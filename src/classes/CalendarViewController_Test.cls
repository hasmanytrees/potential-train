/*****************************************************************************************
    Name             : CalendarViewController_Test
    Description      : Test class for Controller of Calender_View vf page        
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class CalendarViewController_Test{
   
   //Create Test data
 
        private static void createTestData()
    {
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    
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
        
        List<sObject> listTestData=new List<sObject>();
        
        Campaign campaignVar1=new Campaign(ownerId=user.Id,Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));
        
        Campaign campaignVar2=new Campaign(ownerId=user.Id,Name='Campaign2',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));
        
        //listTestData.add(campaignVar1);
        insert campaignVar1;
        listTestData.add(campaignVar2);
        
        Deliverable__c deliverableVar1=new Deliverable__c(recordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'),Type__c='BRC',Drop_Date__C=system.today(),
        Due_Date__c=system.today().addDays(7),Name='Deliverable1',Status__c='Confirmed', Campaign__c = campaignVar1.id);

        Deliverable__c deliverableVar2=new Deliverable__c(recordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'),Type__c='BRC',Drop_Date__C=system.today(),
        Due_Date__c=system.today().addDays(8),Name='Deliverable2',Status__c='Completed', Campaign__c = campaignVar1.id);
        
        listTestData.add(deliverableVar2);
        listTestData.add(deliverableVar1);
        
        Campaign eventTest1=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');        
        insert eventTest1;
        //Campaign eventTest2=new Campaign(Name='Event2',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        //Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');
        
        //listTestData.add(eventTest1);
        //listTestData.add(eventTest2);
        
         Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Adak' , State__c ='Alaska', ZIP_Code__c='99546', Country__c='United States');
        insert Ven; // Initializing Venue Record
        
        System.assertEquals('Adak',ven.City__c );
        
        Campaign eventLocTest1=new Campaign(Name='Event Location1',recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3), EVE_Start_Time__c = '08:00 AM', EVE_End_Time__c = '08:30 AM', status = 'Scheduled', Event__c = eventTest1.id , Venue__c = ven.id);
        
      //  Campaign eventLocTest2=new Campaign(Name='Event Location2',recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
      //  Launch_Date__c=System.today().addDays(3),EVE_Start_Time__c = '11:00 AM', EVE_End_Time__c = '11:30 AM', status = 'Scheduled', Event__c = eventTest2.id, Venue__c = ven.id );
        
        listTestData.add(eventLocTest1);
      //  listTestData.add(eventLocTest2);
        insert listTestData;
       // Event testEvent=new Event(Subject='Test',StartDateTime=system.now(),endDateTime=system.now().addHours(2),OwnerId=user.Id,whatId=((Campaign)listTestData[3]).Id);
       // insert testEvent;
            
    //------------test data-----
    }

        public static testMethod void testCalenderView_EvLoc()
    {
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
     
         Campaign eventTest1=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');  
        insert eventTest1;       
        createTestData();
        
      Test.startTest();
       
        //Test.stopTest();
        PageReference pageRef=Page.CalendarView;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('type','Deliverable');

        CalendarViewController controllerRef=new CalendarViewController();
       
        controllerRef.sVenueState= 'Alaska';
        controllerRef.sEventId = eventTest1.id;
         controllerRef.sSelectedFilter = 'Location';
        //Setting Page Parameters for various scenarios.
        ApexPages.currentPage().getParameters().put('type','Campaign');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Meeting');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Event Location');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Event');
        ApexPages.currentPage().getParameters().put('eventId',[select Id from Campaign where Name='Event1' Limit 1].Id);
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Meeting');
        ApexPages.currentPage().getParameters().put('eventId',[select Id from Campaign where Name='Event1' Limit 1].Id);
        controllerRef=new CalendarViewController();
        //Creating page Filters of different type
         
        
        controllerRef.oDeliverableFilter=new Deliverable__c(recordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'),Type__c='BRC',Drop_Date__C=system.today(),
        Due_Date__c=system.today().addDays(7),Name='Deliverable1',Status__c='Confirmed');        
        
        controllerRef.oCampaignFilter=new Campaign(Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));
        
        controllerRef.oEventFilter=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Awareness',EVE_Channel__c='Radio');
        
        controllerRef.oEventLocationFilter=new Campaign(Name='Event Location2',recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3));      
        
         System.assertEquals('Confirmed',controllerRef.oDeliverableFilter.Status__c);
        System.assertEquals('Draft',controllerRef.oCampaignFilter.Status);
        System.assertEquals('Confirmed',controllerRef.oEventFilter.Status);
        System.assertEquals('Event Location2',controllerRef.oEventLocationFilter.Name);  

        controllerRef.sSelectedFilter='Deliverable&Campaign&Event Location&Event';
        controllerRef.sEventId=[select Id from Campaign where Name='Event1' LIMIT 1].Id;
        controllerRef.sVenueState='Alaska';
         System.assertEquals('Alaska',controllerRef.sVenueState);
         
         controllerRef.lstSelectedSelectOption.add(new selectOption('-None-','-None-'));
          controllerRef.lstSelectedSelectOption.add(new selectOption('Name','Room Name'));
           controllerRef.lstSelectedSelectOption.add(new selectOption('Capacity__c','Room Capacity'));
        controllerRef.pageLoad();  //Covering all filter condition using test dummy data
        
        controllerRef.bIncludeMyEvents=true;
        PageReference pageRef2=controllerRef.toggleMyEvents();
        controllerRef.bIncludeMyEvents =false;
        pageRef2=controllerRef.toggleMyEvents();
        controllerRef.reset();
        //Running for Filter of Event Location
        controllerRef.sSelectedFilter='Event Location';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Deliverable
        controllerRef.sSelectedFilter='Deliverable';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Campaign
        controllerRef.sSelectedFilter='Campaign';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Event
        controllerRef.sSelectedFilter='Event';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        
        
        //Running for Filter of Meeting related to particular Event
        controllerRef.sSelectedFilter='Meeting';
          System.assertEquals('Meeting',controllerRef.sSelectedFilter);
          
        controllerRef.sEventId=[select whatId from Event LIMIT 1].whatId;
        
        
         list<Campaign> sQueryEventLocation=[select Id, Name,StartDate,EndDate,Type,State__c,EVE_Start_Time__c,EVE_End_Time__c from Campaign  where 
        recordtypeId=:Utility.getRecordType('Event Location','Campaign') and StartDate=:System.today().addDays(3) and EndDate=:System.today().addDays(8) and 
         State__c = 'Alaska' and Event__c =: eventTest1.id and  Id!=null and StartDate!=null and EndDate!=null and EVE_Start_Time__c!=null and EVE_End_Time__c!=null 
         and status!='Cancelled' and Status!='Location Lost' and Status!='Draft'] ;
         controllerRef.sEventId = eventTest1.id;
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        
         Test.stopTest();
    }
    
    
    public static testMethod void testCalenderView_EvLoc2()
    {
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
     
         Campaign eventTest1=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');  
        insert eventTest1;       
        createTestData();
        
      
       Test.startTest();
        //Test.stopTest();
        PageReference pageRef=Page.CalendarView;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('type','Deliverable');

        CalendarViewController controllerRef=new CalendarViewController();
       
        controllerRef.sVenueState= 'Alaska';
        controllerRef.sEventId = eventTest1.id;
         controllerRef.sSelectedFilter = 'Location';
        //Setting Page Parameters for various scenarios.
        ApexPages.currentPage().getParameters().put('type','Campaign');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Meeting');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Event Location');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Event');
        ApexPages.currentPage().getParameters().put('eventId',[select Id from Campaign where Name='Event1' Limit 1].Id);
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Meeting');
        ApexPages.currentPage().getParameters().put('eventId',[select Id from Campaign where Name='Event1' Limit 1].Id);
        controllerRef=new CalendarViewController();
        //Creating page Filters of different type
         
        
        controllerRef.oDeliverableFilter=new Deliverable__c(recordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'),Type__c='BRC',Drop_Date__C=system.today(),
        Due_Date__c=system.today().addDays(7),Name='Deliverable1',Status__c='Confirmed');        
        
        controllerRef.oCampaignFilter=new Campaign(Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));
        
        controllerRef.oEventFilter=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Awareness',EVE_Channel__c='Radio');
        
        controllerRef.oEventLocationFilter=new Campaign(Name='Event Location2',recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3));      
        
         System.assertEquals('Confirmed',controllerRef.oDeliverableFilter.Status__c);
        System.assertEquals('Draft',controllerRef.oCampaignFilter.Status);
        System.assertEquals('Confirmed',controllerRef.oEventFilter.Status);
        System.assertEquals('Event Location2',controllerRef.oEventLocationFilter.Name);  

        controllerRef.sSelectedFilter='Deliverable&Campaign&Event Location&Event';
        controllerRef.sEventId=[select Id from Campaign where Name='Event1' LIMIT 1].Id;
        controllerRef.sVenueState='Alaska';
         System.assertEquals('Alaska',controllerRef.sVenueState);
         
         controllerRef.lstSelectedSelectOption.add(new selectOption('-None-','-None-'));
          controllerRef.lstSelectedSelectOption.add(new selectOption('Name','Room Name'));
           controllerRef.lstSelectedSelectOption.add(new selectOption('Capacity__c','Room Capacity'));
        controllerRef.pageLoad();  //Covering all filter condition using test dummy data
        
        controllerRef.bIncludeMyEvents=true;
        PageReference pageRef2=controllerRef.toggleMyEvents();
        controllerRef.bIncludeMyEvents =false;
        pageRef2=controllerRef.toggleMyEvents();
        controllerRef.reset();
        //Running for Filter of Event Location
        controllerRef.sSelectedFilter='Event Location';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Deliverable
        controllerRef.sSelectedFilter='Deliverable';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Campaign
        controllerRef.sSelectedFilter='Campaign';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Event
        controllerRef.sSelectedFilter='Event';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        
        
        //Running for Filter of Meeting related to particular Event
        controllerRef.sSelectedFilter='Meeting';
          System.assertEquals('Meeting',controllerRef.sSelectedFilter);
          
        controllerRef.sEventId=[select whatId from Event LIMIT 1].whatId;
        
        
         list<Campaign> sQueryEventLocation=[select Id, Name,StartDate,EndDate,Type,State__c,EVE_Start_Time__c,EVE_End_Time__c from Campaign  where 
        recordtypeId=:Utility.getRecordType('Event Location','Campaign') and StartDate=:System.today().addDays(3) and EndDate=:System.today().addDays(8) and 
         State__c = 'Alaska' and Event__c =: eventTest1.id and  Id!=null and StartDate!=null and EndDate!=null and EVE_Start_Time__c!=null and EVE_End_Time__c!=null 
         and status!='Cancelled' and Status!='Location Lost' and Status!='Draft'] ;
         controllerRef.sEventId = eventTest1.id;
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        
         Test.stopTest();
    }
    
          public static testMethod void testCalenderView_Event2()
      {
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
     Test.startTest();
        Campaign eventTest1=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(-8),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');  
        insert eventTest1;
        Event e = new Event(subject = 'Test', StartDateTime = System.now(), EndDateTime = System.now(), WhatId = eventTest1.id);
        insert e;
        Campaign eventTest2=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(-8),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');  
        insert eventTest2;
        
               
        ApexPages.currentPage().getParameters().put('type','Event');
        ApexPages.currentPage().getParameters().put('eventId',eventTest1.Id);
        CalendarViewController controllerRef=new CalendarViewController();
        controllerRef.oEventFilter = eventTest2;
        controllerRef.pageLoad();
        controllerRef.sSelectedFilter = 'Meeting';
        System.assertEquals('Meeting',controllerRef.sSelectedFilter);
        controllerRef.pageLoad();
         Test.stopTest();
    }
    
    
    
    
          public static testMethod void testCalenderView_Event()
      {
         //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
     
        Campaign eventTest1=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',EVE_Channel__c='Radio');  
        insert eventTest1;       
        createTestData();
        Test.startTest();
        
                       
        //Test.stopTest();
        PageReference pageRef=Page.CalendarView;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('type','Deliverable');

        CalendarViewController controllerRef=new CalendarViewController();
        controllerRef.lstSelectedSelectOption.add(new selectOption('-None-','-None-'));
        controllerRef.sVenueState= 'Alaska';
        controllerRef.sEventId = eventTest1.id;
         controllerRef.sSelectedFilter = 'Event';
        //Setting Page Parameters for various scenarios.
        ApexPages.currentPage().getParameters().put('type','Campaign');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Meeting');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Event Location');
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Event');
        ApexPages.currentPage().getParameters().put('eventId',[select id from Campaign where Name='Event1' LIMIT 1].Id);
        controllerRef=new CalendarViewController();
        ApexPages.currentPage().getParameters().put('type','Meeting');
        ApexPages.currentPage().getParameters().put('eventId',[select id from Campaign where Name='Event1' LIMIT 1].Id);
        controllerRef=new CalendarViewController();
        //Creating page Filters of different type
        
        
        controllerRef.oDeliverableFilter=new Deliverable__c(recordtypeId=Utility.getRecordType('Campaign Deliverable','Deliverable__c'),Type__c='BRC',Drop_Date__C=system.today(),
        Due_Date__c=system.today().addDays(7),Name='Deliverable1',Status__c='Confirmed');        
                
        controllerRef.oCampaignFilter=new Campaign(Name='Campaign1',recordtypeId=Utility.getRecordType('Campaign','Campaign'),Status='Draft',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Revenue',Date_Of_Submission__c=System.today().addDays(2));
        
        controllerRef.oEventFilter=new Campaign(Name='Event1',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Confirmed',StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3),Type='Awareness',EVE_Channel__c='Radio');
        
        controllerRef.oEventLocationFilter=new Campaign(Name='Event Location2',recordtypeId=Utility.getRecordType('Event Location','Campaign'),StartDate=System.today().addDays(3),EndDate=System.today().addDays(8),
        Launch_Date__c=System.today().addDays(3));
        
        System.assertEquals('Confirmed',controllerRef.oDeliverableFilter.Status__c);
        System.assertEquals('Draft',controllerRef.oCampaignFilter.Status);
        System.assertEquals('Confirmed',controllerRef.oEventFilter.Status);
        System.assertEquals('Event Location2',controllerRef.oEventLocationFilter.Name);
        
        controllerRef.sSelectedFilter='Deliverable&Campaign&Event Location&Event';
        controllerRef.sEventId=[select Id from Campaign where Name='Event Location1' limit 1].Id;
        controllerRef.sVenueState='Alaska';
        
         System.assertEquals('Alaska',controllerRef.sVenueState);
         
        controllerRef.pageLoad();  //Covering all filter condition using test dummy data
        
        controllerRef.bIncludeMyEvents=true;
        PageReference pageRef2=controllerRef.toggleMyEvents();
        controllerRef.bIncludeMyEvents =false;
        pageRef2=controllerRef.toggleMyEvents();
        controllerRef.reset();
        //Running for Filter of Event Location
        controllerRef.sSelectedFilter='Event Location';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Deliverable
        controllerRef.sSelectedFilter='Deliverable';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Campaign
        controllerRef.sSelectedFilter='Campaign';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        //Running for Filter of Event
        controllerRef.sSelectedFilter='Event';
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        
        
        //Running for Filter of Meeting related to particular Event
        controllerRef.sSelectedFilter='Meeting';
        
      
        controllerRef.sVenueState= 'Alaska';
        controllerRef.sEventId = eventTest1.id;
         controllerRef.sSelectedFilter = 'Location';
           System.assertEquals( 'Location', controllerRef.sSelectedFilter);
           
        controllerRef.sEventId=[select whatId from Event LIMIT 1].whatId;
        
        controllerRef.pageLoad(); 
        controllerRef.applyFilter();
        controllerRef.showHideFilter();
        controllerRef.reset();
        
          PageReference pageRef1=Page.CalendarView;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('type','Event Location');
        controllerRef=new CalendarViewController();
        controllerRef.pageLoad(); 
        
                
        controllerRef.sEventId = eventTest1.id;
         controllerRef.sSelectedFilter = 'Event and';
        //controllerRef.sEventId=[select whatId from Event LIMIT 1].whatId;
         PageReference pageRef3=Page.CalendarView;
        Test.setCurrentPage(pageRef3);
        ApexPages.currentPage().getParameters().put('type','Event');
        controllerRef=new CalendarViewController();
        controllerRef.oEventFilter.StartDate=System.today();
        controllerRef.oEventFilter.EndDate=System.today();
         System.assertEquals(System.today(), controllerRef.oEventFilter.EndDate);
         
        controllerRef.oEventFilter.Type='Acquisition';
        
          System.assertEquals('Acquisition', controllerRef.oEventFilter.Type);
        
         controllerRef.oEventFilter.EVE_Channel__c='Advocates';
         
          System.assertEquals('Advocates', controllerRef.oEventFilter.EVE_Channel__c);
         
         controllerRef.oEventFilter.Id=controllerRef.sEventId;
        controllerRef.pageLoad(); 
         Test.stopTest();
    }

}