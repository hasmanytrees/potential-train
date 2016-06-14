/******************************************************************************
Name             : SBCCommunicationUpdateCIRESTServiceTest
Description      : Test class for SBCCommunicationUpdateCIRESTService
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D                23/09/2015          Created
******************************************************************************/


@isTest(seeAllData=true)
public class SBCCommunicationUpdateCIRESTServiceTest{

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
        List<Account> lstAccount=new List<Account>();
        Account accountVar1=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Supporter','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='TestSupporterdata1',Legacy_Supporter_Id__c='23',Global_Id__c='06448474',Preferred_Email__c='Business',Business_Email__c='test@test.com',Mailing_City__c='test',Mailing_State_Province__c='test',Mailing_Country__c='test',Mailing_Zip_Postal_Code__c='66666',Preferred_Address__c='Mailing',Compass_Child_Key__c='77777777',Correspondence_Delivery_Preference__c='Email of Letter Image and Printed Digital Document');
        lstAccount.add(accountVar1);
        Account accountVar2=new Account(Type='Business',RecordtypeId=Utility.getRecordType('Beneficiary','Account'),Status__c='Active',Home_Phone__c = '6578369284', Name='Testbendata1',Business_Email__c='testdata1@testdata.com',BEN_Local_Id__c='ET2020104',BEN_Id__c='AAAAAAAA');
        lstAccount.add(accountVar2);
        
        return  lstAccount;        
    }
    
    public testMethod static void getBeneficiaryListTest(){  
        
        List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
        List<SBC_Communications__c>  lstSBCComm = new List<SBC_Communications__c> () ;  
        SBC_Communications__c oSBC1 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID ) ;   
        SBC_Communications__c oSBC2 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID , Correspondence_Type__c = SYSTEM.LABEL.Encourager_Communication ) ;
   //     lstSBCComm.add(oSBC1) ; 
   //     lstSBCComm.add(oSBC2) ; 
            insert oSBC1 ; 
            
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/updateSBCCommunicationCI?';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            String sVal='{'+
'"CommunicationUpdates":['+
'{'+
'"TranslationLanguage":"Spanish",'+
'"TranslatedText":null,'+
'"TranslatedBy":null,'+
'"Template":"BO-A-1S21-1",'+
'"SupporterStationaryTemplate":null,'+
'"Supporter_PreferredName":"testing preffered name",'+
'"Supporter_MandatoryReviewRequired":null,'+
'"Supporter_GlobalId":"98765432",'+
'"Supporter_Gender":null,'+
'"Supporter_CompassConstituentId":"7411346658",'+
'"Supporter_CommunicationDeliveryPreference":"None",'+
'"SourceSystem":"Compassion USA",'+
'"SBCTypes":[ ],'+
'"SBCGlobalStatus":"Field Office translation queue",'+
'"ReworkComments":null,'+
'"RelationshipType":"Sponsor",'+
'"ReasonForRework":"none",'+
'"PrintType":null,'+
'"OriginalText":null,'+
'"OriginalLetterURL":"http://letters.com/letter3",'+
'"OriginalLanguage":"English",'+
'"NumberOfPages":null,'+
'"ItemNotScannedNotEligible":false,'+
'"ItemNotScannedEligible":true,'+
'"IsReadBySupporter":null,'+
'"IsOriginalLetterArchived":false,'+
'"IsMarkedForRework":false,'+
'"IsFinalLetterArchived":false,'+
'"IsFinalLetter":true,'+
'"Internal_Supporter_PersonalEmail":"jee@gmail.com",'+
'"Internal_Supporter_MailingStreet1":"test",'+
'"Internal_Supporter_MailingPostalCode":"560059",'+
'"Internal_Supporter_MailingCountryDivision":"Karnataka",'+
'"Internal_Supporter_MailingCountry":"usa",'+
'"Internal_Supporter_MailingCity":"Bangalore",'+
'"Internal_Supporter_InCareOfMailingAddress":"Jeevan D S/o R Devaraj, #12 ,JK Farm ,",'+
'"Internal_Supporter_CommunicationMethod":"Both",'+
'"Internal_Perceptive_TransactionId":"12345672",'+
'"ICP_Id":null,'+
'"GlobalPartnerSBCId":"'+oSBC1.ID+'",'+
'"GlobalPartner_OptInForLanguageTranslation":null,'+
'"GlobalPartner_GlobalPartnerId":"US",'+
'"FontSize":11,'+
'"Font":"Times New Roman",'+
'"FinalLetterURL":"http://letters.com/letter4",'+
'"EnglishTranslatedText":null,'+
'"Direction":"Beneficiary To Supporter",'+
'"CompassionSBCId":"C0019611013",'+
'"Beneficiary_Name":"Test Ben",'+
'"Beneficiary_LocalId":"EI1234567",'+
'"Beneficiary_GlobalId":"7250894",'+
'"Beneficiary_Gender":"male",'+
'"Beneficiary_CompassId":"123456",'+
'"Beneficiary_Age":"23"'+
'}'+
']'+
'}' ;

            req.requestBody = Blob.ValueOF( sVal)  ;
            lstAccountTestData[1].Gender__c = 'male' ; 
            insert oSBC2 ;

            SBCCommunicationUpdateCIRESTService.updateSBCCommunications();
         //   system.Assert ( RestContext.response.statusCode == 200 ) ; 
           
        Test.StopTest() ;     
    } 
    
    public testMethod static void getBeneficiaryListTestTwo (){  
        
        List<Account> lstAccountTestData=getAccountData();
         insert lstAccountTestData;
         
        List<SBC_Communications__c>  lstSBCComm = new List<SBC_Communications__c> () ;  
        SBC_Communications__c oSBC1 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID ) ;   
        SBC_Communications__c oSBC2 = new SBC_Communications__c ( Beneficiary__c = lstAccountTestData[1].ID , Correspondence_Type__c = SYSTEM.LABEL.Encourager_Communication ) ;
   //     lstSBCComm.add(oSBC1) ; 
   //     lstSBCComm.add(oSBC2) ; 
            insert oSBC1 ; 
            
         Test.StartTest() ; 
             
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestBody = Blob.ValueOF( 'testting' )  ; 
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/updateSBCCommunicationCI?';
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            String sVal='{'+
'"CommunicationUpdates":['+
'{'+
'"TranslationLanguage":"Spanish",'+
'"TranslatedText":null,'+
'"TranslatedBy":null,'+
'"Template":"BO-A-1S21-1",'+
'"SourceSystem":"Compassion CI",'+
'"SBCTypes":[],'+
'"SBCGlobalStatus":"Received in the system",'+
'"GlobalPartnerSBCId":"a1Sq00000003LN7EAM",'+
'}'+
']'+
'}';

            req.requestBody = Blob.ValueOF( sVal)  ;
            lstAccountTestData[1].Gender__c = 'male' ; 
            insert oSBC2 ;

            SBCCommunicationUpdateCIRESTService.updateSBCCommunications();
         //   system.Assert ( RestContext.response.statusCode == 200 ) ; 
           
        Test.StopTest() ;     
    } 
}