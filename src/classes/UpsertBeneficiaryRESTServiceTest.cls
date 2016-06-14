/******************************************************************************
Name             : UpsertBeneficiaryRESTServiceTest
Description      : Test class for UpsertBeneficiaryRESTService                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class UpsertBeneficiaryRESTServiceTest{

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
    
    public testMethod static void upsertBeneficiaryTest(){
         
         List<Account> lstAccountTestData=getAccountData();
         lstAccountTestData[0].Status__c = 'Sponsored' ; 
         lstAccountTestData[1].Status__c = 'Unsponsored' ;
         insert lstAccountTestData;
         
         SObjectType oAccountSchema= Schema.getGlobalDescribe().get
        ('Account');
        Map<String,Schema.SObjectField> mapFieldSchemaSBC = 
        oAccountSchema.getDescribe().fields.getMap();
        
        //Forming the query all fields for communication Preference object.
        String sQueryAccount='select ';
        for(String sFieldVar: mapFieldSchemaSBC.keySet())
        sQueryAccount+=sFieldVar+',';
        sQueryAccount=sQueryAccount.subStringbeforeLast(',');
        
        sQueryAccount += ' from Account where ID IN : lstAccountTestData' ;
        
        List<Account> lstAccounts=new List<Account>();
        lstAccounts=(List<Account> )Database.Query(sQueryAccount);
         
         Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
         mapOutput.put('BeneficiaryGroup',lstAccounts);
            //Getting Final JSON String
        String sJsonStructure=
        JSONHandlerMethods.serialize(mapOutput,
        'CreateUpdateBeneficiaryProcess'); 
         sJsonStructure =sJsonStructure.replace('"null"', 'null');
         
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF ( sJsonStructure ) ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/upsertBeneficiary?';
            req.addParameter('BeneficiaryId', lstAccountTestData[0].ID);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            UpsertBeneficiaryRESTService.upsertBeneficiary();
        
            System.Assert ( RestContext.response.statusCode == 500 ) ; 
        Test.StopTest() ;
    }
    
    public testMethod static void upsertBeneficiary2Test(){
         
         /*
         String randomInt1 = String.valueOf(math.rint(math.random()*1000000));
         String uniqueName1 = orgId + randomInt1;

         Integer randomInt2 = Integer.valueOf(math.rint(math.random()*1000000));
         String uniqueName2 = orgId + randomInt2;
        */
         
         List<Account> lstAccountTestData=getAccountData();
         lstAccountTestData[0].Status__c = 'Sponsored' ; 
         lstAccountTestData[1].Status__c = 'Unsponsored' ;
         lstAccountTestData[0].Compass_Child_Key__c = String.valueOf(math.random()*100000)+'ZYX' ; 
         lstAccountTestData[1].Compass_Child_Key__c = String.valueOf(math.random()*100000)+'ZYX' ;
         insert lstAccountTestData;
         
         SObjectType oAccountSchema= Schema.getGlobalDescribe().get
        ('Account');
        Map<String,Schema.SObjectField> mapFieldSchemaSBC = 
        oAccountSchema.getDescribe().fields.getMap();
        
        //Forming the query all fields for communication Preference object.
        String sQueryAccount='select ';
        for(String sFieldVar: mapFieldSchemaSBC.keySet())
        sQueryAccount+=sFieldVar+',';
        sQueryAccount=sQueryAccount.subStringbeforeLast(',');
        
        sQueryAccount += ' from Account where ID IN : lstAccountTestData' ;
        
        List<Account> lstAccounts=new List<Account>();
        lstAccounts=(List<Account> )Database.Query(sQueryAccount);
         
         Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
         mapOutput.put('BeneficiaryGroup',lstAccounts);
            //Getting Final JSON String
        String sJsonStructure=
        JSONHandlerMethods.serialize(mapOutput,
        'CreateUpdateBeneficiaryProcess'); 
         sJsonStructure =sJsonStructure.replace('"null"', 'null');
         
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF ( sJsonStructure ) ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/upsertBeneficiary?';
            req.addParameter('BeneficiaryId', lstAccountTestData[0].ID);  
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            UpsertBeneficiaryRESTService.upsertBeneficiary();
        
            System.Assert ( RestContext.response.statusCode == 200) ; 
        Test.StopTest() ;
    }
}