/*****************************************************************************************
    Name             : SBCCommunication_Test
    Description      : This test class is used for covering all the test scneario 
                       related to the SBC Validations                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 30/10/2014            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class SBCCommunication_Test
{
    /**
    * Method name  : testValidationScenarios
    * Description  : Use this method for testing SBC related classes
    * Return Type  : void
    * Parameter    : void
    **/
    
    private static testMethod void testValidationScenarios()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
        Id supporterId =Utility.getRecordtype('Supporter','Account');
        Id beneficiaryId =Utility.getRecordtype('Beneficiary','Account');
        List<Account> lstAccounts = new List<Account>();
        
        Account oActiveSupAccountVar = new Account(RecordTypeId=supporterId, Type='Business',Status__c='Active',Name='TestActiveSupporter',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1');
        insert oActiveSupAccountVar;
        System.AssertEquals('Business',oActiveSupAccountVar.Type);
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        System.AssertEquals('Active',oActiveBenAccountVar.Status__c);
        Account oInactiveSupAccountVar = new Account(RecordTypeId=supporterId, Type='Business',Status__c='Inactive',Name='TestInactiveSupporter',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='2');
        insert oInactiveSupAccountVar;
        Account oInactiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Name='TestInactiveBeneficiary', Status__c='Inactive');
        insert oInactiveBenAccountVar;
       
        SBC_Communications__c oSBCExFirstVar = new SBC_Communications__c(Beneficiary__c = oActiveBenAccountVar.id);
        insert oSBCExFirstVar;
        SBC_Communications__c oSBCExSecondVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id);
        insert oSBCExSecondVar;
        
        SBC_Communications__c oSBCFirstVar = new SBC_Communications__c(Supporter__c = oInactiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id);
        insert oSBCFirstVar;
        SBC_Communications__c oSBCSecondVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oInactiveBenAccountVar.id);
        insert oSBCSecondVar;
        Utility.bToCheckSupporterStatus = true;
         oSBCSecondVar.Beneficiary__c = oActiveBenAccountVar.id;
        oSBCSecondVar.Status__c = 'Exception';
        oSBCSecondVar.Exception_Reason__c = '';
        update oSBCSecondVar;
        Utility.bToCheckSupporterStatus = true;
        oSBCSecondVar.Status__c = 'Received';
        update oSBCSecondVar;
        oSBCSecondVar.Final_Letter__c = true;
        update oSBCSecondVar;
        SBC_Communications__c oSBCThirdVar1 = new SBC_Communications__c(Status__c ='Exception', Exception_Reason__c = 'Past Communication Issues', Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id);
        
        insert oSBCThirdVar1;
        
        SBC_Communications__c oSBCThirdVar2 = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id);
        
        insert oSBCThirdVar2;
        
        SBC_Communications__c oSBCThirdVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oInactiveBenAccountVar.id);
        insert oSBCThirdVar;
        
        
        
        SBC_Communications__c oSBCFourthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oInactiveBenAccountVar.id);
        insert oSBCFourthVar;
        
        
       
        Test.StartTest() ; 
        oActiveSupAccountVar.Inappropriate_Correspondence__c = 6;
        update oActiveSupAccountVar;
        update oSBCFourthVar;
        SBC_Communications__c oSBCFifthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id);
        insert oSBCFifthVar;      
        oActiveSupAccountVar.Inappropriate_Correspondence__c = 1;
        update oActiveSupAccountVar;
        SBC_Communications__c oSBCSixthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id);
         
        oSBCSixthVar.Correspondence_Type__c = 'Encourager Communication';
        oSBCSixthVar.SBC_Global_Id__c = 'Sumeet';        
        insert oSBCSixthVar;
        oSBCSixthVar.Status__c = 'Complete Delivered';
        update oSBCSixthVar;
        Set<Id> setIds = new Set<Id>();
        setIds.add(oSBCSixthVar.id);
        SBCCommunicationTriggerHelper.sendSBCToXMPie(setIds);
        oSBCSixthVar.Status__c = 'Cancelled';
        oSBCSixthVar.Communication_Issue_Source__c = 'Test';
        update oSBCSixthVar;
        Set<Id> setSupporters = new Set<Id>();
        setSupporters.add(oActiveSupAccountVar.id);
        SBCCommunicationTriggerHelper.updateInappropriateCorrospondence(setSupporters);
        String sSBCName = [ Select Name from SBC_Communications__c where ID =: oSBCSixthVar.id ].Name  ;
        
        Test.StopTest() ; 
        String sBody = '{     "Responses": [         {             "CompassionSBCId": "C0000000424",             "GlobalPartnerSBCId": "'+sSBCName+'", "Id": "a1Sq00000003MXr"}     ] }';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody(sBody);
        //res.setStatus('OK');
        SBCCommunicationTriggerHelper.populateSBCCommunicationValues(res);
        Set<ID> sIDs = new Set<ID> ( ) ;
        sIDs.add( oSBCSixthVar.id ) ;   
        SBCCommunicationTriggerHelper.updateInappropriateCorrospondence ( sIDs ) ; 
       // String sCollectIDS = '(\''+oSBCSixthVar.id+'\')';
     //   SBCCommunicationTriggerHelper.callFromErrorLog ( res , String.ValueOF( sIDs )  ) ; 
    }
    
    /**
    * Method name  : testValidationScenarios
    * Description  : Use this method for testing SBC related classes
    * Return Type  : void
    * Parameter    : void
    **/
    
    private static testMethod void testValidationScenarios2()
    {
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
        Id supporterId =Utility.getRecordtype('Supporter','Account');
        Id beneficiaryId =Utility.getRecordtype('Beneficiary','Account');
        List<Account> lstAccounts = new List<Account>();
        
        Test.StartTest() ; 
        Account oActiveSupAccountVar = new Account(RecordTypeId=supporterId, Type='Business',Legacy_Supporter_Id__c = 'Test-987',Status__c='Active',Name='TestActiveSupporter',Business_Email__c='testdata1@testdata.com');
        insert oActiveSupAccountVar;
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        SBC_Communications__c oSBCSixthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id);
        insert oSBCSixthVar;
    
        /*
        oSBCSixthVar.status__c = 'Exception' ; 
        oSBCSixthVar.Exception_Reason__c = 'Past Communication Issues' ;
        update oSBCSixthVar ;
        
        
        oActiveSupAccountVar.Inappropriate_Correspondence__c  =  Integer.valueOf(System.Label.InappropriateCorrespondenceLimit) ;
        update oActiveSupAccountVar ;
        
        oSBCSixthVar.Exception_Reason__c = '' ;
        update oSBCSixthVar ;
        
        oActiveSupAccountVar.Inappropriate_Correspondence__c  =  0 ;
        update oActiveSupAccountVar ;
        
        oSBCSixthVar.Exception_Reason__c = '' ;
        update oSBCSixthVar ;
        */ 
        Test.StopTest() ; 
        
    }
    
    private static testMethod void testValidationScenarios3()
    {
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment());
        Id supporterId =Utility.getRecordtype('Supporter','Account');
        Id beneficiaryId =Utility.getRecordtype('Beneficiary','Account');
        List<Account> lstAccounts = new List<Account>();
        
        Id beneficaryToSupporterId = 
        Utility.getRecordType(System.Label.B2S, System.Label.SBCCommunicationObject);
         Id SupporterTobeneficaryId = 
         Utility.getRecordType(System.Label.S2B, System.Label.SBCCommunicationObject);
        Account oActiveSupAccountVar = new Account(RecordTypeId=supporterId, Type='Business',Legacy_Supporter_Id__c = 'Test-987',Status__c='Active' ,
                                                    Name='TestActiveSupporter',Business_Email__c='testdata1@testdata.com');
        insert oActiveSupAccountVar;
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        Test.StartTest() ; 
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        system.Assert ( oSBCNinthVar != NULL  ) ; 
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        Test.StopTest() ; 
        
    }
}