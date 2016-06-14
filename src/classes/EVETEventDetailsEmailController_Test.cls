/*****************************************************************************************
    Name             : EVETEventDetailsEmailController
    Description      : Class used to handle Email Sending to various Advocates and Volunteers.                    
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Shanu                27/03/2015            Created
                                                                Modified for code re-factoring & optimization
    ******************************************************************************************/
    @isTest(seeAllData=true)
    
    global class EVETEventDetailsEmailController_Test implements HttpCalloutMock{
   
   Static String sSelectedEventLocaion;
   
   global HttpResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       
       if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Access Token').Endpoint_URL__c){
           System.assertEquals(Integration_Endpoints__c.getAll().get('Access Token').Endpoint_URL__c, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token": "testOauthToken","expires_in": 3600,"token_type": "Bearer"}');
        res.setStatusCode(200);
        return res;      
       }
       else if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe').Endpoint_URL__c){
           System.assertEquals(Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe').Endpoint_URL__c, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Success"}');
        res.setStatusCode(200);
        return res;       
       }
       else{        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"zip_codes": [{"zip_code": "93109","distance": 3.744,"city": "Santa Barbara","state": "CA"}]}');
        res.setStatusCode(200);
        return res;
        
       }
       return null;
    }
    
   
    
     public testMethod static void testEVETEventDetails()
     {
    // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();   
     //--------------------------------------------------------
       Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(5),Name= 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
        insert EventTest1;
        System.assertEquals('Test Event1',EventTest1.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        System.assertEquals('Venue test',ven.Name);
        
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), StartDate=Date.today().addDays(1),EndDate=Date.today().addDays(4),Name = 'Test Event Loc1', status ='Confirmed', 
        Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23,Cancellation_Reason__c = 'test Cancel',Volunteer_Coordinator__c=UserInfo.getUserId() );
        
        insert EventLocationTest1;
        System.assertEquals(23,EventLocationTest1.Estimated_Audience_Size__c );
        
        sSelectedEventLocaion=EventLocationTest1.Id;
        Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
        Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
                
         insert VSTest1;
         System.assertEquals('Coach',VSTest2.Volunteer_Role__c);        
          
         List<Account> listAccount=new List<Account>();
         Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test1',Business_Email__c='test1@test.com',Preferred_Email__c='Business',ADV_Preferred_Zip_Code__c='93109', Do_Not_Email__c = false, Do_Not_Contact__c = false);
         Account volunteerTest2=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test2',Work_Email__c='test2@test.com',Preferred_Email__c='Work',ADV_Preferred_Zip_Code__c='93109', Do_Not_Email__c = false, Do_Not_Contact__c = false);
         Account volunteerTest3=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test3',Personal_Email__c='tes3t@test.com',Preferred_Email__c='Personal',ADV_Preferred_Zip_Code__c='93109', Do_Not_Email__c = false, Do_Not_Contact__c = false);
         listAccount.add(volunteerTest1);
         listAccount.add(volunteerTest2);
         listAccount.add(volunteerTest3);
        
         insert listAccount;
         system.assertEquals('Test1',volunteerTest1.Name);
                
          List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c,Volunteer__r.Do_Not_Contact__c,Volunteer__r.Do_Not_Email__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots

            listVSlotTest[0].Volunteer__c=listAccount[0].Id;
            listVSlotTest[0].Status__c='Approved';
            listVSlotTest[1].Volunteer__c=listAccount[1].Id;
            listVSlotTest[1].Status__c='Approved';
            listVSlotTest[2].Volunteer__c=listAccount[2].Id;
            listVSlotTest[2].Status__c='Approved'; 
       
            update listVSlotTest;
            system.assertEquals('Approved',listVSlotTest[0].Status__c);  
     
     //-------------------------------------------------------
        PageReference pageRef=Page.EVETAdvocateAppealEmail;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EVETEventDetailsEmailController_Test()); 
        
        EVETEventDetailsEmailController controller=new EVETEventDetailsEmailController() ;
        controller.mapEventVSlot = new  Map<Id,List<Volunteer_Slot__c>>();
        
        controller.mapEventVSlot.put(EventLocationTest1.id, listVSlotTest);
        
        EVETEventDetailsEmailController.VolunteerWrapper volWrap=new EVETEventDetailsEmailController.VolunteerWrapper(listVSlotTest[0],true);     
        
        EVETEventDetailsEmailController.CampaignWrapper campWrap=new EVETEventDetailsEmailController.CampaignWrapper(EventTest1,true);  
        
        controller.sEventIdSelected='sEventIdSelected';
        controller.iNoOfVolunteer=10;
         system.assertEquals(10, controller.iNoOfVolunteer);  
         
        controller.sSpecialNote='sSpecialNote';
        
        controller.sEventId=EventLocationTest1.id;
         system.assertEquals(EventLocationTest1.id,controller.sEventId);  
        
        controller.showVolunteers();
        
        String sEmailVar='test1@test.com';
        String sEmail='';
        For(Integer iIndex=0;iIndex<=50;iIndex++)
        sEmail+=sEmailVar+'\n';    
        sEmail='test1@test.com';
         controller.getEmailBatch();
        controller.sendEmail();
        controller.hideSearchResult();       
        
        Test.stoptest(); 
     }
     
         public testMethod static void testEVETEventDetails1()
     {  //  List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation(); 
     //----------------------------------
       //  ---------------
        User user1 = new User();
        user1.Username= 'testusertest11@test.com';
        user1.Email= 'test11@test.com';
        user1.Lastname= 'user';
        user1.Firstname= 'test11';
        user1.Alias= 'test';
        user1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user1.TimeZoneSidKey= 'GMT';
         
        user1.LocaleSidKey= 'en_US';
        user1.EmailEncodingKey= 'ISO-8859-1';
        user1.LanguageLocaleKey= 'en_US';
        user1.Authorized_Campaign_Owner__c=true;
        user1.UserPermissionsMobileUser = true;
        insert user1;
        //----------------  
     
      //--------------------------------------------------------
       Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(10),Name= 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
        insert EventTest1;
        System.assertEquals('Test Event1',EventTest1.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        System.assertEquals('Venue test',ven.Name);
        
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), StartDate=Date.today().addDays(4),EndDate=Date.today().addDays(9),Name = 'Test Event Loc1', status ='Confirmed', 
        Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23,Cancellation_Reason__c = 'test Cancel',
        Volunteer_Coordinator__c=user1.id,Publish_To_Web__c = true,Published_Location_Name__c='test', Published_Volunteer_Coordinator_Name__c =UserInfo.getName(),Published_Volunteer_Coordinator_Email__c='test@test.com' );
        insert EventLocationTest1;
        System.assertEquals(23,EventLocationTest1.Estimated_Audience_Size__c );
        
        sSelectedEventLocaion=EventLocationTest1.Id;
        Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,   Volunteer_Role__c='Developer');
        Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventLocationTest1.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
                
         insert VSTest1;
         System.assertEquals('Coach',VSTest2.Volunteer_Role__c);        
          
         List<Account> listAccount=new List<Account>();
         Account volunteerTest1=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test1',Business_Email__c='test1@test.com',Preferred_Email__c='Business',ADV_Preferred_Zip_Code__c='93109');
         Account volunteerTest2=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test2',Work_Email__c='test2@test.com',Preferred_Email__c='Work',ADV_Preferred_Zip_Code__c='93109');
         Account volunteerTest3=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test3',Personal_Email__c='tes3t@test.com',Preferred_Email__c='Personal',ADV_Preferred_Zip_Code__c='93109');
         listAccount.add(volunteerTest1);
         listAccount.add(volunteerTest2);
         listAccount.add(volunteerTest3);
        
         insert listAccount;
         system.assertEquals('Test1',volunteerTest1.Name);
                
         list<Volunteer_Slot__c> listVSlotTest = new  list<Volunteer_Slot__c>();
         
         Volunteer_Slot__c volunteerSlot1 = new Volunteer_Slot__c(Volunteer__c = listAccount[0].Id, Volunteer_Shift__c = VSTest1.Id, Status__c='Approved', Volunteer_Email_Update__c = 'test1@test.com');
         Volunteer_Slot__c volunteerSlot2 = new Volunteer_Slot__c(Volunteer__c = listAccount[1].Id, Volunteer_Shift__c = VSTest1.Id, Status__c='Approved', Volunteer_Email_Update__c = 'test2@test.com');
         Volunteer_Slot__c volunteerSlot3 = new Volunteer_Slot__c(Volunteer__c = listAccount[2].Id, Volunteer_Shift__c = VSTest1.Id, Status__c='Approved', Volunteer_Email_Update__c = 'test3@test.com');
         
         listVSlotTest.add(volunteerSlot1);
         listVSlotTest.add(volunteerSlot2);
         listVSlotTest.add(volunteerSlot3);
         
         insert listVSlotTest;
        
         //List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c, Volunteer__r.Do_Not_Contact__c,Volunteer__r.Do_Not_Email__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots

