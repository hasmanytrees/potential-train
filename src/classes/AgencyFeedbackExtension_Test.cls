/*****************************************************************************************
    Name             : AgencyFeedbackExtension_Test
    Description      : Test class for vf controller           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
        public class AgencyFeedbackExtension_Test
    {
        //create test data
        private static Id createTestData(){
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();

        Account oAgencyTest=new Account(Name='Test Agnecy',Business_Email__c='test@test.com',recordtypeId=Utility.getRecordType('Agency','Account'));
        insert oAgencyTest;
        List<Agency_Feedback__c> lstAgnecyFeedbackTest = new  List<Agency_Feedback__c>();
        Agency_Feedback__c oTestFeedback1=new Agency_Feedback__c(Agency__c=oAgencyTest.Id,Creative__c='3',Customer_Service__c='2',Overall_Experience__c='4',
        Pricing__c='5',   Timeliness__c='3');

        Agency_Feedback__c oTestFeedback2=new Agency_Feedback__c(Agency__c=oAgencyTest.Id,Creative__c='3',Customer_Service__c='2',Overall_Experience__c='4',
        Pricing__c='5',   Timeliness__c='3');

        Agency_Feedback__c oTestFeedback3=new Agency_Feedback__c(Agency__c=oAgencyTest.Id,Creative__c='3',Customer_Service__c='2',Overall_Experience__c='4',
        Pricing__c='5',   Timeliness__c='3');
        lstAgnecyFeedbackTest.add(oTestFeedback1);
        lstAgnecyFeedbackTest.add(oTestFeedback2);   
        lstAgnecyFeedbackTest.add(oTestFeedback3);   
        insert lstAgnecyFeedbackTest; 
        
            system.assertEquals('3',lstAgnecyFeedbackTest[2].Creative__c);
            
            system.assertEquals('4',lstAgnecyFeedbackTest[1].Overall_Experience__c);
            
            system.assertEquals('5',lstAgnecyFeedbackTest[0].Pricing__c);
        
        return oAgencyTest.Id  ;                          

    }
        //Covering AgencyFeedbackExtension class
        public static testMethod void testAgencyFeedbackVf()
    {
        test.startTest();
        //List<Trigger_Methods_Activation__c>  lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        
        List<User> lstUserTest=new List<User>();
        Account oAccountTest=new Account(Id=createTestData());
        User oUserTest1 = new User();
        oUserTest1 .Username= 'testausertest@test.com';
        oUserTest1 .Email= 'test@test.com';
        oUserTest1 .Lastname= 'user';
        oUserTest1 .Firstname= 'test';
        oUserTest1 .Alias= 'test';
        oUserTest1 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        oUserTest1 .TimeZoneSidKey= 'GMT';
        oUserTest1 .LocaleSidKey= 'en_US';
        oUserTest1 .EmailEncodingKey= 'ISO-8859-1';
        oUserTest1 .LanguageLocaleKey= 'en_US';
        oUserTest1 .UserPermissionsMobileUser = false;
        oUserTest1.Authorized_Campaign_Owner__c=true;
        User oUserTest2 = new User();
        oUserTest2 .Username= 'testaaausertest2@test.com';
        oUserTest2 .Email= 'test2@test.com';
        oUserTest2 .Lastname= 'user2';
        oUserTest2 .Firstname= 'test2';
        oUserTest2 .Alias= 'test2';
        oUserTest2 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        oUserTest2 .TimeZoneSidKey= 'GMT';
        oUserTest2 .LocaleSidKey= 'en_US';
        oUserTest2 .EmailEncodingKey= 'ISO-8859-1';
        oUserTest2 .LanguageLocaleKey= 'en_US';
        oUserTest2 .UserPermissionsMobileUser = false;
        User oUserTest3 = new User();
        oUserTest3 .Username= 'testbusertest3@test.com';
        oUserTest3 .Email= 'test3@test.com';
        oUserTest3 .Lastname= 'user3';
        oUserTest3 .Firstname= 'test3';
        oUserTest3 .Alias= 'test3';
        oUserTest3 .ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        oUserTest3 .TimeZoneSidKey= 'GMT';
        oUserTest3 .LocaleSidKey= 'en_US';
        oUserTest3 .EmailEncodingKey= 'ISO-8859-1';
        oUserTest3 .LanguageLocaleKey= 'en_US';
        oUserTest3 .UserPermissionsMobileUser = false;
        lstUserTest.add(oUserTest1 );
        lstUserTest.add(oUserTest2 );
        lstUserTest.add(oUserTest3 );
        insert lstUserTest;
        
        system.assertEquals('GMT', oUserTest3.TimeZoneSidKey);
          system.assertEquals(false,oUserTest2.UserPermissionsMobileUser);
           system.assertEquals( 'test',oUserTest1.Firstname);
           
        // Checking validation flow 
        System.runAs(lstUserTest[0])
        {
            AgencyFeedbackExtension agencyFeedbackVf=new AgencyFeedbackExtension (new ApexPages.StandardController(oAccountTest));
            ApexPages.currentPage().getParameters().put('id', oAccountTest.id);
        }

        System.runAs(lstUserTest[1])
        {
            AgencyFeedbackExtension agencyFeedbackVf=new AgencyFeedbackExtension (new ApexPages.StandardController(oAccountTest));
            ApexPages.currentPage().getParameters().put('id', oAccountTest.id);
        } 

        System.runAs(lstUserTest[2])
        {
            AgencyFeedbackExtension agencyFeedbackVf=new AgencyFeedbackExtension (new ApexPages.StandardController(oAccountTest));
            ApexPages.currentPage().getParameters().put('id', oAccountTest.id);
        }
       
            Test.stopTest();

    }
}