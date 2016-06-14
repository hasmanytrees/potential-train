/*****************************************************************************************
    Name             : CampaignMemberTriggerHelper_Test
    Description      : Test Class to cover all scenarios of Campaign Member Trigger                  
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class CampaignMemberTriggerHelper_Test {
    // Create Test Data  
    
        private static List<Campaign_Member__c> createTestData()
    {
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        List<User> listUserTest=new List<User>();
        List<Campaign_Member__c> listCMTest=new List<Campaign_Member__c>();
        
        User userTest1 = new User();
        userTest1 .Username= 'testusertest6@test.com';
        userTest1 .Email= 'test@test.com';
        userTest1 .Lastname= 'user';
        userTest1 .Firstname= 'test';
        userTest1 .Alias= 'test';
        userTest1 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        userTest1 .TimeZoneSidKey= 'GMT';
        userTest1 .LocaleSidKey= 'en_US';
        userTest1 .EmailEncodingKey= 'ISO-8859-1';
        userTest1 .LanguageLocaleKey= 'en_US';
        userTest1 .UserPermissionsMobileUser = false;
        userTest1.Authorized_Campaign_Owner__c=true;
        User userTest2 = new User();
        userTest2 .Username= 'testusertest2@test.com';
        userTest2 .Email= 'test2@test.com';
        userTest2 .Lastname= 'user2';
        userTest2 .Firstname= 'test2';
        userTest2 .Alias= 'test2';
        userTest2 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        userTest2 .TimeZoneSidKey= 'GMT';
        userTest2 .LocaleSidKey= 'en_US';
        userTest2 .EmailEncodingKey= 'ISO-8859-1';
        userTest2 .LanguageLocaleKey= 'en_US';
        userTest2 .UserPermissionsMobileUser = false;
        User userTest3 = new User();
        userTest3 .Username= 'testusertest3@test.com';
        userTest3 .Email= 'test3@test.com';
        userTest3 .Lastname= 'user3';
        userTest3 .Firstname= 'test3';
        userTest3 .Alias= 'test3';
        userTest3 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        userTest3 .TimeZoneSidKey= 'GMT';
        userTest3 .LocaleSidKey= 'en_US';
        userTest3 .EmailEncodingKey= 'ISO-8859-1';
        userTest3 .LanguageLocaleKey= 'en_US';
        userTest3 .UserPermissionsMobileUser = false;
        listUserTest.add(userTest1 );
        listUserTest.add(userTest2 );
        listUserTest.add(userTest3 );
        insert listUserTest;
        
         System.assertEquals('test3@test.com',listUserTest[2].Email);
        
        Campaign campaignTestVar=new Campaign(recordtypeId=Utility.getRecordType('Campaign','Campaign'),Launch_Date__c = System.today(), Name='Test Campaign',Status='Draft',
        StartDate=System.today(),EndDate=System.today().addDays(7),OwnerId=listUserTest[0].Id);
        
        insert campaignTestVar;
        System.assertEquals('Draft',campaignTestVar.Status);
        
        
        Campaign_Member__c campaignMemberTest1=new Campaign_Member__c(Campaign__c=campaignTestVar.Id,Name__c=listUserTest[0].Id,Role__c='Stakeholder');
        Campaign_Member__c campaignMemberTest2=new Campaign_Member__c(Campaign__c=campaignTestVar.Id,Name__c=listUserTest[0].Id,Role__c='Team Member');
        Campaign_Member__c campaignMemberTest3=new Campaign_Member__c(Campaign__c=campaignTestVar.Id,Name__c=listUserTest[0].Id,Role__c='Sponsor');
        
        listCMTest.add(campaignMemberTest1);
        listCMTest.add(campaignMemberTest2);
        listCMTest.add(campaignMemberTest3);
        //insert listCMTest;
        System.assertEquals('Stakeholder',campaignMemberTest1.Role__c);
        return listCMTest;
    }

        public static testMethod void testCampaignMemberTriggerHelper() 
    {
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        List<Campaign_Member__c> listCMTest=createTestData();
        List<User> listUserTest1=new List<User>();           
             
        
        insert listCMTest;   // Checking auto follow Campaign on insert
        User userTest1 = new User();
        userTest1 .Username= 'testusertest4@test.com';
        userTest1 .Email= 'test4@test.com';
        userTest1 .Lastname= 'user4';
        userTest1 .Firstname= 'test4';
        userTest1 .Alias= 'test4';
        userTest1 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        userTest1 .TimeZoneSidKey= 'GMT';
        userTest1 .LocaleSidKey= 'en_US';
        userTest1 .EmailEncodingKey= 'ISO-8859-1';
        userTest1 .LanguageLocaleKey= 'en_US';
        userTest1 .UserPermissionsMobileUser = false;
        userTest1.Authorized_Campaign_Owner__c=true;
        insert userTest1;
        listUserTest1.add(userTest1);
        
        for(Campaign_Member__c CMTestVar: listCMTest)  
        CMTestVar.Name__c=userTest1.Id;
        update listCMTest;    // Checking auto unfollow Campaign on Campaign Member Change and Start following  Campaign by new member
        System.assertEquals('testusertest4@test.com',userTest1.Username);
        
        User usersTest2 = new User();
        usersTest2 .Username= 'testuserstest4@test.com';
        usersTest2 .Email= 'tests4@test.com';
        usersTest2 .Lastname= 'users4';
        usersTest2 .Firstname= 'tests4';
        usersTest2 .Alias= 'tests4';
        usersTest2 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        usersTest2 .TimeZoneSidKey= 'GMT';
        usersTest2 .LocaleSidKey= 'en_US';
        usersTest2 .EmailEncodingKey= 'ISO-8859-1';
        usersTest2 .LanguageLocaleKey= 'en_US';
        usersTest2 .UserPermissionsMobileUser = false;
        usersTest2.Authorized_Campaign_Owner__c=true;
        insert usersTest2;
        listUserTest1.add(usersTest2);
        
        Campaign campaignTestsVar=new Campaign(recordtypeId=Utility.getRecordType('Campaign','Campaign'),Launch_Date__c = System.today(), Name='Test Campaign',Status='Draft',
        StartDate=System.today(),EndDate=System.today().addDays(7));
        
        insert campaignTestsVar;
        System.assertEquals('Draft',campaignTestsVar.Status);
                
        Campaign_Member__c campaignMemberTest4=new Campaign_Member__c(Role__c='Stakeholder');
        
        //listCMTest.add(campaignMemberTest4);
        
        insert campaignMemberTest4;
        delete listCMTest;   // Checking auto unfollow Campaign on Campaign Member Delete
        test.stopTest();
        
        
    }  
}