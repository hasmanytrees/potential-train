/******************************************************************************
Name             : FetchBeneficaryISLRESTServicesTest
Description      : Test class for FetchBeneficaryISLRESTServices                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class FetchBeneficaryISLRESTServicesTest{

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
        ID SupprtRecTypeID = Utility.getRecordType ('Supporter' , 'Account') ; 
        
        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Status__c='Active',Name='Testdata1',ownerid = user6.id);
        Account oAccountVar2=new Account(Status__c='Active',Name='Testdata2',ownerid = user6.id);
        Account oAccountVar3=new Account(Type='Foundation',Status__c='Active',Name='Testdata3',Business_Email__c='testdata3@testdata.com',Legacy_Supporter_Id__c='3',ownerid = user6.id);
        Account oAccountVar4=new Account(Type='Association',Status__c='Active',Name='Testdata4',Business_Email__c='testdata4@testdata.com',Legacy_Supporter_Id__c='4',ownerid = user6.id);
        
        oAccountVar1.RecordtypeID = BenRecTypeID ; 
        
        oAccountVar2.RecordtypeID = BenRecTypeID ; 
        oAccountVar3.RecordtypeID = SupprtRecTypeID ; 
        oAccountVar4.RecordtypeID = SupprtRecTypeID ;
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        lstAccountTestData.add(oAccountVar3);
        lstAccountTestData.add(oAccountVar4);
        
        return  lstAccountTestData;        
    }
    
    public testMethod static void getBeneficiaryListTest(){  
        
        List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
        List<SBC_Communications__c>  lstSBCComm = new List<SBC_Communications__c> () ;  
        SBC_Communications__c oSBC1 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[0].ID ) ;   
        SBC_Communications__c oSBC2 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID , Correspondence_Type__c = SYSTEM.LABEL.Encourager_Communication ) ;
   //     lstSBCComm.add(oSBC1) ; 
   //     lstSBCComm.add(oSBC2) ; 
            insert oSBC1 ; 
            
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries/availabletoencourage?';
            req.addParameter('Region', 'test');  
            req.addParameter('Country', 'test');
            req.addParameter('Min_Age', '2');
            req.addParameter('Max_Age', '4');
            req.addParameter('gender', 'male');
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;

            lstAccountTestData[1].Gender__c = 'male' ; 
            insert oSBC2 ;

            FetchBeneficaryISLRESTServices.getBeneficiaryList();
            system.Assert ( RestContext.response.statusCode == 200 ) ; 
           
        Test.StopTest() ;     
    }  
    
    public testMethod static void getBeneficiaryListTestTWO(){  
        
        List<Account> lstAccountTestData=getAccountData();
        lstAccountTestData[0].Last_Correspondence_Date__c = System.Today().addMonths( -7 ) ;
         insert lstAccountTestData;
  
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/beneficiaries/availabletoencourage?';
            req.addParameter('skip', '0');  
            req.addParameter('take', '1');
            req.addParameter('id', ' ');
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            FetchBeneficaryISLRESTServices.getBeneficiaryList();
            req.addParameter('take', '101');
            FetchBeneficaryISLRESTServices.getBeneficiaryList();
            req.addParameter('take', 'abc');
            FetchBeneficaryISLRESTServices.getBeneficiaryList();
            
            system.Assert ( RestContext.response.statusCode == 500 ) ; 
            
        Test.StopTest() ;     
    }  
}