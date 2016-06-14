/*****************************************************************************************
    Name             : CreateAccountRESTServices_Test
    Description      : This REST webservice is used to Call to query all Slot for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
        public class CreateAccountRESTServices_Test
    {    
        
        static Final String sInputJSON='{"AccountList":[{"AccountName": "Anotnio", "PersonalEmail": "test@tes.com","GlobalId":"abcd3456789","LegacySupporterId": "XXXVVVBBRRTYYY##456"}]}';    
        static Final String sInputJSON2='{"AccountList":[{"AccountName": "Anotnio", "PersonalEmail": "test@tes.com","GlobalId":"abcd3456789","UndeliverableInvalid":"Work Email", "LegacySupporterId": "XXXVVVBBRRTYYY##456"}]}';    
        
        static Final String sInputJSON3='{"AccountList":[{"AccountName": "Anotnio", "PersonalEmail": "test@tes.com","GlobalId":"abcd3456789","UndeliverableInvalid":"Work Phone;Personal Email","LegacySupporterId": "XXXVVVBBRRTYYY##456"}]}';        
        static Final String sInputJSON4='{"AccountList":[{"AccountName": "Anotnio", "PersonalEmail": "test@tes.com","GlobalId":"abcd3456789","UndeliverableInvalid":,"Buinsess Phone","LegacySupporterId": "XXXVVVBBRRTYYY##456"}]}';        
        static Final String sInputJSON5='{"AccountList":[{"AccountName": "Anotnio", "PersonalEmail": "test@tes.com","GlobalId":"abcd3456789","UndeliverableInvalid":"Business Email", "LegacySupporterId": "XXXVVVBBRRTYYY##456"}]}'; 
        static Final String sInputJSON6='{"AccountList":[{"AccountName": "Anotnio", "PersonalEmail": "tes","GlobalId":"abcd3456789","UndeliverableInvalid":"Business Email", "LegacySupporterId": "XXXVVVBBRRTYYY##456"}]}'; 
            public testMethod static void testCreateAccount()
        {        
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            Test.StartTest() ; 
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount(); 
            
             req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON2);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount(); 
            
             req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON3);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();   
            
              req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON5);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();     
            
              req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON4);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();    
            
               req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON6);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();    
            
          Test.StopTest() ;   
        }  
        
            
        public testMethod static void testCreateAccount1()
        {        
            //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
            Test.StartTest() ; 
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            List<JSON_Process__c> delProcess = [ Select ID from JSON_Process__c where NAme = 'XMPieErrorMessage' ] ;  
            delete delProcess ;
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount(); 
            
             req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON2);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount(); 
            
             req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON3);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();   
            
              req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON5);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();     
            
              req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON4);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();    
            
               req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createAccount';
            req.requestBody=Blob.valueOf(sInputJSON6);  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            
            system.assertEquals('POST', req.httpMethod);
            CreateAccountRESTServices.createAccount();    
            
            
          Test.StopTest() ;   
        }  
    
    }