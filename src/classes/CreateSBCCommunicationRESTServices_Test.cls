@isTest(seeAllData=true)
public class CreateSBCCommunicationRESTServices_Test{


      public testMethod static void testCreateSBCComm()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
      Account accountVar1=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Legacy_Supporter_Id__c='23',Global_Id__c='06448474',Preferred_Email__c='Business',Business_Email__c='test@test.com',Mailing_City__c='test',Mailing_State_Province__c='test',Mailing_Country__c='test',Mailing_Zip_Postal_Code__c='66666',Preferred_Address__c='Mailing',Compass_Child_Key__c='77777777',Correspondence_Delivery_Preference__c='Email of Letter Image and Printed Digital Document');
       lstAccount.add(accountVar1);
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='AAAAAAAA');
        lstAccount.add(accountVar2);
        insert lstAccount;
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{ "SBCCommunicationDetails": [ { "Type": [], "TranslationLanguage": "English", "TranslatedText": "test data translated", "TranslatedBy": null, "TransactionId": null, "Template": "BO-A-1S21-1", "Supporter_PreferredName": "Test McDoland", "Supporter_MandatoryReviewRequired": null, "Supporter_GlobalId": "06448474", "Supporter_Gender": null, "Supporter_CompassConstituentId": "77777777", "Supporter_CommunicationDeliveryPreference": "Digital", "Status": "Complete Delivered", "SourceSystem": "ISL, "ReworkComments": null, "RelationshipType": "Sponsor", "ReasonForRework": "none", "PrintType": null, "OriginalText": "test data original", "OriginalLetterURL": null, "OriginalLanguage": "French", "NumberOfPages": null, "ItemNotScannedNotEligible": false, "ItemNotScannedEligible": false, "IsOriginalLetterArchived": false, "IsMarkedForRework": false, "IsFinalLetterArchived": false, "IsFinalLetter": false, "Internal_Supporter_PersonalEmail": "subhojitc3@gmail.com", "Internal_Supporter_MailingStreet1": "sfsdf", "Internal_Supporter_MailingPostalCode": "400082", "Internal_Supporter_MailingCountryDivision": "Maharashtra", "Internal_Supporter_MailingCountry": "use", "Internal_Supporter_MailingCity": "MUMBAI", "Internal_Supporter_InCareOfMailingAddress": "fd", "Internal_Supporter_CommunicationMethod": "Both", "ICP_Id": null, "GlobalPartnerSBCId": "SBC-000001079", "GlobalPartner_OptInForLanguageTranslation": null, "GlobalPartner_Id": "US", "FontSize": 0, "Font": null, "FinalLetterURL": null, "EnglishTranslatedText": null, "Direction": "Beneficiary To Supporter", "CompassionSBCId": "C0000000446", "Beneficiary_Name": "Annice Volk", "Beneficiary_LocalId": "ET2020104", "Beneficiary_GlobalId": "AAAAAAAA", "Beneficiary_Gender": "Male", "Beneficiary_CompassId": null, "Beneficiary_Age": "0" } ] }';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }

 public testMethod static void testCreateSBCComm2()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
        Account accountVar3=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474',Preferred_Email__c='Personal',Mailing_City__c='test',Mailing_State_Province__c='test',Mailing_Country__c='test',Mailing_Zip_Postal_Code__c='66666',Preferred_Address__c='Bill To',Work_Email__c='test@test.com',BillingStreet='test',BillingCity='test',BillingState='test',BillingCountry='test',BillingPostalCode='66666',Compass_Child_Key__c='77777777',Correspondence_Delivery_Preference__c='Physical Original Document');
       lstAccount.add(accountVar3);
      
        insert lstAccount;
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{ "SBCCommunicationDetails": [ { "Type": [], "TranslationLanguage": "English", "TranslatedText": "test data translated", "TranslatedBy": null, "TransactionId": null, "Template": "BO-A-1S21-1", "Supporter_PreferredName": "Test McDoland", "Supporter_MandatoryReviewRequired": null, "Supporter_GlobalId": "06448474", "Supporter_Gender": null, "Supporter_CompassConstituentId": "77777777", "Supporter_CommunicationDeliveryPreference": "Print", "Status": "Complete Delivered", "SourceSystem": "Compassion USA", "ReworkComments": null, "RelationshipType": "Sponsor", "ReasonForRework": "none", "PrintType": null, "OriginalText": "test data original", "OriginalLetterURL": null, "OriginalLanguage": "French", "NumberOfPages": null, "ItemNotScannedNotEligible": false, "ItemNotScannedEligible": false, "IsOriginalLetterArchived": false, "IsMarkedForRework": false, "IsFinalLetterArchived": false, "IsFinalLetter": false, "Internal_Supporter_PersonalEmail": "subhojitc3@gmail.com", "Internal_Supporter_MailingStreet1": "sfsdf", "Internal_Supporter_MailingPostalCode": "400082", "Internal_Supporter_MailingCountryDivision": "Maharashtra", "Internal_Supporter_MailingCountry": "use", "Internal_Supporter_MailingCity": "MUMBAI", "Internal_Supporter_InCareOfMailingAddress": "fd", "Internal_Supporter_CommunicationMethod": "Both", "ICP_Id": null, "GlobalPartnerSBCId": "SBC-000001079", "GlobalPartner_OptInForLanguageTranslation": null, "GlobalPartner_Id": "US", "FontSize": 0, "Font": null, "FinalLetterURL": null, "EnglishTranslatedText": null, "Direction": "Beneficiary To Supporter", "CompassionSBCId": "C0000000446", "Beneficiary_Name": "Annice Volk", "Beneficiary_LocalId": "ET2020104", "Beneficiary_GlobalId": "20201", "Beneficiary_Gender": "Male", "Beneficiary_CompassId": null, "Beneficiary_Age": "0" } ] }';
    
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }

 public testMethod static void testCreateSBCComm3()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
           Account accountVar3=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474',Preferred_Email__c='Work',Mailing_City__c='test',Mailing_State_Province__c='test',Mailing_Country__c='test',Mailing_Zip_Postal_Code__c='66666',Preferred_Address__c='Physical',Work_Email__c='test@test.com',BillingStreet='test',BillingCity='test',BillingState='test',BillingCountry='test',BillingPostalCode='66666',Compass_Child_Key__c='77777777',Correspondence_Delivery_Preference__c='Email of Letter Image');
       lstAccount.add(accountVar3);
      
        insert lstAccount;
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{ "SBCCommunicationDetails": [ { "Type": [], "TranslationLanguage": "English", "TranslatedText": "test data translated", "TranslatedBy": null, "TransactionId": null, "Template": "BO-A-1S21-1", "Supporter_PreferredName": "Test McDoland", "Supporter_MandatoryReviewRequired": null, "Supporter_GlobalId": "06448474", "Supporter_Gender": null, "Supporter_CompassConstituentId": "77777777", "Supporter_CommunicationDeliveryPreference": "Digital", "Status": "Complete Delivered", "SourceSystem": "Compassion USA", "ReworkComments": null, "RelationshipType": "Sponsor", "ReasonForRework": "none", "PrintType": null, "OriginalText": "test data original", "OriginalLetterURL": null, "OriginalLanguage": "French", "NumberOfPages": null, "ItemNotScannedNotEligible": false, "ItemNotScannedEligible": false, "IsOriginalLetterArchived": false, "IsMarkedForRework": false, "IsFinalLetterArchived": false, "IsFinalLetter": false, "Internal_Supporter_PersonalEmail": "subhojitc3@gmail.com", "Internal_Supporter_MailingStreet1": "sfsdf", "Internal_Supporter_MailingPostalCode": "400082", "Internal_Supporter_MailingCountryDivision": "Maharashtra", "Internal_Supporter_MailingCountry": "use", "Internal_Supporter_MailingCity": "MUMBAI", "Internal_Supporter_InCareOfMailingAddress": "fd", "Internal_Supporter_CommunicationMethod": "Both", "ICP_Id": null, "GlobalPartnerSBCId": "SBC-000001079", "GlobalPartner_OptInForLanguageTranslation": null, "GlobalPartner_Id": "US", "FontSize": 0, "Font": null, "FinalLetterURL": null, "EnglishTranslatedText": null, "Direction": "Beneficiary To Supporter", "CompassionSBCId": "C0000000446", "Beneficiary_Name": "Annice Volk", "Beneficiary_LocalId": "ET2020104", "Beneficiary_GlobalId": null, "Beneficiary_Gender": "Male", "Beneficiary_CompassId": null, "Beneficiary_Age": "0" } ] }';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }


 public testMethod static void testCreateSBCComm4()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
       
       Account accountVar4=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474',Preferred_Email__c='Work',Mailing_City__c='test',Mailing_State_Province__c='test',Mailing_Country__c='test',Mailing_Zip_Postal_Code__c='66666',Preferred_Address__c='Work');
       lstAccount.add(accountVar4);
       
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{ "SBCCommunicationDetails": [ { "Type": [], "TranslationLanguage": "English", "TranslatedText": "test data translated", "TranslatedBy": null, "TransactionId": null, "Template": "BO-A-1S21-1", "Supporter_PreferredName": "Test McDoland", "Supporter_MandatoryReviewRequired": null, "Supporter_GlobalId": "06448474", "Supporter_Gender": null, "Supporter_CompassConstituentId": "77777777", "Supporter_CommunicationDeliveryPreference": "Digital", "Status": "Complete Delivered", "SourceSystem": "Compassion USA", "ReworkComments": null, "RelationshipType": "Sponsor", "ReasonForRework": "none", "PrintType": null, "OriginalText": "test data original", "OriginalLetterURL": null, "OriginalLanguage": "French", "NumberOfPages": null, "ItemNotScannedNotEligible": false, "ItemNotScannedEligible": false, "IsOriginalLetterArchived": false, "IsMarkedForRework": false, "IsFinalLetterArchived": false, "IsFinalLetter": false, "Internal_Supporter_PersonalEmail": "subhojitc3@gmail.com", "Internal_Supporter_MailingStreet1": "sfsdf", "Internal_Supporter_MailingPostalCode": "400082", "Internal_Supporter_MailingCountryDivision": "Maharashtra", "Internal_Supporter_MailingCountry": "use", "Internal_Supporter_MailingCity": "MUMBAI", "Internal_Supporter_InCareOfMailingAddress": "fd", "Internal_Supporter_CommunicationMethod": "Both", "ICP_Id": null, "GlobalPartnerSBCId": "SBC-000001079", "GlobalPartner_OptInForLanguageTranslation": null, "GlobalPartner_Id": "US", "FontSize": 0, "Font": null, "FinalLetterURL": null, "EnglishTranslatedText": null, "Direction": "Beneficiary To Supporter", "CompassionSBCId": "C0000000446", "Beneficiary_Name": "Annice Volk", "Beneficiary_LocalId": "ET2020104", "Beneficiary_GlobalId": null, "Beneficiary_Gender": "Male", "Beneficiary_CompassId": null, "Beneficiary_Age": "0" } ] }';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }

public testMethod static void testCreateSBCComm5()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
      
        Account accountVar5=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474');
       lstAccount.add(accountVar5);
         Account accountVar6=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474');
     
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
  
    String sInputJSON='{ "SBCCommunicationDetails": [ { "Type": [], "TranslationLanguage": "English", "TranslatedText": "test data translated", "TranslatedBy": null, "TransactionId": null, "Template": "BO-A-1S21-1", "Supporter_PreferredName": "Test McDoland", "Supporter_MandatoryReviewRequired": null, "Supporter_GlobalId": "06448474", "Supporter_Gender": null, "Supporter_CompassConstituentId": "77777777", "Supporter_CommunicationDeliveryPreference": "Digital", "Status": "Complete Delivered", "SourceSystem": "Compassion USA", "ReworkComments": null, "RelationshipType": "Sponsor", "ReasonForRework": "none", "PrintType": null, "OriginalText": "test data original", "OriginalLetterURL": null, "OriginalLanguage": "French", "NumberOfPages": null, "ItemNotScannedNotEligible": false, "ItemNotScannedEligible": false, "IsOriginalLetterArchived": false, "IsMarkedForRework": false, "IsFinalLetterArchived": false, "IsFinalLetter": false, "Internal_Supporter_PersonalEmail": "subhojitc3@gmail.com", "Internal_Supporter_MailingStreet1": "sfsdf", "Internal_Supporter_MailingPostalCode": "400082", "Internal_Supporter_MailingCountryDivision": "Maharashtra", "Internal_Supporter_MailingCountry": "use", "Internal_Supporter_MailingCity": "MUMBAI", "Internal_Supporter_InCareOfMailingAddress": "fd", "Internal_Supporter_CommunicationMethod": "Both", "ICP_Id": null, "GlobalPartnerSBCId": "SBC-000001079", "GlobalPartner_OptInForLanguageTranslation": null, "GlobalPartner_Id": "US", "FontSize": 0, "Font": null, "FinalLetterURL": null, "EnglishTranslatedText": null, "Direction": "Beneficiary To Supporter", "CompassionSBCId": "C0000000446", "Beneficiary_Name": "Annice Volk", "Beneficiary_LocalId": "ET2020104", "Beneficiary_GlobalId": null, "Beneficiary_Gender": "Male", "Beneficiary_CompassId": null, "Beneficiary_Age": "0" } ] }';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }
public testMethod static void testCreateSBCComm6()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
      
      
         Account accountVar6=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474');
       lstAccount.add(accountVar6);  
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
   insert lstAccount;
    String sInputJSON='{ "SBCCommunicationDetails": [ { "Type": [], "TranslationLanguage": "English", "TranslatedText": "test data translated", "TranslatedBy": null, "TransactionId": null, "Template": "BO-A-1S21-1", "Supporter_PreferredName": "Test McDoland", "Supporter_MandatoryReviewRequired": null, "Supporter_GlobalId": "06448474", "Supporter_Gender": null, "Supporter_CompassConstituentId": "77777777", "Supporter_CommunicationDeliveryPreference": "Digital", "Status": "Complete Delivered", "SourceSystem": "ISL Mobile", "ReworkComments": null, "RelationshipType": "Sponsor", "ReasonForRework": "none", "PrintType": null, "OriginalText": "test data original", "OriginalLetterURL": null, "OriginalLanguage": "French", "NumberOfPages": null, "ItemNotScannedNotEligible": false, "ItemNotScannedEligible": false, "IsOriginalLetterArchived": false, "IsMarkedForRework": false, "IsFinalLetterArchived": false, "IsFinalLetter": false, "Internal_Supporter_PersonalEmail": "subhojitc3@gmail.com", "Internal_Supporter_MailingStreet1": "sfsdf", "Internal_Supporter_MailingPostalCode": "400082", "Internal_Supporter_MailingCountryDivision": "Maharashtra", "Internal_Supporter_MailingCountry": "use", "Internal_Supporter_MailingCity": "MUMBAI", "Internal_Supporter_InCareOfMailingAddress": "fd", "Internal_Supporter_CommunicationMethod": "Both", "ICP_Id": null, "GlobalPartnerSBCId": "SBC-000001079", "GlobalPartner_OptInForLanguageTranslation": null, "GlobalPartner_Id": "US", "FontSize": 0, "Font": null, "FinalLetterURL": null, "EnglishTranslatedText": null, "Direction": "Supporter To Beneficiary", "CompassionSBCId": "C0000000446", "Beneficiary_Name": "Annice Volk", "Beneficiary_LocalId": "ET2020104", "Beneficiary_GlobalId": null, "Beneficiary_Gender": "Male", "Beneficiary_CompassId": null, "Beneficiary_Age": "0" } ] }';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }

