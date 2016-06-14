@isTest
global class MockHttpResponseGenerator  
{
    public static String sBeneficiaryId;
    public static String sSupporterId;
    global class MockCommitment implements HttpCalloutMock
    {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //String sBody = '{"SBCCommunicationDetails":[{"TranslationLanguage":"Spanish","TranslatedText":null,"TranslatedBy":null,"Template":"BO-A-1S21-1","Supporter_PreferredName":"Mrs. McDonald","Supporter_MandatoryReviewRequired":null,"Supporter_GlobalId":"00108245","Supporter_Gender":null,"Supporter_CompassConstituentId":"7-344590","Supporter_CommunicationDeliveryPreference":null,"SponsorStationaryTemplate":null,"SourceSystem":"Compassion USA","SBCTypes":[],"SBCGlobalStatus":"Received in the system","ReworkComments":null,"RelationshipType":"Sponsor","ReasonForRework":"none","PrintType":null,"OriginalText":"test data","OriginalLetterURL":null,"OriginalLanguage":null,"NumberOfPages":null,"ItemNotScannedNotEligible":false,"ItemNotScannedEligible":false,"IsReadBySupporter":null,"IsOriginalLetterArchived":false,"IsMarkedForRework":false,"IsFinalLetterArchived":false,"IsFinalLetter":false,"Internal_Supporter_PersonalEmail":"cheryl.mcdonald@comcast.net","Internal_Supporter_MailingStreet1":null,"Internal_Supporter_MailingPostalCode":null,"Internal_Supporter_MailingCountryDivision":null,"Internal_Supporter_MailingCountry":null,"Internal_Supporter_MailingCity":null,"Internal_Supporter_InCareOfMailingAddress":null,"Internal_Supporter_CommunicationMethod":"Email","Internal_Perceptive_TransactionId":null,"ICP_Id":null,"GlobalPartnerSBCId":"SBC-020855521","GlobalPartner_OptInForLanguageTranslation":null,"GlobalPartner_GlobalPartnerId":"US","FontSize":0,"Font":null,"FinalLetterURL":null,"EnglishTranslatedText":null,"Direction":"Supporter To Beneficiary","CompassionSBCId":null,"Beneficiary_Name":"Joselyn Nicol Cubi Ganan","Beneficiary_LocalId":"EC4210642","Beneficiary_GlobalId":"05994745","Beneficiary_Gender":"Female","Beneficiary_CompassId":"1787658","Beneficiary_Age":"16"}]}';
        //String sBody = '{"CommitmentDetails":[{"CommitDetail":[{"CommitmentStatus":"Inactive","CommitmentId":"7-197815","StartDate":"1988-01-20","StopDate":"1988-06-07","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"210965"},{"CommitmentStatus":"Inactive","CommitmentId":"7-197817","StartDate":"1996-03-20","StopDate":"2008-12-05","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"485835"},{"CommitmentStatus":"Inactive","CommitmentId":"7-197816","StartDate":"1988-06-20","StopDate":"1996-03-07","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"221328"},{"CommitmentStatus":"Active","CommitmentId":"7-4035432","StartDate":"2014-06-05","StopDate":null,"CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"1604239"},{"CommitmentStatus":"Inactive","CommitmentId":"7-3287046","StartDate":"2011-12-02","StopDate":"2012-02-24","CommitmentType":"Sponsorship","Supporter":"7-2979490","Beneficiary":"1604239"},{"CommitmentStatus":"Active","CommitmentId":"7-2584894","StartDate":"2009-01-26","StopDate":null,"CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"1787658"}]}]}';
        String sBody = '{     "CommunicationUpdates": [         {             "CompassionSBCId": "C0000000424",             "GlobalPartnerSBCId": "SBC-000001036", "Id": "a1Sq00000003MXr"}     ] }';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody(sBody);
        //res.setStatus('OK');
        return res;
    }
    }
    
    global class MockCommitment2 implements HttpCalloutMock
    {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //String sBody = '{"SBCCommunicationDetails":[{"TranslationLanguage":"Spanish","TranslatedText":null,"TranslatedBy":null,"Template":"BO-A-1S21-1","Supporter_PreferredName":"Mrs. McDonald","Supporter_MandatoryReviewRequired":null,"Supporter_GlobalId":"00108245","Supporter_Gender":null,"Supporter_CompassConstituentId":"7-344590","Supporter_CommunicationDeliveryPreference":null,"SponsorStationaryTemplate":null,"SourceSystem":"Compassion USA","SBCTypes":[],"SBCGlobalStatus":"Received in the system","ReworkComments":null,"RelationshipType":"Sponsor","ReasonForRework":"none","PrintType":null,"OriginalText":"test data","OriginalLetterURL":null,"OriginalLanguage":null,"NumberOfPages":null,"ItemNotScannedNotEligible":false,"ItemNotScannedEligible":false,"IsReadBySupporter":null,"IsOriginalLetterArchived":false,"IsMarkedForRework":false,"IsFinalLetterArchived":false,"IsFinalLetter":false,"Internal_Supporter_PersonalEmail":"cheryl.mcdonald@comcast.net","Internal_Supporter_MailingStreet1":null,"Internal_Supporter_MailingPostalCode":null,"Internal_Supporter_MailingCountryDivision":null,"Internal_Supporter_MailingCountry":null,"Internal_Supporter_MailingCity":null,"Internal_Supporter_InCareOfMailingAddress":null,"Internal_Supporter_CommunicationMethod":"Email","Internal_Perceptive_TransactionId":null,"ICP_Id":null,"GlobalPartnerSBCId":"SBC-020855521","GlobalPartner_OptInForLanguageTranslation":null,"GlobalPartner_GlobalPartnerId":"US","FontSize":0,"Font":null,"FinalLetterURL":null,"EnglishTranslatedText":null,"Direction":"Supporter To Beneficiary","CompassionSBCId":null,"Beneficiary_Name":"Joselyn Nicol Cubi Ganan","Beneficiary_LocalId":"EC4210642","Beneficiary_GlobalId":"05994745","Beneficiary_Gender":"Female","Beneficiary_CompassId":"1787658","Beneficiary_Age":"16"}]}';
        String sBody = '{"CommitmentDetails":[{"CommitDetail":[{"CommitmentStatus":"Inactive","CommitmentId":"7-197815","StartDate":"1988-01-20","StopDate":"1988-06-07","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"210965"},{"CommitmentStatus":"Inactive","CommitmentId":"7-197817","StartDate":"1996-03-20","StopDate":"2008-12-05","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"485835"},{"CommitmentStatus":"Inactive","CommitmentId":"7-197816","StartDate":"1988-06-20","StopDate":"1996-03-07","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"221328"},{"CommitmentStatus":"Active","CommitmentId":"7-4035432","StartDate":"2014-06-05","StopDate":null,"CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"1604239"},{"CommitmentStatus":"Inactive","CommitmentId":"7-3287046","StartDate":"2011-12-02","StopDate":"2012-02-24","CommitmentType":"Sponsorship","Supporter":"7-2979490","Beneficiary":"1604239"},{"CommitmentStatus":"Inactive","CommitmentId":"7-2584894","StartDate":"2009-01-26","StopDate":"2009-01-26","CommitmentType":"Sponsorship","Supporter": "'+sSupporterId+'","Beneficiary":"'+sBeneficiaryId+'"}]}]}';
        //String sBody = '{     "CommunicationUpdates": [         {             "CompassionSBCId": "C0000000424",             "GlobalPartnerSBCId": "SBC-000001036", "Id": "a1Sq00000003MXr"}     ] }';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody(sBody);
        res.setStatus('OK');
        return res;
    }
    }
    
    global class MockMashery implements HttpCalloutMock
    {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //String sBody = '{"SBCCommunicationDetails":[{"TranslationLanguage":"Spanish","TranslatedText":null,"TranslatedBy":null,"Template":"BO-A-1S21-1","Supporter_PreferredName":"Mrs. McDonald","Supporter_MandatoryReviewRequired":null,"Supporter_GlobalId":"00108245","Supporter_Gender":null,"Supporter_CompassConstituentId":"7-344590","Supporter_CommunicationDeliveryPreference":null,"SponsorStationaryTemplate":null,"SourceSystem":"Compassion USA","SBCTypes":[],"SBCGlobalStatus":"Received in the system","ReworkComments":null,"RelationshipType":"Sponsor","ReasonForRework":"none","PrintType":null,"OriginalText":"test data","OriginalLetterURL":null,"OriginalLanguage":null,"NumberOfPages":null,"ItemNotScannedNotEligible":false,"ItemNotScannedEligible":false,"IsReadBySupporter":null,"IsOriginalLetterArchived":false,"IsMarkedForRework":false,"IsFinalLetterArchived":false,"IsFinalLetter":false,"Internal_Supporter_PersonalEmail":"cheryl.mcdonald@comcast.net","Internal_Supporter_MailingStreet1":null,"Internal_Supporter_MailingPostalCode":null,"Internal_Supporter_MailingCountryDivision":null,"Internal_Supporter_MailingCountry":null,"Internal_Supporter_MailingCity":null,"Internal_Supporter_InCareOfMailingAddress":null,"Internal_Supporter_CommunicationMethod":"Email","Internal_Perceptive_TransactionId":null,"ICP_Id":null,"GlobalPartnerSBCId":"SBC-020855521","GlobalPartner_OptInForLanguageTranslation":null,"GlobalPartner_GlobalPartnerId":"US","FontSize":0,"Font":null,"FinalLetterURL":null,"EnglishTranslatedText":null,"Direction":"Supporter To Beneficiary","CompassionSBCId":null,"Beneficiary_Name":"Joselyn Nicol Cubi Ganan","Beneficiary_LocalId":"EC4210642","Beneficiary_GlobalId":"05994745","Beneficiary_Gender":"Female","Beneficiary_CompassId":"1787658","Beneficiary_Age":"16"}]}';
        String sBody = '{"access_token":"jywftft72367676gywd"}';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody(sBody);
        res.setStatus('OK');
        //res.setStatusCode(200);
        return res;
    }
    }
    
    
    global class MockCommitment3 implements HttpCalloutMock
    {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //String sBody = '{"SBCCommunicationDetails":[{"TranslationLanguage":"Spanish","TranslatedText":null,"TranslatedBy":null,"Template":"BO-A-1S21-1","Supporter_PreferredName":"Mrs. McDonald","Supporter_MandatoryReviewRequired":null,"Supporter_GlobalId":"00108245","Supporter_Gender":null,"Supporter_CompassConstituentId":"7-344590","Supporter_CommunicationDeliveryPreference":null,"SponsorStationaryTemplate":null,"SourceSystem":"Compassion USA","SBCTypes":[],"SBCGlobalStatus":"Received in the system","ReworkComments":null,"RelationshipType":"Sponsor","ReasonForRework":"none","PrintType":null,"OriginalText":"test data","OriginalLetterURL":null,"OriginalLanguage":null,"NumberOfPages":null,"ItemNotScannedNotEligible":false,"ItemNotScannedEligible":false,"IsReadBySupporter":null,"IsOriginalLetterArchived":false,"IsMarkedForRework":false,"IsFinalLetterArchived":false,"IsFinalLetter":false,"Internal_Supporter_PersonalEmail":"cheryl.mcdonald@comcast.net","Internal_Supporter_MailingStreet1":null,"Internal_Supporter_MailingPostalCode":null,"Internal_Supporter_MailingCountryDivision":null,"Internal_Supporter_MailingCountry":null,"Internal_Supporter_MailingCity":null,"Internal_Supporter_InCareOfMailingAddress":null,"Internal_Supporter_CommunicationMethod":"Email","Internal_Perceptive_TransactionId":null,"ICP_Id":null,"GlobalPartnerSBCId":"SBC-020855521","GlobalPartner_OptInForLanguageTranslation":null,"GlobalPartner_GlobalPartnerId":"US","FontSize":0,"Font":null,"FinalLetterURL":null,"EnglishTranslatedText":null,"Direction":"Supporter To Beneficiary","CompassionSBCId":null,"Beneficiary_Name":"Joselyn Nicol Cubi Ganan","Beneficiary_LocalId":"EC4210642","Beneficiary_GlobalId":"05994745","Beneficiary_Gender":"Female","Beneficiary_CompassId":"1787658","Beneficiary_Age":"16"}]}';
        //String sBody = '{"CommitmentDetails":[{"CommitDetail":[{"CommitmentStatus":"Inactive","CommitmentId":"7-197815","StartDate":"1988-01-20","StopDate":"1988-06-07","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"210965"},{"CommitmentStatus":"Inactive","CommitmentId":"7-197817","StartDate":"1996-03-20","StopDate":"2008-12-05","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"485835"},{"CommitmentStatus":"Inactive","CommitmentId":"7-197816","StartDate":"1988-06-20","StopDate":"1996-03-07","CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"221328"},{"CommitmentStatus":"Active","CommitmentId":"7-4035432","StartDate":"2014-06-05","StopDate":null,"CommitmentType":"Sponsorship","Supporter":"7-344590","Beneficiary":"1604239"},{"CommitmentStatus":"Inactive","CommitmentId":"7-3287046","StartDate":"2011-12-02","StopDate":"2012-02-24","CommitmentType":"Sponsorship","Supporter":"7-2979490","Beneficiary":"1604239"},{"CommitmentStatus":"Inactive","CommitmentId":"7-2584894","StartDate":"2009-01-26","StopDate":"2009-01-26","CommitmentType":"Sponsorship","Supporter": "'+sSupporterId+'","Beneficiary":"'+sBeneficiaryId+'"}]}]}';
        //String sBody = '{     "CommunicationUpdates": [         {             "CompassionSBCId": "C0000000424",             "GlobalPartnerSBCId": "SBC-000001036", "Id": "a1Sq00000003MXr"}     ] }';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        //res.setBody(sBody);
        //res.setStatus('OK');
        return res;
    }
    }
}