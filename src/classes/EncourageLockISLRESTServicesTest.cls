/******************************************************************************
Name             : EncourageLockISLRESTServicesTest
Description      : Test class for EncourageLockISLRESTServices                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class EncourageLockISLRESTServicesTest{

    private Static List<Account> getAccountData()
    {    

        User user6 = new User();
        user6.Username= 'testusertest66@test.com';
        user6.Email= 'test6@test.com';
        user6.Lastname= 'user';
        user6.Firstname= 'test66';
        user6.isActive = true;
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
        //--------------
        
        ID BenRecTypeID = Utility.getRecordType ('Beneficiary' , 'Account') ; 
        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Status__c='Active',Name='Testdata1',ownerid = user6.id);
        Account oAccountVar2=new Account(Status__c='Active',Name='Testdata2',ownerid = user6.id);
        oAccountVar1.RecordtypeID = BenRecTypeID ; 
        oAccountVar2.RecordtypeID = BenRecTypeID ; 
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        
        return  lstAccountTestData;
    }

    public testMethod static void updateEncourageLockTest1(){
         
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            Delete lstAccountTestData[0] ;
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
            req.addParameter('BeneficiaryId', lstAccountTestData[0].Id );   
            req.addParameter('EncourageLockDate', '2015-02-09T16:06:38.997Z');      
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res; 
            EncourageLockISLRESTServices.updateEncourageLockRESTServices();

            Test.StopTest() ; 
     }

     public testMethod static void updateEncourageLockTest2(){
         
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries/availabletoencourage/lock?';
            req.addParameter('BeneficiaryId', lstAccountTestData[0].ID);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            EncourageLockISLRESTServices.updateEncourageLockRESTServices();
            
            System.Assert (  RestContext.response.statusCode == 400   ) ; 
            
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
            req.addParameter('BeneficiaryId', lstAccountTestData[1].ID);   
            req.addParameter('EncourageLockDate', '2015-02-09T16:06:38.997Z');      
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res; 
            EncourageLockISLRESTServices.updateEncourageLockRESTServices();

            System.Assert (  RestContext.response.statusCode == 201   ) ; 
            
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
            req.addParameter('BeneficiaryId', 'Bad Input');   
            req.addParameter('EncourageLockDate', '2015-02-09T16:06:38.997Z');      
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res; 
            EncourageLockISLRESTServices.updateEncourageLockRESTServices();

            Contact contact=new Contact(AccountId=lstAccountTestData[0].Id,LastName='Test Contact');
            insert contact;
            
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/getAccount';
            req.addParameter('BeneficiaryId', contact.ID );   
            req.addParameter('EncourageLockDate', '2015-02-09T16:06:38.997Z');      
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res; 
            EncourageLockISLRESTServices.updateEncourageLockRESTServices();

            Test.StopTest() ; 
     }
   
}