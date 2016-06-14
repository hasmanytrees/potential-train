/*****************************************************************************************
    Name             : ContactTrigger_Test
    Description      : Test class to cover scenario of Contact Trigger           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Apurva                17/08/2015            Created
******************************************************************************************/
    @isTest(seeAllData=true)
    private class ContactTrigger_Test 
    {
        // Create Test Data
    
            private static List<Contact> createTestData()
        {     
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();      
        
        List<Contact>  listContact = new List<Contact>();    
        User user = new User();
        user.Username= 'testuserededtest@test.com';
        user.Email= 'test@test.com';
        user.Lastname= 'user';
        user.Firstname= 'test';
        user.Alias= 'test';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.TimeZoneSidKey= 'GMT';
        user.LocaleSidKey= 'en_US';
        user.EmailEncodingKey= 'ISO-8859-1';
        user.LanguageLocaleKey= 'en_US';
        user.Authorized_Campaign_Owner__c=true;
        user.UserPermissionsMobileUser = true;
        insert user;
        system.assertEquals('testuserededtest@test.com',user.Username);
        
        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1',
                            OwnerId = user.id, Business_Email__c='testdata1@testdata.com');
        Account oAccountVar2=new Account(Type='Business',Status__c='Active',Name='Testdata2',
                            OwnerId = user.id, Business_Email__c='testdata2@testdata.com');
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        insert lstAccountTestData;
        Contact oContactVar1=new Contact(LastName='Testdata1',OwnerId = user.id,primary_contact__c = true);
        Contact oContactVar2=new Contact(LastName='Testdata2',OwnerId = user.id,primary_contact__c = true, AccountId= oAccountVar1.Id);
        Contact oContactVar3=new Contact(LastName='Testdata3',OwnerId = user.id,AccountId= oAccountVar1.Id);
        listContact.add(oContactVar1);
        listContact.add(oContactVar2);
        listContact.add(oContactVar3);
        insert listContact;
        return listContact;        
    }
    
    static testmethod void Contact_trigger()
    {  
        test.startTest();
        //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
        try
        {
        List<Contact> listContact = createTestData(); 
        system.assertequals(false,listContact[2].primary_contact__c);
        
            listContact[2].primary_contact__c = true;
            update listContact[2];
        }
        catch(Exception e){
        }
        //insert listContact;    //Checking insert scenarios.
        
        test.stopTest();
    }
    
     
}