/*****************************************************************************************
    Name             : LeadTrigger_Test
    Description      : Main Lead Trigger test class  to cover all Lead trigger classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class LeadTrigger_Test{

    //Creating Test Data
        private static List<Lead> createTestData()
    {        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();    
     
        List<Lead> listLeadTestData=new List<Lead>();
        Lead leadTestData1=new Lead(LastName='Test Lead1',Company='Test Lead',Lead_Type__c='Church',Email='test@test.com',City='Test City',Lead_Score__c=40,
        State='Test State',Street='Test Street',Country='Test US',PostalCode='12345');
        
        
        
        Lead leadTestData2=new Lead(LastName='Test Lead1',Company='Test Lead',Lead_Type__c='Advocate',Email='test@test.com');

        Campaign campaignTest=new Campaign(Name='Test Campaign',recordtypeId=Utility.getRecordType('Event','Campaign'),Status='Draft');
        insert campaignTest;
        
        
        
         System.assertEquals('Draft', campaignTest.Status);

        Lead leadTestData3=new Lead(LastName='Test Lead1',Company='Test Lead',Lead_Type__c='Church',Email='test@test.com',City='Test City',
        State='Test State',Street='Test Street',Country='Test US',PostalCode='12345',Campaign_Event__c=campaignTest.Id);

        listLeadTestData.add(leadTestData1);
        listLeadTestData.add(leadTestData2);
        listLeadTestData.add(leadTestData3);
        return listLeadTestData;
    }
    
    
     private static testMethod void testLeadUpdate()
    {        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();    
     
        Lead leadTestData1=new Lead(LastName='Test Lead1',Company='Test Lead',Lead_Type__c='Church',Email='test@test.com',City='Test City',Lead_Score__c=40,
        State='Test State',Street='Test Street',Country='Test US',PostalCode='12345');
        insert leadTestData1;
        
        leadTestData1.Lead_Score__c=80;
        update leadTestData1;
        System.assertEquals('12345', leadTestData1.PostalCode);
        
    }

        public static testMethod void testLeadCreation()
    {        
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        List<Lead> listLeadTestData=createTestData();
        Test.startTest();
        insert listLeadTestData;  //Checking Basic insert Scenarios
        
         System.assertEquals('12345', listLeadTestData[2].PostalCode);
        
        Test.stopTest();
    }

  /*  public static testMethod void testLeadCreation2(){

        List<Lead> listLeadTestData=createTestData();
        listLeadTestData[2].OwnerId=[select Id from Group where Name = 'Church Queue' and Type = 'Queue' limit 1].Id;

        Test.startTest();
        insert listLeadTestData;    
        for(Lead leadVar: listLeadTestData){
            leadVar.Status='Active';
            
        }
        update listLeadTestData;    //Checking Basic Update Scenarios
        Test.stopTest();
        String sResponse= LeadConverterHelper.convertLeadCustom(listLeadTestData[2].Id,false);   
        System.assertEquals(sResponse, System.Label.Lead_Conversion_Error2);   //Checking Lead Conversion Error
    }*/
    
         public static testMethod void testLeadCreation3()
     {         
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<Lead> listLeadTestData=createTestData();
     //   insert listLeadTestData;
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
        
        system.assertEquals('testusertest66@test.com',user6.Username);
        Group College_Queue = [Select Id from Group where Name = 'College Queue' and Type = 'Queue' limit 1];
    
         //--------- 
      /*  Group testGroup = new Group(Name='test group', type='Queue');
        insert testGroup;

        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Lead');
        insert testQueue;*/
        
    /*  //  Group testGroup = new Group(Name='test group', Type='Queue');
    //    insert testGroup;
        
      //  System.runAs(new User(Id=UserInfo.getUserId()))
     //   {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Lead');
            insert testQueue;
    //    }*/
   //  Lead leadTobeConverted=[select Id,FirstName,LastName,Salutation,Name,Country,Origin_Source_Code__c,Metro_Area__c,Metro_State__c,Street,State,City,PostalCode,Campaign_Event__c,Email,Phone,Lead_Type__c from Lead where Id=:listLeadTestData[0].id]; // Getting Lead Information
   //         String sLeadType=leadTobeConverted.Lead_Type__c ;

        listLeadTestData[2].OwnerId = College_Queue.Id;  
         Test.startTest();
        insert listLeadTestData;    
        for(Lead leadVar: listLeadTestData){
            leadVar.Status='Active';            
        } 
        //------------
      
         listLeadTestData[2].OwnerId = user6.Id; 
         update listLeadTestData;     
         system.assertEquals(user6.Id,listLeadTestData[2].OwnerId); 
      
      
       
      //  update listLeadTestData;    //Checking Basic Update Scenarios
        
        Test.stopTest();
        String sResponse= LeadConverterHelper.convertLeadCustom(listLeadTestData[2].Id,false);   
        //System.assertEquals(sResponse, System.Label.Lead_Conversion_Error2);   //Checking Lead Conversion Error
    }
    
        public static testMethod void testLeadCreation4()
    {    
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        List<Lead> listLeadTestData=createTestData();
        Map<Id,Lead> mapNewLead = new map<id,Lead>();
        Map<Id,Lead> mapOldLead = new map<id,Lead>();
        
        mapNewLead.put(listLeadTestData[0].id, listLeadTestData[0]);
        mapOldLead.put(listLeadTestData[1].id, listLeadTestData[1]);
        
        User user = new User();
        user.Username= 'testaauuusertest@test.com';
        user.Email= 'test@test.com';
        user.Lastname= 'user';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.UserPermissionsMobileUser = false;
        insert user;
        system.assertEquals('testaauuusertest@test.com',user.Username);
        for(Lead leadVar: listLeadTestData){
            leadVar.ownerId=user.Id;
            leadVar.Lead_Score__c=73;
        }
        Test.startTest();
        insert listLeadTestData; // Checking Insert scenario along with Lead Task Creation
        Test.stopTest();
        Note n = new Note();
        n.parentId=listLeadTestData[0].Id;
        n.body = 'test data';
        n.title = 'sumeet note';
        n.isPrivate=false;
        insert n;
        
        Attachment a = new Attachment();
        a.ParentId=listLeadTestData[0].Id;
        a.Name='Test Name';
        String sVal=' Hi. This is for testing purpose only';
        a.body=Blob.valueOf(sVal);
        a.ContentType='application/text';     
        insert a;   
         Event event = new Event(
            OwnerId = listLeadTestData[0].ownerId,
            WhoId = listLeadTestData[0].id,
            StartDateTime = System.today(),
            EndDateTime = System.today(),
            Subject = 'Go Live'
        );
        insert event ;             
        // Checking Lead Conversion Scenarios
        String sResponse= LeadConverterHelper.convertLeadCustom(listLeadTestData[0].Id,false);
        //System.assertEquals(sResponse, System.Label.Lead_Conversion_Error2);  
        sResponse= LeadConverterHelper.convertLeadCustom(listLeadTestData[0].Id,false);
        //System.assertEquals(sResponse, System.Label.Lead_Conversion_Error2);  
        sResponse= LeadConverterHelper.convertLeadCustom(listLeadTestData[1].Id,false);
        //System.assertEquals(sResponse, System.Label.Lead_Conversion_Error2); 
        LeadTriggerHandler ltHandler = new LeadTriggerHandler();
      //  LeadTriggerHandler.followAndUnfollowHandler(mapNewLead,mapOldLead);
    }

}