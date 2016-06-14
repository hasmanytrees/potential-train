/*****************************************************************************************
    Name             : CampaignLocationVolunteerBOREST_Test
    Description      : This REST webservice is used to Call to query all Slot for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
    @isTest(seeAllData=true)
    public class CampaignLocationVolunteerBOREST_Test
    {
    
    
          public testMethod static void testCampaignLocSlot()
      {
          
          //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();  
      
         Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            System.assertEquals('Test',volunteerTest.Name);
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons?volunteerid='+volunteerTest.Id;
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.getVolunteerDetails();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Work' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        
         System.assertEquals('POST',req.httpMethod);
        
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Work' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'POST';
        
         System.assertEquals('POST',req.httpMethod);
        
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Personal' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
       
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Business' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        req.addParameter('volunteerlastlogin','2014-11-06T08:00:00Z' ); 
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
      
        delete volunteerTest;
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons?volunteerid='+volunteerTest.Id;
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.getVolunteerDetails();
         delete [select Id from JSON_Process__c where Name='CampaignLocationVolunteerBORESTServiceProcess'];
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Business' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'PUT';
        
         System.assertEquals('PUT',req.httpMethod);
        
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
      
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
         
        req.addParameter('volunteerid',null);
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();  
      }
    
      
    public testMethod static void testCampaignLocSlot2()
      {
          
          //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();  
      
      Field_Group__c grpDelete = [ Select ID from Field_Group__c where name = 'CampaignLocationVolunteerBORESTServiceField']  ; 
           delete grpDelete ; 
           
      Test.StartTest() ; 
         Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test@test.com');
            insert volunteerTest;   //Creating Volunteer
            System.assertEquals('Test',volunteerTest.Name);
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons?volunteerid='+volunteerTest.Id;
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.getVolunteerDetails();
        
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Work' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        
         System.assertEquals('POST',req.httpMethod);
        
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Work' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'POST';
        
         System.assertEquals('POST',req.httpMethod);
        
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
        
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Personal' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        //req.addParameter('volunteerlastlogin','2014-11-06 08:00:00' ); 
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
       
         req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons';
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.addParameter('volunteeremail','subhojitc3@gmail.com' );  
        req.addParameter('volunteeremailtype','Business' );  
        req.addParameter('volunteersearchpostalcode','721101' ); 
        req.addParameter('volunteersearchradius','5' ); 
        req.addParameter('volunteerlastlogin','2014-AA-06T08:00:00Z' ); 
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.setVolunteerDetails();
      
        delete volunteerTest;
        
        
           
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/persons?volunteerid='+volunteerTest.Id;
        req.addParameter('volunteerid',volunteerTest.Id );  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CampaignLocationVolunteerBORESTService.getVolunteerDetails();
         
         Test.StopTest() ; 
        
        }
    }