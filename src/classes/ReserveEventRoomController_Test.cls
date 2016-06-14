/*****************************************************************************************
    Name             : ReserveEventRoomController_Test
    Description      : This class is used as visual force controller for page ReserveEventRoom page  which is used to book room
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class ReserveEventRoomController_Test{
    


       public testMethod static void testReserveEventRoomController()
   {    //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
           test.startTest();
           
       
      Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharashtra', ZIP_Code__c='400059', Country__c='India', Room_No__c='A101');
      insert ven;
      system.assertEquals('Venue test',ven.Name);
      
      Venue__C venRoom1 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven.Id,Name='Venue test Room1', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom1;
      Venue__C venRoom2 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven.Id,Name='Venue test Room2', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom2;
      Venue__C venRoom3 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven.Id,Name='Venue test Room3', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom3;
      system.assertEquals('Venue test Room1',venRoom1.Name);
      
      Campaign EventTest=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven.Id,
            endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true  ,Published_Location_Name__c = 'test Location',
             Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
      insert EventTest;
      
      system.assertEquals('Test Event Location2',EventTest.Name);
          
     Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventTest.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
     Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventTest.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');     
            
     insert VSTest1;
     system.assertEquals(5,VSTest1.Initial_Number_Of_Slots_Requested__c);
   
   
    PageReference pageRef=Page.ReserveRoom;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest.Id);
     ApexPages.currentPage().getParameters().put('vName','');
    ApexPages.currentPage().getParameters().put('eName',EventTest.Name);
    
   ReserveEventRoomController controller=new ReserveEventRoomController();
    controller.sVenueId = '';
   PageReference pgRef=controller.close();
   
    ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest.Id);
    ApexPages.currentPage().getParameters().put('eName',EventTest.Name);
    ApexPages.currentPage().getParameters().put('vId',ven.Id);
    ApexPages.currentPage().getParameters().put('vName',ven.Name);
    ApexPages.currentPage().getParameters().put('eName',EventTest.Name);
    controller=new ReserveEventRoomController();
   controller.dtStart=Date.today();
   controller.dtEnd=Date.today().addDays(30);
   controller.setvalueTypeMap();
   controller.setFieldList();
   controller.filterListHandler.compControllerRef=new FilterListCompController ();
   controller.search();
   controller.taggAll();
   controller.untaggAll();
   controller.taggAll();
   controller.sRecordId=venRoom1.Id+','+venRoom2.Id+','+venRoom3.Id;
   
   Event_Room__c eventRoomVar=new Event_Room__c();
   eventRoomVar.Name=venRoom2.Name;
    eventRoomVar.Campaign__c=EventTest.Id;
     eventRoomVar.Venue__c=ven.Id;
      eventRoomVar.Capacity__c=venRoom2.Capacity__c;
      eventRoomVar.Room_No__c='A101';
      insert eventRoomVar;   
      system.assertEquals(venRoom2.Name,eventRoomVar.Name);
      
        controller.FinalCheck();       
      controller.save(); 
     controller.search();
   
   test.stopTest();
   
   }

    public testMethod static void ReserveEventRoomControllerTest()
    {        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    test.startTest();
        
      
        
      Venue__C ven1 = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharashtra', ZIP_Code__c='400059', Country__c='India', Room_No__c='A201');
      insert ven1;
      system.assertEquals('Venue test',ven1.Name);
      
       Venue__C venRoom1 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room1', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom1;
      Venue__C venRoom2 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room2', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom2;
      Venue__C venRoom3 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room3', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom3;
      system.assertEquals('Venue test Room1',venRoom1.Name);
     
      Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven1.Id,
            endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true  ,Published_Location_Name__c = 'test Location', 
            Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
      insert EventTest1;
      system.assertEquals('Test Event Location2',EventTest1.Name);
    
     Volunteer_Shift__c VSTest3=new Volunteer_Shift__c(EventLocation__c=EventTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
     Volunteer_Shift__c VSTest4=new Volunteer_Shift__c(EventLocation__c=EventTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
            
            
     insert VSTest3;
     system.assertEquals(5,VSTest3.Initial_Number_Of_Slots_Requested__c);
   
   
    PageReference pageRef=Page.ReserveRoom;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest1.Id);
     ApexPages.currentPage().getParameters().put('vName','');
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
   ReserveEventRoomController controller=new ReserveEventRoomController();
   controller.sVenueId = ApexPages.currentPage().getParameters().put('vId',ven1.id);
   PageReference pgRef=controller.close();
   
    ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest1.Id);
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
    ApexPages.currentPage().getParameters().put('vId',ven1.Id);
    ApexPages.currentPage().getParameters().put('vName',ven1.Name);
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
    controller=new ReserveEventRoomController();
   controller.dtStart=Date.today().addDays(-5);
   controller.dtEnd=Date.today().addDays(40);
   controller.setvalueTypeMap();
   controller.setFieldList();
   controller.filterListHandler.compControllerRef=new FilterListCompController ();
   controller.search();
   controller.taggAll();
   controller.untaggAll();
   controller.taggAll();
   controller.sRecordId=venRoom1.Id+','+venRoom2.Id+','+venRoom3.Id;
   
   Event_Room__c eventRoomVar=new Event_Room__c();
   eventRoomVar.Name=venRoom2.Name;
    eventRoomVar.Campaign__c=EventTest1.Id;
     eventRoomVar.Venue__c=ven1.Id;
      eventRoomVar.Capacity__c=venRoom2.Capacity__c;
      eventRoomVar.Room_No__c='A101';
      insert eventRoomVar; 
      system.assertEquals('A101',eventRoomVar.Room_No__c);
      controller.FinalCheck();            
      controller.save(); 
     controller.search();
   
   test.stopTest();
   
   }

    public testMethod static void ReserveEventRoomControllerTest1()
    {    //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        test.startTest();
         
       
      Venue__C ven1 = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharashtra', ZIP_Code__c='400059', Country__c='India', Room_No__c='A201');
      insert ven1;
      system.assertEquals('Venue test',ven1.Name);
      
       Venue__C venRoom1 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room1', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom1;
      Venue__C venRoom2 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room2', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom2;
      Venue__C venRoom3 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room3', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom3;
      system.assertEquals('Venue test Room1',venRoom1.Name);
     
      Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven1.Id,
            endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true  ,Published_Location_Name__c = 'test Location', 
            Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
      insert EventTest1;
      system.assertEquals('Test Event Location2',EventTest1.Name);
    
     Volunteer_Shift__c VSTest3=new Volunteer_Shift__c(EventLocation__c=EventTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
     Volunteer_Shift__c VSTest4=new Volunteer_Shift__c(EventLocation__c=EventTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
            
            
     insert VSTest3;
     system.assertEquals(5,VSTest3.Initial_Number_Of_Slots_Requested__c);
   
   
    PageReference pageRef=Page.ReserveRoom;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest1.Id);
     ApexPages.currentPage().getParameters().put('vName','');
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
   ReserveEventRoomController controller=new ReserveEventRoomController();
   controller.sVenueId = ApexPages.currentPage().getParameters().put('vId',ven1.id);
   PageReference pgRef=controller.close();
   
    ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest1.Id);
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
    ApexPages.currentPage().getParameters().put('vId',ven1.Id);
    ApexPages.currentPage().getParameters().put('vName',ven1.Name);
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
    controller=new ReserveEventRoomController();
   controller.dtStart=Date.today().addDays(10);
   controller.dtEnd=Date.today().addDays(11);
   controller.setvalueTypeMap();
   controller.setFieldList();
   controller.filterListHandler.compControllerRef=new FilterListCompController ();
   controller.search();
   controller.taggAll();
   controller.untaggAll();
   controller.taggAll();
   controller.sRecordId=venRoom1.Id+','+venRoom2.Id+','+venRoom3.Id;
   
   Event_Room__c eventRoomVar=new Event_Room__c();
   eventRoomVar.Name=venRoom2.Name;
    eventRoomVar.Campaign__c=EventTest1.Id;
     eventRoomVar.Venue__c=ven1.Id;
      eventRoomVar.Capacity__c=venRoom2.Capacity__c;
      eventRoomVar.Room_No__c='A101';
      insert eventRoomVar;      
      system.assertEquals('A101',eventRoomVar.Room_No__c);
      controller.FinalCheck();       
      controller.save(); 
     controller.search();
   
   test.stopTest();
   
   }
   
    public testMethod static void ReserveEventRoomControllerTest2()
    {
    //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
    test.startTest();
        
       
       
      Venue__C ven1 = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharashtra', ZIP_Code__c='400059', Country__c='India', Room_No__c='A201');
      insert ven1;
      system.assertEquals('Venue test',ven1.Name);
      
       Venue__C venRoom1 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room1', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom1;
      Venue__C venRoom2 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room2', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom2;
      Venue__C venRoom3 = new Venue__c(RecordtypeId=Utility.getRecordType('Room','Venue__c'),Venue__c=ven1.Id,Name='Venue test Room3', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
      insert venRoom3;
      system.assertEquals('Venue test Room1',venRoom1.Name);
     
      Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven1.Id,
            endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true  ,Published_Location_Name__c = 'test Location', 
            Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
      insert EventTest1;
      system.assertEquals('Test Event Location2',EventTest1.Name);
    
     Volunteer_Shift__c VSTest3=new Volunteer_Shift__c(EventLocation__c=EventTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
     Volunteer_Shift__c VSTest4=new Volunteer_Shift__c(EventLocation__c=EventTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
            
            
     insert VSTest3;
     system.assertEquals(5,VSTest3.Initial_Number_Of_Slots_Requested__c);
   
   
    PageReference pageRef=Page.ReserveRoom;
    Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest1.Id);
     ApexPages.currentPage().getParameters().put('vName','');
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
   ReserveEventRoomController controller=new ReserveEventRoomController();
   controller.sVenueId = ApexPages.currentPage().getParameters().put('vId',ven1.id);
   PageReference pgRef=controller.close();
   
    ApexPages.currentPage().getParameters().put('sDate',Datetime.now().format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eDate',Datetime.now().addDays(30).format('YYYY-MM-DD'));
    ApexPages.currentPage().getParameters().put('eId',EventTest1.Id);
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
    ApexPages.currentPage().getParameters().put('vId',ven1.Id);
    ApexPages.currentPage().getParameters().put('vName',ven1.Name);
    ApexPages.currentPage().getParameters().put('eName',EventTest1.Name);
    controller=new ReserveEventRoomController();
   controller.dtEnd=Date.today().addDays(10);
   controller.dtStart=Date.today().addDays(-5);
   controller.setvalueTypeMap();
   controller.setFieldList();
   controller.filterListHandler.compControllerRef=new FilterListCompController ();
   controller.search();
   controller.taggAll();
   controller.untaggAll();
   controller.taggAll();
   controller.sRecordId=venRoom1.Id+','+venRoom2.Id+','+venRoom3.Id;
   
   Event_Room__c eventRoomVar=new Event_Room__c();
   eventRoomVar.Name=venRoom2.Name;
    eventRoomVar.Campaign__c=EventTest1.Id;
     eventRoomVar.Venue__c=ven1.Id;
      eventRoomVar.Capacity__c=venRoom2.Capacity__c;
      eventRoomVar.Room_No__c='A101';
      insert eventRoomVar;  
      system.assertEquals('A101',eventRoomVar.Room_No__c);
      
      string sTimeNow = string.valueof(system.now());
      Datetime dtStart=Utility.formatDate(sTimeNow).addHours(3);
      List<Event_Room__c> lstReservedRoom=[select Id,Name,Venue__c,Venue__r.Name,Campaign__r.StartDate,Campaign__r.EndDate from Event_Room__c where   Campaign__r.EndDate >:dtStart.date() and Venue__r.Venue__c=:controller.sVenueId ];
      controller.FinalCheck();        
      controller.save(); 
     controller.search();
   
   test.stopTest();
   
   }

    public testMethod static void ReserveEventRoomControllerTest3()
    {
        ApexPages.currentPage().getParameters().put('vId',' ');
        Test.StartTest() ; 
            ReserveEventRoomController controllerTest=new ReserveEventRoomController();
        Test.StopTest() ; 
    }
}