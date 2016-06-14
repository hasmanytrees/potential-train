@isTest(seeAllData=true)            
global class OldAndNewJSONGeneratorHelper_Test {
    // Implement this interface method
    global HttpResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       if(req.getEndpoint()=='https://api2.compassion.com/US/1/TEST/Supporter/ProfileUpdate?api_key=cnmv58dutyhwex8z2nmud4fb'){
        System.assertEquals('https://api2.compassion.com/US/1/TEST/Supporter/ProfileUpdate?api_key=cnmv58dutyhwex8z2nmud4fb', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
        
       }
       else if(req.getEndpoint()=='https://api2.compassion.com/core/connect/token'){
           System.assertEquals('https://api2.compassion.com/core/connect/token', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImEzck1VZ01Gdjl0UGNsTGE2eUYzekFrZnF1RSIsImtpZCI6ImEzck1VZ01Gdjl0UGNsTGE2eUYzekFrZnF1RSJ9.eyJjbGllbnRfaWQiOiJjbGllbnQiLCJzY29wZSI6WyJyZWFkIiwid3JpdGUiXSwiaXNzIjoiaHR0cHM6Ly9pZHNydjMuY29tIiwiYXVkIjoiaHR0cHM6Ly9pZHNydjMuY29tL3Jlc291cmNlcyIsImV4cCI6MTQyNDM0OTQ2MCwibmJmIjoxNDI0MzQ1ODYwfQ.eHzmfeExxcWvtqXDwj_m2nlhsnv86G6P4Ea804gJswwkn7XXT3SPJ-gtri6KbNMqea4ejsVXkPauVkKzvnXqvxq-dbzlpU6d2-eslSogleVomj8ZZnzXSwrMmY-Z7kGAzpuMrBFTB0WwudF-PXDYcNVktTSTPLCiClb9wnJbA7LZhoi_cpVS4t3fFdgwP1gk1W1jDeTVLXGXBF9gm9uc2oxqAw8CfzUJKB7HpI6qQVqM7XV15PwiQYPbL2MssVp6KLeMI5QF3RB-TIj9QkJujNxP_W6-SJX0d9tBz9dClP3wF0q8bc4E8BhJBtBC6S4rVfpct8ZHB5Ortqg6JXS8rg","expires_in": 3600,"token_type": "Bearer"}');
        res.setStatusCode(200);
        return res;
       
       
       }
       return null;
    }
       public static testMethod  void createTestData()
   {
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
       List<Integration_Endpoints__c> listEndPoint=new List<Integration_Endpoints__c>();
       Integration_Endpoints__c endPoint1 =new Integration_Endpoints__c(Name='Compass Endpoint',Endpoint_URL__c='https://api2.compassion.com/US/1/TEST/Supporter/ProfileUpdate',
                                                                            Authorization_Code__c='cnmv58dutyhwex8z2nmud4fb');
 
         Integration_Endpoints__c endPoint2 =new Integration_Endpoints__c(Name='Access Token test',Endpoint_URL__c='https://api2.compassion.com/core/connect/token');                                                                        
        listEndPoint.add(endPoint2 );
        
         insert listEndPoint;        
        
        JSON_Process__c process=new JSON_Process__c(Name='SampleBiztalkJSON');
        insert process;
        
        Field_Group__c fieldGroup=new Field_Group__c(Name='NewJSON');
        
        insert fieldGroup;
        
        List<Field_Group_Element__c> listFieldGroupItem=new List<Field_Group_Element__c>();
        
            Field_Group_Element__c item1=new Field_Group_Element__c(Field_API_Name__c='Preferred_Email_Address__c',Token_Name__c='PreferredEmail',
                                                                        Field_Group__c=fieldGroup.Id,    Field_Type__c='TEXT');
        
            Field_Group_Element__c item2=new Field_Group_Element__c(Field_API_Name__c='Work_Phone__c',Token_Name__c='Workphone',
                                                                        Field_Group__c=fieldGroup.Id,    Field_Type__c='TEXT');
        
        listFieldGroupItem.add(item1);
        listFieldGroupItem.add(item2);
        insert listFieldGroupItem;
        
          System.assertEquals('TEXT', listFieldGroupItem[1].Field_Type__c);
        
        JSON_Structure__c structure=new JSON_Structure__c(Array_Token_Name__c='SupporterUpdateDetails',is_Array__c=true,JSON_Process__c=process.Id,Field_Group__c=fieldGroup.Id);
        
        insert structure;  
   }
   
      public static testMethod void genrateOldNewJSONTest()
   {
        Test.startTest();
        
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        Account accountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',Business_Email__c='testdata1@testdata.com', Legacy_Partner_Id__c = 'test - id', Legacy_Supporter_Id__c = 'test - id');
        insert accountVar1;
        
         System.assertEquals('testdata1@testdata.com', accountVar1.Business_Email__c);
        
         //Test.setMock(HttpCalloutMock.class, new OldAndNewJSONGeneratorHelper_Test());
            Account accountVar2=new Account(Id=accountVar1.Id,Type='Church',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com', Legacy_Partner_Id__c = 'test - id - ',  Legacy_Supporter_Id__c = 'test - id');
        update accountVar2;
         Test.stopTest();  
         // Test.startTest();        
              
         // OldAndNewJSONGeneratorHelper.getOldAndNewJSON(JSON.serialize(accountVar1),JSON.serialize(accountVar2));
         //Test.stopTest();       
   }
}