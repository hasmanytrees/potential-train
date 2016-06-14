/*****************************************************************************************
    Name             : EVETAdvocateAppealEmailController
    Description      : Class used to handle Advocate appeal via email .                   
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Subhojit                30/10/2014            Created
    Subhojit                29/01/2015            Modified for code re-factoring & optimization
    ******************************************************************************************/
    @isTest(seeAllData=true)
    
    global class EVETAdvocateAppealEmailController_Test implements HttpCalloutMock{
   
   Static String sSelectedEventLocaion;
   Static Integer iCheck=0;
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
        if(iCheck==0)
        res.setStatusCode(200);
        else
        res.setStatusCode(500);
        return res;      
       }
       else if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe').Endpoint_URL__c){
           System.assertEquals(Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe').Endpoint_URL__c, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Success"}');
        res.setStatusCode(400);
        return res;
       }
       else{        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"zip_codes": [{"zip_code": "93109","distance": 3.744,"city": "Santa Barbara","state": "CA"},{"zip_code": "93110","distance": 3.744,"city": "Santa Barbara","state": "CA"}]}');
        res.setStatusCode(200);
        return res;
        
       }
       return null;
    }
    
   
          public testMethod static void testEVETAdvocateAppeal()
      {
         // List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();    
     //----------------------------------
     
     Test.startTest();
       Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(5),Name= 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
        insert EventTest1;
        System.assertEquals('Test Event1',EventTest1.Name);
        
        Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='93109', Country__c='India');
        insert Ven; // Initializing Venue Record
        System.assertEquals('Venue test',ven.Name);
        
        Campaign EventLocationTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), StartDate=Date.today().addDays(1),EndDate=Date.today().addDays(4),Name = 'Test Event Loc1', status ='Confirmed', 
        Event__c = EventTest1.id, Venue__c = ven.id,Number_Of_Booths_Tables__c=23, Packet_Pass_Needed__c = true, Estimated_Audience_Size__c = 23,Cancellation_Reason__c = 'test Cancel',Volunteer_Coordinator__c=UserInfo.getUserId(),
        Published_Volunteer_Coordinator_Name__c = UserInfo.getName() );
        
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
         
         // Nov-2015 Shanu- Code changes made for COR0001494  
         List<Partner_Type__c> listPartnerType=new List<Partner_Type__c>();
         Partner_Type__c partnerTypeAdvocateTest1=new Partner_Type__c (recordtypeId=Utility.getRecordTypeMap('Partner_Type__c').get('Advocate'),Type__c='Advocate',Advocate_Status__c='Active',OwnerId=UserInfo.getUserId(),Account__c=volunteerTest2.Id);
         Partner_Type__c partnerTypeAdvocateTest2=new Partner_Type__c (recordtypeId=Utility.getRecordTypeMap('Partner_Type__c').get('Church'),Type__c='Church',OwnerId=UserInfo.getUserId(),Account__c=volunteerTest1.Id);
         Partner_Type__c partnerTypeAdvocateTest3=new Partner_Type__c (recordtypeId=Utility.getRecordTypeMap('Partner_Type__c').get('Advocate'),Type__c='Advocate',Advocate_Status__c='Inactive',OwnerId=UserInfo.getUserId(),Account__c=volunteerTest3.Id);
         
         listPartnerType.add(partnerTypeAdvocateTest1);
         listPartnerType.add(partnerTypeAdvocateTest2);
         listPartnerType.add(partnerTypeAdvocateTest3);
         
         insert listPartnerType;
         List<Account> listActiveAccount=new List<Account>();
                         
          List<Volunteer_Slot__c> listVSlotTest=[select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots

            listVSlotTest[0].Volunteer__c=listAccount[0].Id;
            listVSlotTest[0].Status__c='Approved';
            listVSlotTest[1].Volunteer__c=listAccount[1].Id;
            listVSlotTest[1].Status__c='Approved';
            listVSlotTest[2].Volunteer__c=listAccount[2].Id;
            listVSlotTest[2].Status__c='Approved'; 
       
            update listVSlotTest;
            system.assertEquals('Approved',listVSlotTest[0].Status__c);
     
     //--------------------------------- 
     system.debug('<<<<<<<<<<<<<>>>>>>>>>>>>'+[select Id from Account where ADV_Preferred_Zip_Code__c='93109']);
     PageReference pageRef=Page.EVETAdvocateAppealEmail;
     Test.setCurrentPage(pageRef);
     
     Test.setMock(HttpCalloutMock.class, new EVETAdvocateAppealEmailController_Test()); 
    
     EVETAdvocateAppealEmailController controller=new EVETAdvocateAppealEmailController() ;
     EVETAdvocateAppealEmailController.CampaignWrapper CampWrap=new EVETAdvocateAppealEmailController.CampaignWrapper(EventLocationTest1,false);
     CampWrap.dtStartDate = date.today();
     CampWrap.dtEndDate = date.today();
     CampWrap.sVenue = Ven.id;
     CampWrap.bIsSelected = true;
      EVETAdvocateAppealEmailController.AccountWrapper AccWrap=new EVETAdvocateAppealEmailController.AccountWrapper(volunteerTest1,true);
   
       controller.lstAllActiveCampaign.add(EventLocationTest1);
       
       controller.init();       
   
    controller.sZIPCode='';
 
    controller.sZIPCode='93109';
    controller.sSelectedDistance='5';
    
    system.assertEquals('5',controller.sSelectedDistance);

    controller.sZIPCode='721101--';
 
    controller.sEventIdSelected='sEventIdSelected';
    controller.iNoOfAdvocate=1;
    controller.sSpecialNote='sSpecialNote';
    controller.sSelectedEvent='sSelectedEvent';
    controller.sSelectedEventVar = null;
  
    String sEmailVar='test1@test.com';
    String sEmail='';
    For(Integer iIndex=0;iIndex<=50;iIndex++)
     sEmail+=sEmailVar+'\n';
     controller.sEmailIds=sEmail;
     controller.getAccountByEmails(); 
     listActiveAccount=controller.FilterActivePartnerSupporterAccounts(listAccount); 
     
     sEmail='test1@test.com';
     controller.sEmailIds='';
        Id [] fixedSearchResults= new Id[3];
       fixedSearchResults[0] = listAccount[0].id;
        fixedSearchResults[1] = listAccount[1].id;
          fixedSearchResults[2] = listAccount[2].id;
       Test.setFixedSearchResults(fixedSearchResults);
     controller.getAccountByEmails();  
     controller.sEmailIds=sEmail;
     
       system.assertEquals('5',controller.sSelectedDistance);
     controller.lstAccountWrapper=new List<EVETAdvocateAppealEmailController.AccountWrapper>();
       controller.lstAccountWrapper.add(new EVETAdvocateAppealEmailController.AccountWrapper(listAccount[0],true));
        controller.lstAccountWrapper.add(new EVETAdvocateAppealEmailController.AccountWrapper(listAccount[1],true));
        controller.lstAccountWrapper.add(new EVETAdvocateAppealEmailController.AccountWrapper(listAccount[2],true));
        controller.lstCampaignWrapper=new List<EVETAdvocateAppealEmailController.CampaignWrapper>();
       controller.lstCampaignWrapper.add(new EVETAdvocateAppealEmailController.CampaignWrapper(EventLocationTest1,true));
        controller.lstCampaignWrapper = new List<EVETAdvocateAppealEmailController.CampaignWrapper>();
      controller.lstCampaignWrapper.add(CampWrap);
     controller.hideSearchResult();
     controller.getAccountByEmails();
       controller.iNoOfSelectedAdvocate = 0;  
     controller.gotoSecondPage();
       controller.campaignOwner.Volunteer_Coordinator__c=Userinfo.getUserId();
     
      controller.getEmailBatch();
     controller.sendEmail();
     controller.back();
  
     Test.stoptest(); 
     
     }
     
          public testMethod static void testEVETAdvocateAppeal1()
      {    //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       
     PageReference pageRef=Page.EVETAdvocateAppealEmail;
     Test.setCurrentPage(pageRef);
     Test.startTest();
     Test.setMock(HttpCalloutMock.class, new EVETAdvocateAppealEmailController_Test()); 
    
     EVETAdvocateAppealEmailController controller=new EVETAdvocateAppealEmailController() ;
     
    controller.sZIPCode='';
    controller.getNearByPinCodeList();
    controller.sZIPCode='93109';
    controller.sSelectedDistance='5';
    controller.getNearByPinCodeList();
  
    controller.getNearByPinCodeList();
    controller.sZIPCode='721101--';
     system.assertEquals('721101--',controller.sZIPCode);
      iCheck++;
    controller.getNearByPinCodeList(); 
    controller.sEventIdSelected='sEventIdSelected';
    controller.iNoOfAdvocate=1;
    controller.sSpecialNote='sSpecialNote';
    controller.sSelectedEvent='sSelectedEvent';
    String sEmailVar='test1@test.com';
      system.assertEquals('test1@test.com',sEmailVar);
    
    String sEmail='';
    For(Integer iIndex=0;iIndex<=50;iIndex++)
     sEmail+=sEmailVar+'\n';
     controller.sEmailIds=sEmail;
       
     
     controller.getAccountByEmails();  
     
     sEmail='test1@test.com';
     controller.sEmailIds='';
     controller.getAccountByEmails();  
     controller.sEmailIds=sEmail;
     controller.hideSearchResult();
     controller.getAccountByEmails();  
     controller.gotoSecondPage();
 
     controller.sendEmail();
     controller.back();
    
     Campaign camp=new Campaign();
     boolean isSelected=true;
     EVETAdvocateAppealEmailController.CampaignWrapper campWrap=new EVETAdvocateAppealEmailController.CampaignWrapper(camp,isSelected);
      controller.sendEmail();
     Account acc=new Account();
     boolean iSelected=true;
     EVETAdvocateAppealEmailController.AccountWrapper accWrap=new EVETAdvocateAppealEmailController.AccountWrapper(acc,iSelected);
      controller.sendEmail();
     Test.stoptest(); 
     
     }
  
  
    }