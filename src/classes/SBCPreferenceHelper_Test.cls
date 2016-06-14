@isTest(seeAllData=true)
public class SBCPreferenceHelper_Test{

private static testMethod void testValidationScenarios()
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
                                                   Business_Email__c = 'test@test.com', Name='TestActiveSupporter');
        insert oActiveSupAccountVar;
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
        Test.StartTest() ; 
      
        oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Personal Email; Work Email' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Work Email' ; 
        update oActiveSupAccountVar ; 
        
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Personal Email;' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Personal Email;' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = System.Label.Physical ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Business_Email__c = '' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ;
        
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Business_Email__c = '' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = '' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ;
        
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        
        oActiveSupAccountVar.Business_Email__c = '' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = '' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ;
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = System.Label.Physical ; 
        oActiveSupAccountVar.Do_Not_Mail__c = false ;
        oActiveSupAccountVar.Do_Not_Email__c = true ; 
        update oActiveSupAccountVar ; 
        Set<ID> setSBCID = new Set<ID> () ; 
        setSBCID.add ( oSBCBVarOne.ID ) ;
        GenerateJSONForSBCCommunicationToCI.generateJSONForCI ( setSBCID, true ) ; 
        GenerateJSONForSBCCommunicationToCI.generateJSONForCI ( setSBCID, false ) ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        Test.StopTest() ; 
         oActiveSupAccountVar.Do_Not_Mail__c = true ; 
        oActiveSupAccountVar.Business_Email__c = 'test@test.com' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Business' ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Personal Email; Work Email' ; 
        update oActiveSupAccountVar ; 
        
        GenerateJSONForSBCCommunicationToCI.generateJSONForCI ( setSBCID, true ) ; 
        GenerateJSONForSBCCommunicationToCI.generateJSONForCI ( setSBCID, false ) ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Work Email' ; 
        update oActiveSupAccountVar ; 
        
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Personal Email;' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Undeliverable_Invalid__c = 'Business Email; Personal Email;' ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = System.Label.Physical ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Business_Email__c = '' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Personal' ;
        
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        oActiveSupAccountVar.Business_Email__c = '' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = '' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ;
        
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        
        oActiveSupAccountVar.Business_Email__c = '' ; 
        oActiveSupAccountVar.Work_Email__c = 'test@test.com' ;
        oActiveSupAccountVar.Personal_Email__c = '' ;
        oActiveSupAccountVar.Preferred_Email__c = 'Work' ;
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c = System.Label.Physical ; 
        oActiveSupAccountVar.Do_Not_Mail__c = false ;
        oActiveSupAccountVar.Do_Not_Email__c = true ; 
        update oActiveSupAccountVar ; 
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
         
        update oActiveSupAccountVar ;
        GenerateJSONForSBCCommunicationToCI.generateJSONForCI ( setSBCID, true ) ; 
        GenerateJSONForSBCCommunicationToCI.generateJSONForCI ( setSBCID, false ) ;
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ; 
          oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
        // oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ; 
          oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ; 
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Physical;
         
        update oActiveSupAccountVar ;
          
        
    }
   private static testMethod void testValidationScenarios2(){
   
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
                                                   Business_Email__c = 'test@test.com', Name='TestActiveSupporter');
        insert oActiveSupAccountVar;
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
   
   
   
   SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
         oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;  
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Physical;
         oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;  
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;  
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
          oActiveSupAccountVar.BillingCity = '' ; 
        oActiveSupAccountVar.BillingState = '' ; 
        oActiveSupAccountVar.BillingCountry = '' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Bill_to2;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
           oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= '' ; 
        oActiveSupAccountVar.ShippingState = '' ; 
        oActiveSupAccountVar.ShippingCountry = '' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ;  
             oActiveSupAccountVar.Preferred_Address__c=System.Label.Physical;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Physical;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ; 
          oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = '' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = '' ; 
        oActiveSupAccountVar.Mailing_Country__c = '' ;  
             oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ; 
          oActiveSupAccountVar.Do_Not_contact__c=true;
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
          oActiveSupAccountVar.Do_Not_Mail__c=true;
          oActiveSupAccountVar.Do_Not_contact__c=false;
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        update oActiveSupAccountVar ;
          SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
         oActiveSupAccountVar.Do_Not_Mail__c=true;
          oActiveSupAccountVar.Do_Not_contact__c=false;
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email;
           update oActiveSupAccountVar ;
         SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
         oActiveSupAccountVar.Do_Not_Mail__c=true;
          oActiveSupAccountVar.Do_Not_contact__c=false;
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Personal_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Personal';
        oActiveSupAccountVar.Undeliverable_Invalid__c='abc';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email;
           update oActiveSupAccountVar ;
         SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
         oActiveSupAccountVar.Do_Not_Mail__c=true;
          oActiveSupAccountVar.Do_Not_contact__c=false;
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Work_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Work';
        oActiveSupAccountVar.Undeliverable_Invalid__c='abc';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email;
           update oActiveSupAccountVar ;
         SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
         oActiveSupAccountVar.Do_Not_Mail__c=true;
          oActiveSupAccountVar.Do_Not_contact__c=false;
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Business_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Business';
        oActiveSupAccountVar.Undeliverable_Invalid__c='abc';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email;
           update oActiveSupAccountVar ;
        
        SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
       
   Map<Id,String> mapPref=new  Map<Id,String>();
   mapPref.put(oActiveSupAccountVar.Id,System.Label.MAIL2);
   Map<SBC_Communications__c,String> testMap=(new SBCPreferenceHelper()).SBCPrefBasedOnSupporter(oSBCList ,mapPref);
   mapPref.put(oActiveSupAccountVar.Id,System.Label.EMAIL2);
   Map<SBC_Communications__c,String> testMap2=(new SBCPreferenceHelper()).SBCPrefBasedOnSupporter(oSBCList ,mapPref);
    mapPref.put(oActiveSupAccountVar.Id,System.Label.BOTH2);
   Map<SBC_Communications__c,String> testMap3=(new SBCPreferenceHelper()).SBCPrefBasedOnSupporter(oSBCList ,mapPref);
     mapPref.put(oActiveSupAccountVar.Id,System.Label.BOTH2+' test');
   Map<SBC_Communications__c,String> testMap4=(new SBCPreferenceHelper()).SBCPrefBasedOnSupporter(oSBCList ,mapPref);
   }
  private static testMethod void testValidationScenarios3(){
  
  
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
                                                   Business_Email__c = 'test@test.com', Name='TestActiveSupporter');
        insert oActiveSupAccountVar;
        
        Set<Id> setSupporterId = new Set<Id> () ; 
        setSupporterId.add ( oActiveSupAccountVar.Id ) ; 
        
        Account oActiveBenAccountVar = new Account(RecordTypeId=beneficiaryId,Compass_Child_Key__c='Test-123',Name='TestActiveBeneficiary', Status__c='Active');
        
        
        oActiveSupAccountVar.BillingCity = 'test' ; 
        oActiveSupAccountVar.BillingState = 'test' ; 
        oActiveSupAccountVar.BillingCountry = 'test' ; 
        
        oActiveSupAccountVar.ShippingCity= 'test' ; 
        oActiveSupAccountVar.ShippingState = 'test' ; 
        oActiveSupAccountVar.ShippingCountry = 'test' ; 
        
        oActiveSupAccountVar.Mailing_City__c = 'test' ; 
        oActiveSupAccountVar.Mailing_State_Province__c = 'test' ; 
        oActiveSupAccountVar.Mailing_Country__c = 'test' ; 
        
        insert oActiveBenAccountVar;
        
        List< SBC_Communications__c > oSBCList = new List< SBC_Communications__c > () ;  
        
        SBC_Communications__c oSBCBVarOne = new SBC_Communications__c(Supporter__c = oActiveSupAccountVar.id, Beneficiary__c = oActiveBenAccountVar.id , RecordtypeID = beneficaryToSupporterId );
        insert oSBCBVarOne ;
        oSBCList.add ( oSBCBVarOne ) ;
   
   oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
  
   SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
         oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        update oActiveSupAccountVar ;
  
  
  
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
   oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Print;
  
   SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
         oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        update oActiveSupAccountVar ;
  
  
  
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
  
   oActiveSupAccountVar.Do_Not_EMail__c=true;
    oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Print+' '+ System.Label.Email;
   SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
           oActiveSupAccountVar.Preferred_Address__c=System.Label.Bill_to2;
         oActiveSupAccountVar.Undeliverable_Invalid__c=system.Label.Email+'  '+System.Label.Print;
        update oActiveSupAccountVar ;
  
  
  
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
  
       oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Personal_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Personal';
        oActiveSupAccountVar.Undeliverable_Invalid__c='abc';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email;
           update oActiveSupAccountVar ;
         SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
        
        
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Work_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Work';
        oActiveSupAccountVar.Undeliverable_Invalid__c='abc';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
           update oActiveSupAccountVar ;
         SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
         
            oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Business_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Business';
        oActiveSupAccountVar.Undeliverable_Invalid__c='abc';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
           update oActiveSupAccountVar ;
  
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
   oActiveSupAccountVar.Undeliverable_Invalid__c=null;
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
           update oActiveSupAccountVar ;
  
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
   oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
       //  oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Business_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Business';
        oActiveSupAccountVar.Undeliverable_Invalid__c='Business';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
           update oActiveSupAccountVar ;
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;
  //oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
         oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Work_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Work';
        oActiveSupAccountVar.Undeliverable_Invalid__c='Work';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
           update oActiveSupAccountVar ;
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
   oActiveSupAccountVar.Preferred_Address__c=System.Label.Mailing;
       //  oActiveSupAccountVar.Undeliverable_Invalid__c=System.Label.Mailing;
        oActiveSupAccountVar.Personal_Email__c='test@tes.com';
        oActiveSupAccountVar.Preferred_Email__c='Personal';
        oActiveSupAccountVar.Undeliverable_Invalid__c='Personal';
        
        oActiveSupAccountVar.Correspondence_Delivery_Preference__c=System.Label.Email+'  '+System.Label.Print;
           update oActiveSupAccountVar ;
  SBCCommunicationTriggerHandler.setFinalDeliveryPrefernce( oSBCList ) ;   
  }
}