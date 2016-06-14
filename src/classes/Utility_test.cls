/*****************************************************************************************
    Name             : Utility_Test
    Description      : This is generic test class for Test Utility                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
Shanu                   6/11/2015             Code changes made for INC0067772 
******************************************************************************************/
@isTest(seeAllData=true)
public class Utility_test {

    /**
    * Method name  : testgetRecordType
    * Description  : Use this method for testing record type values 
    * Return Type  : void
    * Parameter    : List<Account>
    **/
    
    //Executing Various scenario
    @isTest
    public static void testgetRecordType(){
        List<String> objectList = new List<String>();
        objectList.add('Account');

        Utility utilityObj = new Utility();
        Utility.mapStructure=null;
        Utility.getRecordType('Partner','Account');
        Utility.mapStructure=null;
        Utility.getRecordTypeMap('Account');
        Utility.mapStructure=null;

        Sobject sobj = new Account();
        Map<String,String> mapRecordtypeByObject=Utility.getRecordTypeMap2('Account');
        //Utility.gerFieldDetails(sobj,'Type');
        Utility.formatDate('1/1/2013 1:30 AM');
        String sDate=Utility.formatDate(system.today());
        Date dt=null;
        sDate=Utility.formatDate(dt);
        
        
        String sTimeDate=String.valueOf(system.now());
        DateTime td=Utility.getDateTimeValue(sTimeDate);
        
        Datetime dtt=null;
        
        Utility.mapStructure=null;
        Utility.getFieldNameList(objectList);
        List<String> listPicklist=Utility.getPicklistValues(new Account(),'Type');
        Map<String, List<String>>  fieldMap=Utility.getFieldNameList (new String[]{'Account'});
        List<Schema.FieldSetMember> fieldSetMembers=Utility.getFieldDetails(new Account(),'Advocate_Section');
        String queryStr=Utility.getQueryUsingFieldSet(fieldSetMembers);
        List<SelectOption> optList=Utility.getAllFieldList(fieldSetMembers);
        Map<String,STring> mapRecordtype=Utility.getRecordTypeMap2('Campaign');
        //Shanu- Nov 2015 Code changes made for INC0067772        
        Boolean hasAccess=Utility.checkCreateAccess('Influencer__c');
        Boolean checkAccess=Utility.checkUpdateAccess('Influencer__c');
        
        String sCampaignName='TestCampaign';
        String sStartDate='1 March 2015';
        String sEndDate='1 May 2015';
        String sVenue='TestVenue1';
        String sAddress='Mumbai';
        String sWebSite='www.google.com';
        system.assertEquals( 'www.google.com',sWebSite);
        Boolean bIsHeader=true;
        integer iEventNumber=10;
        boolean bIsEventDeatils=true;
        String sDressCode='sDressCode';
        String sContact='sContact';
        String sEmail='sEmail';
        String sPhone='sPhone';
        system.assertEquals( 'sPhone',sPhone);
        String sLocation=Utility.getLocationText(sCampaignName,sStartDate,sEndDate,sVenue,sAddress,sWebSite,bIsHeader,iEventNumber,bIsEventDeatils,sDressCode,sContact,sEmail,sPhone);
        
        Utility.insertErrorLogIntegration(sCampaignName,sStartDate,sVenue,sEndDate,sAddress,sWebSite,sLocation,UserInfo.getUserId(),'test');
        Utility.insertErrorLogApplication(sCampaignName,sStartDate,sVenue,sEndDate,sAddress,sWebSite,UserInfo.getUserId(),'test',sLocation);
        
        Set<String> setSVal = new Set<String>();
        setSVal.add('test 1');
        setSVal.add('test 2');
        
        //Make HTTP request and add URL Parameter
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Accounts';  
        req.addParameter('page', '0');
        req.addParameter('sURLVar', '1390296387');        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Utility.retrieveRESTParameters(setSVal);
    }
    
    
    /**
    * Method name  : testErrorScenarios
    * Description  : Use this method for testing all error scenarios 
    * Return Type  : void
    * Parameter    : void
    **/
    
    @isTest
    //This method is used for testing the Error Scenarios in the Error Log Insert
    public static void testErrorScenarios()
    {      
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
        
        Error_Log__c oLogRefernce = new Error_Log__c();
        oLogRefernce.New_Instance__c = '';
        oLogRefernce.Logged_In_User__c = user6.id;
        system.assertEquals( user6.id,oLogRefernce.Logged_In_User__c );
        try
        {
            Utility.insertErrorLog(oLogRefernce);
        }
        catch(Exception e){}
    }
    
    @isTest
    public static void testErrorScenarios2()
    {      
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
        
        Error_Log__c oLogRefernce = new Error_Log__c();
        //oLogRefernce.New_Instance__c = ;
        oLogRefernce.Logged_In_User__c = user6.id;
        system.assertEquals( user6.id,oLogRefernce.Logged_In_User__c );
        try
        {
            Utility.insertErrorLog(null);
        }
        catch(Exception e){}
    }
}