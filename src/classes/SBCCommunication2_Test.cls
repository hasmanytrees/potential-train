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
public class SBCCommunication2_Test
{
    
    private static testMethod void testValidationScenarios1()
    {
        
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment2());
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
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        Test.StartTest() ; 
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        oActiveSupAccountVar.Preferred_Address__c = 'Work' ; 
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = 'Physical Original Document' ;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;  
        
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        
        SBC_Communications__c oSBCBVarTwo = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarTwo ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        system.debug ( '???>>>>' + oSBCBVarTwo  ) ; 
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        
        SBC_Communications__c oSBCBVarThree = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarThree ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        system.debug ( 'TESToSBCBVarThree ' + oSBCBVarThree ) ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        
        SBC_Communications__c oSBCBVarThreea = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarThreea ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ; 
        update oActiveSupAccountVar ; 
        
        SBC_Communications__c oSBCBVarfour = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarfour ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        SBC_Communications__c oSBCBVarFive = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarFive ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        
        SBC_Communications__c oSBCBVarSix = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarSix ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        
        SBC_Communications__c oSBCBVarSeven = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarSeven ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        update oActiveSupAccountVar ;
        
        SBC_Communications__c oSBCBVarEight = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarEight ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Do_Not_Contact__c = true ; 
        update oActiveSupAccountVar ; 
        
        SBC_Communications__c oSBCBVarNine = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarNine ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        SBCPreferenceHelper oSBCHelp = new SBCPreferenceHelper () ;
        Map<Id,String> mapAccountPref = new Map<Id,String> () ; 
        oSBCHelp.SBCPrefBasedOnSupporter ( oSBCList , mapAccountPref ) ;
         
        mapAccountPref.put ( oActiveSupAccountVar.ID , System.Label.MAIL2) ;
        oSBCHelp.SBCPrefBasedOnSupporter ( oSBCList , mapAccountPref ) ; 
        
        mapAccountPref.put ( oActiveSupAccountVar.ID , System.Label.EMAIL2) ;
        oSBCHelp.SBCPrefBasedOnSupporter ( oSBCList , mapAccountPref ) ;
        
        mapAccountPref.put ( oActiveSupAccountVar.ID , System.Label.BOTH2) ;
        oSBCHelp.SBCPrefBasedOnSupporter ( oSBCList , mapAccountPref ) ;
        
        Test.StopTest() ; 
        
    }
   
    private static testMethod void testValidationScenarios2()
    {
        
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment2());
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
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
        
        Test.StartTest() ; 
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        oActiveSupAccountVar.Preferred_Address__c = 'Work' ; 
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = 'Printed Digital Document' ;
        
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        update oActiveSupAccountVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Contact__c = true ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        Test.StopTest() ; 
        
    }
    
    private static testMethod void testValidationScenarios3()
    {
        
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment2());
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
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
        
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        oActiveSupAccountVar.Preferred_Address__c = 'Work' ; 
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = 'Email of Letter Image and Physical Original Document' ;
        Test.StartTest() ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        update oActiveSupAccountVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Contact__c = true ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        Test.StopTest() ; 
        
    }
    
    private static testMethod void testValidationScenarios4()
    {
        
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment2());
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
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
        Test.StartTest() ; 
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        oActiveSupAccountVar.Preferred_Address__c = 'Work' ; 
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = 'Email of Letter Image and Printed Digital Document' ;
        
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        update oActiveSupAccountVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Contact__c = true ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        Test.StopTest() ; 
        
    }
    private static testMethod void testValidationScenarios5()
    {
        
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment2());
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
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
        Test.StartTest() ; 
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        oActiveSupAccountVar.Preferred_Address__c = 'Work' ; 
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = 'Email of Letter Image' ;
        
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        update oActiveSupAccountVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Contact__c = true ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        Test.StopTest() ; 
        
    }
    
    private static testMethod void testValidationScenarios6()
    {
        
        MockHttpResponseGenerator.sBeneficiaryId = 'Test-123';
        MockHttpResponseGenerator.sSupporterId = 'Test-987';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator.MockCommitment2());
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
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
        Test.StartTest() ; 
      
        SBC_Communications__c oSBCNinthVar = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  
        update oSBCNinthVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        System.debug ('DEBUG >????' + [Select Gift_Not_Scanned_Not_Eligible__c ,Status__c , Recordtype.Name from SBC_Communications__c where ID =:oSBCNinthVar.ID ] ) ; 
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        oActiveSupAccountVar.Preferred_Address__c = 'Work' ; 
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = 'My Account Only' ;
        
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = '   Bill to Address' ; 
        update oActiveSupAccountVar;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
         
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ; 
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Mailing Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Physical Address' ; 
        update oActiveSupAccountVar; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        update oActiveSupAccountVar ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        
        oActiveSupAccountVar.Do_Not_Contact__c = true ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = false;  update oSBCNinthVar  ;oSBCNinthVar.Gift_Not_Scanned_Not_Eligible__c  = true;  update oSBCNinthVar  ;
        Test.StopTest() ; 
        
    }
    
    
    
}