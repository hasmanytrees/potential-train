/*****************************************************************************************
    Name             : MassAdvocateAppealValidator_Test
    Description      : Test Class to cover MassAdvocateAppealValidator class providing User access Scenario               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                  30/10/2014            Created
Sumeet                  29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=false)
public class MassAdvocateAppealValidator_Test{


    //This method is used for creating Admin Test User 
    public static User createAdminUser()
    {
        User AdminUser = new User();
        AdminUser.Username= 'testusertest66@test.com';
        AdminUser.Email= 'test6@test.com';
        AdminUser.Lastname= 'user';
        AdminUser.Firstname= 'test66';
        AdminUser.Alias= 'test';
        AdminUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        AdminUser.TimeZoneSidKey= 'GMT';
        AdminUser.LocaleSidKey= 'en_US';
        AdminUser.Managerid = userinfo.getuserid();
        AdminUser.EmailEncodingKey= 'ISO-8859-1';
        AdminUser.LanguageLocaleKey= 'en_US';
        AdminUser.Authorized_Campaign_Owner__c=true;
        AdminUser.UserPermissionsMobileUser = true;
        insert AdminUser;
        return AdminUser;
    }
    
    //This method is used for creating Admin Test User 
    public static User createStandardUser()
    {
        User StandardUser = new User();
        StandardUser.Username= 'testusertest66666666@test.com';
        StandardUser.Email= 'test666666@test.com';
        StandardUser.Lastname= 'user6';
        StandardUser.Firstname= 'test666666';
        StandardUser.Alias= 'tt666';
        StandardUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        StandardUser.TimeZoneSidKey= 'GMT';
        StandardUser.LocaleSidKey= 'en_US';
        StandardUser.Managerid = userinfo.getuserid();
        StandardUser.EmailEncodingKey= 'ISO-8859-1';
        StandardUser.LanguageLocaleKey= 'en_US';
        StandardUser.Authorized_Campaign_Owner__c=true;
        StandardUser.UserPermissionsMobileUser = true;
        insert StandardUser;
        return StandardUser;
    }
    
    //This method is used for checking the User access privilage provided to a particular User who is executing this program
    public static testMethod void checkIfUserAllowed_Test()
    {   
        test.startTest();
        User adminUser = createAdminUser();
        System.runAs(adminUser)
        {
            String availableResult = MassAdvocateAppealValidator.checkIfUserAllowed();
            System.assertEquals(availableResult,'true');
        }
        User standardUser = createStandardUser();
        System.runAs(standardUser)
        {
            String availableResult = MassAdvocateAppealValidator.checkIfUserAllowed();
            System.assertEquals(availableResult,'false');
        }
        
        
        test.stopTest();
    }
}