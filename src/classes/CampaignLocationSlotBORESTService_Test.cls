/*****************************************************************************************
    Name             : CampaignLocationSlotBORESTService_Test
    Description      : This REST webservice is used to Call to query all Slot for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/

    @isTest(seeAllData=true)
    public class CampaignLocationSlotBORESTService_Test
    {

        public testMethod static void testCampaignLocSlot()
    {            
           // Test.startTest();
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            
            Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
            insert ven;
            System.assertEquals('Venue test',ven.Name);
            Campaign EventTest=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven.Id,
            endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true,Published_Location_Name__c = 'test Location', 
            Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
            insert EventTest;
            System.assertEquals('Test Event Location2',EventTest.Name);
            
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventTest.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,End_Time__c = '05:50 AM',Start_Time__c = '05:50 AM',Volunteer_Role__c='Developer');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventTest.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
            insert VSTest1;
            System.assertEquals('Developer',VSTest1.Volunteer_Role__c);
            
            Test.startTest();
            
            Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            System.assertEquals('test@test.com',volunteerTest.Business_Email__c);
            
            lead NewLead = new Lead(Status = 'New', LastName = 'My Name',Company = 'My Company' );
            insert NewLead;
            
            Contact volunteerContactTest = new Contact(LastName='Test', Lead__c = NewLead.id);
            insert volunteerContactTest;
            
            List<Volunteer_Slot__c> listVSlotTest= [select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots
            listVSlotTest[0].Volunteer__c=volunteerTest.Id;
            listVSlotTest[0].Status__c='Approved';
            update listVSlotTest[0];
            System.assertEquals('Approved',listVSlotTest[0].Status__c);
            //listVSlotTest[1].Volunteer__c=volunteerContactTest.id;
            //listVSlotTest[1].Status__c='Pending Approval';
            //update listVSlotTest[1];
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?eventlocationid='+EventTest.Id;
            req.addParameter('eventlocationid',EventTest.Id ); 
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.getCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id;
            req.addParameter('volunteerid', volunteerTest.Id);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.getCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id+'status=Approved&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments&dateendafter=2014-01-15T18:25:43.511Z';
            req.addParameter('volunteerid', String.valueOf(volunteerContactTest.Id));
            req.addParameter('dateendafter', String.valueOf(system.today())); 
            req.addParameter('volunteerslotid', listVSlotTest[0].Id);  
            req.addParameter('status', 'Approved');  
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?status=Approved&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments';
            //req.addParameter('volunteerid', volunteerTest.Id); 
            //req.addParameter('volunteerslotid', listVSlotTest[0].Id);  
            req.addParameter('status', 'Approved');  
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id+'&status=Cancelled&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments';
            req.addParameter('volunteerid', String.valueOf(volunteerTest.Id)); 
            req.addParameter('volunteerslotid', string.valueOf(listVSlotTest[0].Id));  
            req.addParameter('status', 'Cancelled');  
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
                        
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id+'&status=Available&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments';
            req.addParameter('volunteerid', volunteerTest.Id); 
            req.addParameter('volunteerslotid', listVSlotTest[0].Id);  
            //req.addParameter('status', 'Available'); 
            req.addParameter('status','Pending Approval'); 
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
            req.addParameter('status', 'Available'); 
            req.addParameter('volunteerid', 'false'); 
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
                        
            delete listVSlotTest[0];
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id;
            req.addParameter('dateafterend',String.valueOf(System.now().addDays(-99)));
            req.addParameter('volunteerid', volunteerTest.Id);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.getCampaignLocationSlot();
            Test.stopTest();
            // System.assertEquals(RestContext.response.responseBody.toString(),'No Event Location Found');
     }   
        
     public testMethod static void testCampaignLocSlotException()
    {            
           // Test.startTest();
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            Json_Process__C oResponseJsondel = [Select ID from Json_Process__c where Name = 'CampaignLocationVolunteerBOResponse' ] ;
                Delete oResponseJsondel ; 
                
            Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
            insert ven;
            System.assertEquals('Venue test',ven.Name);
            Campaign EventTest=new Campaign(RecordtypeId=Utility.getRecordType('Event Location','Campaign'), Name = 'Test Event Location2', status ='Confirmed', Venue__c=ven.Id,
            endDate = date.today().addDays(30),StartDate = date.today(),Publish_To_Web__c=true,Published_Location_Name__c = 'test Location', 
            Published_Volunteer_Coordinator_Email__c = 'abcd@gmail.com', Published_Volunteer_Coordinator_Name__c = 'Test Volunteer Coordinator');
            insert EventTest;
            System.assertEquals('Test Event Location2',EventTest.Name);
            
            Volunteer_Shift__c VSTest1=new Volunteer_Shift__c(EventLocation__c=EventTest.Id,Date__c=System.today().addDays(7),Initial_Number_Of_Slots_Requested__c=5,End_Time__c = '05:50 AM',Start_Time__c = '05:50 AM',Volunteer_Role__c='Developer');
            Volunteer_Shift__c VSTest2=new Volunteer_Shift__c(EventLocation__c=EventTest.Id,Date__c=System.today().addDays(8),Initial_Number_Of_Slots_Requested__c=6,   Volunteer_Role__c='Coach');
            insert VSTest1;
            System.assertEquals('Developer',VSTest1.Volunteer_Role__c);
            
            Test.startTest();
            
            Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            System.assertEquals('test@test.com',volunteerTest.Business_Email__c);
            
            lead NewLead = new Lead(Status = 'New', LastName = 'My Name',Company = 'My Company' );
            insert NewLead;
            
            Contact volunteerContactTest = new Contact(LastName='Test', Lead__c = NewLead.id);
            insert volunteerContactTest;
            
            List<Volunteer_Slot__c> listVSlotTest= [select Id,Volunteer__c,Status__c from Volunteer_Slot__c where Volunteer_Shift__c=:VSTest1.Id]; //Getting newly created Volunteer Slots
            listVSlotTest[0].Volunteer__c=volunteerTest.Id;
            listVSlotTest[0].Status__c='Approved';
            update listVSlotTest[0];
            System.assertEquals('Approved',listVSlotTest[0].Status__c);
            //listVSlotTest[1].Volunteer__c=volunteerContactTest.id;
            //listVSlotTest[1].Status__c='Pending Approval';
            //update listVSlotTest[1];
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?eventlocationid='+EventTest.Id;
            req.addParameter('eventlocationid',EventTest.Id ); 
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.getCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id;
            req.addParameter('volunteerid', volunteerTest.Id);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.getCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id+'status=Approved&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments&dateendafter=2014-01-15T18:25:43.511Z';
            req.addParameter('volunteerid', String.valueOf(volunteerContactTest.Id));
            req.addParameter('dateendafter', String.valueOf(system.today())); 
            req.addParameter('volunteerslotid', listVSlotTest[0].Id);  
            req.addParameter('status', 'Approved');  
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?status=Approved&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments';
            //req.addParameter('volunteerid', volunteerTest.Id); 
            //req.addParameter('volunteerslotid', listVSlotTest[0].Id);  
            req.addParameter('status', 'Approved');  
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id+'&status=Cancelled&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments';
            req.addParameter('volunteerid', String.valueOf(volunteerTest.Id)); 
            req.addParameter('volunteerslotid', string.valueOf(listVSlotTest[0].Id));  
            req.addParameter('status', 'Cancelled');  
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
                        
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id+'&status=Available&volunteerslotid='+listVSlotTest[0].Id+'&guest=test Comments';
            req.addParameter('volunteerid', volunteerTest.Id); 
            req.addParameter('volunteerslotid', listVSlotTest[0].Id);  
            //req.addParameter('status', 'Available'); 
            req.addParameter('status','Pending Approval'); 
            req.addParameter('guest', 'test');  
            req.httpMethod = 'PUT';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
            req.addParameter('status', 'Available'); 
            req.addParameter('volunteerid', 'false'); 
            CampaignLocationSlotBORESTService.setCampaignLocationSlot();
                        
            delete listVSlotTest[0];
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/events/locations/volunteerslot?volunteerid='+volunteerTest.Id;
            req.addParameter('dateafterend',String.valueOf(System.now().addDays(-99)));
            req.addParameter('volunteerid', volunteerTest.Id);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            CampaignLocationSlotBORESTService.getCampaignLocationSlot();
            Test.stopTest();
            // System.assertEquals(RestContext.response.responseBody.toString(),'No Event Location Found');
     }  
   }