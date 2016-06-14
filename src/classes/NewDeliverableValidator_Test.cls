/*****************************************************************************************
    Name             : NewDeliverableValidator_Test
    Description      : Test Class to cover NewDeliverableValidator class providing User access Scenario               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Shanu                   30/10/2014            Created
******************************************************************************************/

@isTest(SeeAllData=false)
public class NewDeliverableValidator_Test{

    //This method is used for creating Agency Test User 
    public static User createAgencyUser()
    {
        User AgencyUser = new User();
        AgencyUser.Username= 'testusertest77@test.com';
        AgencyUser.Email= 'test7@test.com';
        AgencyUser.Lastname= 'user';
        AgencyUser.Firstname= 'test77';
        AgencyUser.Alias= 'test';
        AgencyUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Agency'].Id;
        AgencyUser.TimeZoneSidKey= 'GMT';
        AgencyUser.LocaleSidKey= 'en_US';
        AgencyUser.Managerid = userinfo.getuserid();
        AgencyUser.EmailEncodingKey= 'ISO-8859-1';
        AgencyUser.LanguageLocaleKey= 'en_US';
        AgencyUser.Authorized_Campaign_Owner__c=false;
        insert AgencyUser;
        return AgencyUser;
    }
    
    public static User createSponsorUser()
    {
        User SponsorUser= new User();
        SponsorUser.Username= 'testusertest88@test.com';
        SponsorUser.Email= 'test88888@test.com';
        SponsorUser.Lastname= 'user8';
        SponsorUser.Firstname= 'test88888';
        SponsorUser.Alias= 'tt888';
        SponsorUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sponsor'].Id;
        SponsorUser.TimeZoneSidKey= 'GMT';
        SponsorUser.LocaleSidKey= 'en_US';
        SponsorUser.Managerid = userinfo.getuserid();
        SponsorUser.EmailEncodingKey= 'ISO-8859-1';
        SponsorUser.LanguageLocaleKey= 'en_US';  
        insert SponsorUser;
        return SponsorUser;
    }
    
    //This method is used for checking the User access privilege provided to a particular User who is executing this program
    public static testMethod void checkIfUserAllowed_Test()
    {   
        test.startTest();
        User AgencyUser = createAgencyUser();
        System.runAs(AgencyUser)
        {
            String availableResult = NewDeliverableValidator.checkIfUserAllowed();
            System.assertEquals(availableResult,'true');
        }
        
        User SponsorUser= createSponsorUser();
        System.runAs(SponsorUser)
        {
            String availableResult = MassAdvocateAppealValidator.checkIfUserAllowed();
            System.assertEquals(availableResult,'false');
        }
        test.stopTest();
    }
}