/*
            listVSlotTest[0].Volunteer__c=listAccount[0].Id;
            listVSlotTest[0].Status__c='Approved';
            listVSlotTest[0].Volunteer_Email_Update__c = null;
            listVSlotTest[1].Volunteer__c=listAccount[1].Id;
            listVSlotTest[1].Status__c='Approved';
            listVSlotTest[1].Volunteer_Email_Update__c = null;
            listVSlotTest[2].Volunteer__c=listAccount[2].Id;
            listVSlotTest[2].Status__c='Approved'; 
            listVSlotTest[2].Volunteer_Email_Update__c=null;
       
            update listVSlotTest;
            system.assertEquals('Approved',listVSlotTest[0].Status__c);   
          */
            
     //-------------------------------------------------------
     
        PageReference pageRef=Page.EVETAdvocateAppealEmail;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EVETEventDetailsEmailController_Test()); 
        
        EVETEventDetailsEmailController controller=new EVETEventDetailsEmailController() ;
        
        controller.mapEventVSlot = new  Map<Id,List<Volunteer_Slot__c>>();
        controller.mapEventVSlot.put(EventLocationTest1.id, listVSlotTest);
        
        EVETEventDetailsEmailController.VolunteerWrapper volWrap=new EVETEventDetailsEmailController.VolunteerWrapper(listVSlotTest[0],true);     
        
        EVETEventDetailsEmailController.CampaignWrapper campWrap=new EVETEventDetailsEmailController.CampaignWrapper(EventTest1,true);  
        controller.lstAllActiveCampaign.add(EventLocationTest1);
        controller.sEventIdSelected='sEventIdSelected';
        controller.iNoOfVolunteer=10;
         system.assertEquals(10, controller.iNoOfVolunteer);  
         
        controller.sSpecialNote='sSpecialNote';
        
        controller.sEventId=EventLocationTest1.id;
        system.assertEquals(EventLocationTest1.id,controller.sEventId);  
        
        controller.showVolunteers();
        
        controller.hideSearchResult();  
        
        String sEmailVar='test1@test.com';
        String sEmail='';
        For(Integer iIndex=0;iIndex<=50;iIndex++)
        sEmail+=sEmailVar+'\n';    
        sEmail='test1@test.com';
        controller.lstVolunteerWrapper = new List<EVETEventDetailsEmailController.VolunteerWrapper>();
        controller.getEmailBatch();
        controller.sEventIdSelected = VSTest1.EventLocation__c;
        controller.sendEmail();
     
        listVSlotTest[0].Status__c=null;    
        listVSlotTest[1].Status__c=null;
        listVSlotTest[2].Status__c=null;
        
        update  listVSlotTest;
        controller.showVolunteers();
        //controller.iTotalSize = 12345678;
        //controller.getEmailBatch();
        
        Test.stoptest(); 
     }
}