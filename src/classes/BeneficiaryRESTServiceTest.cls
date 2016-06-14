/******************************************************************************
Name             : BeneficiaryRESTServiceTest
Description      : Test class for BeneficiaryRESTService                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class BeneficiaryRESTServiceTest{

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
    
    public testMethod static void getBeneficiaryTest(){
        
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries';
            req.addParameter(System.Label.BeneficiaryId, lstAccountTestData[0].ID);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            BeneficiaryRESTService.getBeneficiary();
            
            system.Assert( RestContext.response.responseBody != NULL ) ; 
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries';
            req.addParameter(System.Label.BeneficiaryId, 'Bad Input');  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            BeneficiaryRESTService.getBeneficiary();
    }
    //check 
    public testMethod static void getBeneficiaryTest2 (){
        
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
         Field_Group__c grpDelete = [ Select ID from Field_Group__c where name = 'BeneficiaryGroup']  ; 
           delete grpDelete ; 
         
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries';
            req.addParameter(System.Label.BeneficiaryId, lstAccountTestData[0].ID);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            BeneficiaryRESTService.getBeneficiary();
            
            system.Assert( RestContext.response.responseBody == NULL ) ; 
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries';
            req.addParameter(System.Label.BeneficiaryId, 'Bad Input');  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            BeneficiaryRESTService.getBeneficiary();
    }
}