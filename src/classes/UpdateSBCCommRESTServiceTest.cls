/******************************************************************************
Name             : UpdateSBCCommRESTServiceTest
Description      : Test class for UpdateSBCCommRESTService                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/

@isTest(seeAllData=true)
public class UpdateSBCCommRESTServiceTest{

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
    
    public testMethod static void updateSBCCommunicationsTest(){
         
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
            UpdateSBCCommRESTService.updateSBCCommunications();
        
            System.Assert ( RestContext.response.statusCode == 500 ) ; 
        Test.StopTest() ;
    }
    
    public testMethod static void updateSBCCommunications2Test(){
         
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
        List<SBC_Communications__c>  lstSBCComm = new List<SBC_Communications__c> () ;  
        SBC_Communications__c oSBC1 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[0].ID , SBC_Global_Id__c =  String.valueOf(math.random()*100000)+'ZYX' ,
                                                                  Batch_ID__c = String.valueOf(math.random()*100000)+'SCF' , Sequence_ID__c = String.valueOf(math.random()*100000)+'OUY') ;   
        SBC_Communications__c oSBC2 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID , Correspondence_Type__c = SYSTEM.LABEL.Encourager_Communication ,
                                                                   SBC_Global_Id__c =  String.valueOf(math.random()*100000)+'ZYX' , Batch_ID__c = String.valueOf(math.random()*100000)+'SCF',  
                                                                                       Sequence_ID__c = String.valueOf(math.random()*100000)+'OUY') ;
        lstSBCComm.add(oSBC1) ; 
        lstSBCComm.add(oSBC2) ; 
            insert lstSBCComm ; 

         
        SObjectType oSBCSchema= Schema.getGlobalDescribe().get
        ('SBC_Communications__c');
        Map<String,Schema.SObjectField> mapFieldSchemaSBC = 
        oSBCSchema.getDescribe().fields.getMap();
        
        //Forming the query all fields for communication Preference object.
        String sQuerySBCCom ='select ';
        for(String sFieldVar: mapFieldSchemaSBC.keySet())
        sQuerySBCCom +=sFieldVar+',';
        sQuerySBCCom =sQuerySBCCom .subStringbeforeLast(',');
        
        sQuerySBCCom += ' from SBC_Communications__c where ID IN: lstSBCComm ' ;
        
        List<SBC_Communications__c> lstSBCCommRecs=new List<SBC_Communications__c>();
        lstSBCCommRecs=(List<SBC_Communications__c> )Database.Query(sQuerySBCCom);
         
         Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
         mapOutput.put('SBCCommInboundUpdateProcess',lstSBCCommRecs);
            //Getting Final JSON String
        String sJsonStructure=
        JSONHandlerMethods.serialize(mapOutput,
        'SBCCommInboundUpdateProcess'); 
         sJsonStructure =sJsonStructure.replace('"null"', 'null');
         
         system.debug ( 'sJsonStructure?>?>' + sJsonStructure ) ; 
         
         List<SBC_Communications__c> lstSBCCommunicationRetrieved = new List<SBC_Communications__c>();
         List<SBC_Communications__c> lstSBCCommunicationRetrievedFinal = new List<SBC_Communications__c>();
         lstSBCCommunicationRetrieved = 
         (List<SBC_Communications__c>)JSONHandlerMethods.deserialize
         (sJsonStructure ,'SBCCommInboundUpdateProcess');
         
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF ( sJsonStructure ) ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/upsertBeneficiary?';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            UpdateSBCCommRESTService.updateSBCCommunications();
        
            System.Assert ( RestContext.response.statusCode == 200) ; 
        Test.StopTest() ;
    }
    
    public testMethod static void updateSBCCommunications4Test(){
         
         List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
        List<SBC_Communications__c>  lstSBCComm = new List<SBC_Communications__c> () ;  
        SBC_Communications__c oSBC1 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[0].ID , SBC_Global_Id__c =  String.valueOf(math.random()*100000)+'ZYX' ,
                                                                  Batch_ID__c = String.valueOf(math.random()*100000)+'SCF' , Sequence_ID__c = String.valueOf(math.random()*100000)+'OUY') ;   
        SBC_Communications__c oSBC2 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID , Correspondence_Type__c = SYSTEM.LABEL.Encourager_Communication ,
                                                                   SBC_Global_Id__c =  String.valueOf(math.random()*100000)+'ZYX' , Batch_ID__c = String.valueOf(math.random()*100000)+'SCF',  
                                                                                       Sequence_ID__c = String.valueOf(math.random()*100000)+'OUY') ;
        lstSBCComm.add(oSBC1) ; 
        lstSBCComm.add(oSBC2) ; 
            insert lstSBCComm ; 

         
        SObjectType oSBCSchema= Schema.getGlobalDescribe().get
        ('SBC_Communications__c');
        Map<String,Schema.SObjectField> mapFieldSchemaSBC = 
        oSBCSchema.getDescribe().fields.getMap();
        
        //Forming the query all fields for communication Preference object.
        String sQuerySBCCom ='select ';
        for(String sFieldVar: mapFieldSchemaSBC.keySet())
        sQuerySBCCom +=sFieldVar+',';
        sQuerySBCCom =sQuerySBCCom .subStringbeforeLast(',');
        
        sQuerySBCCom += ' from SBC_Communications__c where ID IN: lstSBCComm ' ;
        
        List<SBC_Communications__c> lstSBCCommRecs=new List<SBC_Communications__c>();
        lstSBCCommRecs=(List<SBC_Communications__c> )Database.Query(sQuerySBCCom);
         
         Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
         mapOutput.put('SBCCommInboundUpdateProcess',lstSBCCommRecs);
            //Getting Final JSON String
        String sJsonStructure=
        JSONHandlerMethods.serialize(mapOutput,
        'SBCCommInboundUpdateProcess'); 
         sJsonStructure =sJsonStructure.replace('"null"', 'null');
         
         system.debug ( 'sJsonStructure?>?>' + sJsonStructure ) ; 
         
         List<SBC_Communications__c> lstSBCCommunicationRetrieved = new List<SBC_Communications__c>();
         List<SBC_Communications__c> lstSBCCommunicationRetrievedFinal = new List<SBC_Communications__c>();
         lstSBCCommunicationRetrieved = 
         (List<SBC_Communications__c>)JSONHandlerMethods.deserialize
         (sJsonStructure ,'SBCCommInboundUpdateProcess');
         
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF ( sJsonStructure ) ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/upsertBeneficiary?';
            req.httpMethod = 'PUT';
            req.addParameter('GlobalPartnerSBCId', lstSBCComm [0].ID);  
            RestContext.request = req;
            RestContext.response = res;
            UpdateSBCCommRESTService.updateSBCPhysicalDateReceived();
        
            System.Assert ( RestContext.response.statusCode == 404) ; 
            
            lstSBCComm [0].SBC_Global_Id__c = 'ZXE1234567' ; 
                update lstSBCComm ; 
            
            req.addParameter('GlobalPartnerSBCId', 'ZXE1234567');  
            UpdateSBCCommRESTService.updateSBCPhysicalDateReceived();
            
            req.addParameter('GlobalPartnerSBCId', NULL );  
            UpdateSBCCommRESTService.updateSBCPhysicalDateReceived();
            
        Test.StopTest() ;
    }
}