public testMethod static void testCreateSBCComm7()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
      
      
         Account accountVar6=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474');
       lstAccount.add(accountVar6);  
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
   insert lstAccount;
   SBC_Communications__C sbcVar=new SBC_Communications__C (RecordtypeId=Utility.getRecordType('Supporter To Beneficiary','SBC_Communications__c'));
   insert sbcVar;
    String sInputJSON='{ "GlobalPartnerSBCId" :"'+sbcVar.Id+'", "IsReadBySupporter": true }}';
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  }



public testMethod static void testCreateSBCComm8()
      {
      //List<Trigger_Methods_Activation__c> lstTriggerActivation = CustomSettingsData.createTestData_TriggerMethodsActivation();
      List<Account> lstAccount=new List<Account>();
     
       Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='C0000000446');
       lstAccount.add(accountVar2);  
      
      
         Account accountVar6=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='23',Global_Id__c='06448474');
       lstAccount.add(accountVar6);  
      //Contact conVar2 = new Contact(accountid = accountVar1.id, LastName = 'test Contact2',Contact_Legacy_Id__c='23');
      
   insert lstAccount;
   SBC_Communications__C sbcVar=new SBC_Communications__C (RecordtypeId=Utility.getRecordType('Supporter To Beneficiary','SBC_Communications__c'));
   insert sbcVar;
    String sInputJSON= '{  "GlobalPartnerSBCId" : "'+sbcVar.ID+'" , "IsReadBySupporter" : false }' ;
  
  RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();
    req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/createSBCCommunication';
    req.requestBody=Blob.valueOf(sInputJSON);  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;
      system.assertEquals('POST', req.httpMethod);
    CreateSBCCommunicationRESTServices.CreateSBCCommunicationRESTServices();
     
  } 
}