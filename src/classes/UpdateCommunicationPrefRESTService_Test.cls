/*****************************************************************************************
    Name             : AccountBORESTServices_Test
    Description      : This REST webservice is used to Call to query all Account and related Contact for that Volunteer till that Time                
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                30/10/2014            Created
******************************************************************************************/
@isTest(seeAllData=true)
public class UpdateCommunicationPrefRESTService_Test
{
     
    /**
    * Method name  : updateAccountPositive
    * Description  : This test method is used for testing 
    *                positive scenarios for the UpdateCommunicationPrefRESTService class
    * Return Type  : void
    * Parameter    : void
    **/ 
     public testMethod static void updateAccountPositive()
     { 
       
         Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1', Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1');
         insert oAccountVar1;
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/updateCommPref';
        Communication_Preference__c comPref = [select id from Communication_Preference__c where Account__c = :oAccountVar1.id];
        String sId = '"'+oAccountVar1.id+'"';
        String sMockJSON = '{"Id": "'+comPref.id+'","Supporter_PlainTextEmail": true,"Supporter_DoNotCall": true,"Supporter_DoNotContact": true,"Supporter_DoNotEmail": true,"Supporter_MobilePhoneNumber": "768768768768768","CategoryArray": [{"Name": "GivingOpportunities","OptOutEmail": false,"OptOutMail": false,"OptOutText": false, "Medium_NameArray": ["Mail"]},{"Name": "ShareYourVoice","OptOutEmail": false, "OptOutMail": false,"OptOutText": false, "Medium_NameArray": [ "Email","Mail"]},{ "Name": "AccountInformation", "OptOutEmail": false,"OptOutMail": false, "OptOutText": true, "Medium_NameArray": ["Email","Mail" ] }, { "Name": "MinistryUpdates","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Mail"]},{"Name": "VolunteerAppealsOpportunities","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Mail"]},{"Name": "GeneralAnnouncements", "OptOutEmail": false,"OptOutMail": false,"OptOutText": false, "Medium_NameArray": ["Email", "Mail"]}, {"Name": "ChildUpdates", "OptOutEmail": false,"OptOutMail": false,"OptOutText": true,"Medium_NameArray": ["Email","Mail"]},{"Name": "ShareCompassion","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Text Message","Mail"]}],"SubscriptionArray": [{"Name": "PrayerPartners","Medium_NameArray": ["Email","Mail"]},{"Name": "SponsoreNews","Medium_NameArray": ["Email"]},{"Name": "ImpacteNews","Medium_NameArray": ["Mail"]},{"Name": "CompassionMagazine","Medium_NameArray": ["Email","Mail"]},{"Name": "CompassionExplorerMagazine","Medium_NameArray": ["Mail"]}]}'; 
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueOf(sMockJSON);
        RestContext.request = req;
        RestContext.response = res;
        UpdateCommunicationPrefRESTService.updateAccount();
    }
    
    /**
    * Method name  : updateAccountNegative
    * Description  : This test method is used for testing 
    *                negative scenarios for the UpdateCommunicationPrefRESTService class
    * Return Type  : void
    * Parameter    : void
    **/ 
    public testMethod static void updateAccountNegative()
    { 
       
         Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1', Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1');
         insert oAccountVar1;
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/updateCommPref';
        Communication_Preference__c comPref = [select id from Communication_Preference__c where Account__c = :oAccountVar1.id];
        String sId = '"'+oAccountVar1.id+'"';
        String sMockJSON = '{"Id": "'+comPref.id+'","Supporter_PlainTextEmail": "true","Supporter_DoNotCall": true,"Supporter_DoNotContact": true,"Supporter_DoNotEmail": true,"Supporter_MobilePhoneNumber": "768768768768768","CategoryArray": [{"Name": "GivingOpportunities","OptOutEmail": false,"OptOutMail": false,"OptOutText": false, "Medium_NameArray": ["Mail"]},{"Name": "ShareYourVoice","OptOutEmail": false, "OptOutMail": false,"OptOutText": false, "Medium_NameArray": [ "Email","Mail"]},{ "Name": "AccountInformation", "OptOutEmail": false,"OptOutMail": false, "OptOutText": true, "Medium_NameArray": ["Email","Mail" ] }, { "Name": "MinistryUpdates","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Mail"]},{"Name": "VolunteerAppealsOpportunities","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Mail"]},{"Name": "GeneralAnnouncements", "OptOutEmail": false,"OptOutMail": false,"OptOutText": false, "Medium_NameArray": ["Email", "Mail"]}, {"Name": "ChildUpdates", "OptOutEmail": false,"OptOutMail": false,"OptOutText": true,"Medium_NameArray": ["Email","Mail"]},{"Name": "ShareCompassion","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Text Message","Mail"]}],"SubscriptionArray": [{"Name": "PrayerPartners","Medium_NameArray": ["Email","Mail"]},{"Name": "SponsoreNews","Medium_NameArray": ["Email"]},{"Name": "ImpacteNews","Medium_NameArray": ["Mail"]},{"Name": "CompassionMagazine","Medium_NameArray": ["Email","Mail"]},{"Name": "CompassionExplorerMagazine","Medium_NameArray": ["Mail"]}]}'; 
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueOf(sMockJSON);
        RestContext.request = req;
        RestContext.response = res;
        
        UpdateCommunicationPrefRESTService.updateAccount();
    }
    
    
    public testMethod static void updateAccount2()
    { 
       
         Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1', Business_Email__c='testdata1@testdata.com',Legacy_Supporter_Id__c='1');
         insert oAccountVar1;
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/updateCommPref';
        Communication_Preference__c comPref = [select id from Communication_Preference__c where Account__c = :oAccountVar1.id];
        String sId = '"'+oAccountVar1.id+'"';
        String sMockJSON = '{"Id": "'+comPref.id+'","Supporter_PlainTextEmail": "true","Supporter_DoNotCall": true,"Supporter_DoNotContact": true,"Supporter_DoNotEmail": true,"Supporter_MobilePhoneNumber": "768768768768768","SubscriptionArray": [{"Name": "CorrespondenceDeliveryPreference","OptOutEmail": false,"OptOutMail": false,"OptOutText": false, "Medium_NameArray": ["Mail"]},{"Name": "ShareYourVoice","OptOutEmail": false, "OptOutMail": false,"OptOutText": false, "Medium_NameArray": [ "Email","Mail"]},{ "Name": "AccountInformation", "OptOutEmail": false,"OptOutMail": false, "OptOutText": true, "Medium_NameArray": ["Email","Mail" ] }, { "Name": "MinistryUpdates","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Mail"]},{"Name": "VolunteerAppealsOpportunities","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Mail"]},{"Name": "GeneralAnnouncements", "OptOutEmail": false,"OptOutMail": false,"OptOutText": false, "Medium_NameArray": ["Email", "Mail"]}, {"Name": "ChildUpdates", "OptOutEmail": false,"OptOutMail": false,"OptOutText": true,"Medium_NameArray": ["Email","Mail"]},{"Name": "ShareCompassion","OptOutEmail": false,"OptOutMail": false,"OptOutText": false,"Medium_NameArray": ["Email","Text Message","Mail"]}],"SubscriptionArray": [{"Name": "PrayerPartners","Medium_NameArray": ["Email","Mail"]},{"Name": "SponsoreNews","Medium_NameArray": ["Email"]},{"Name": "ImpacteNews","Medium_NameArray": ["Mail"]},{"Name": "CompassionMagazine","Medium_NameArray": ["Email","Mail"]},{"Name": "CompassionExplorerMagazine","Medium_NameArray": ["Mail"]}]}'; 
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueOf(sMockJSON);
        RestContext.request = req;
        RestContext.response = res;
        
        UpdateCommunicationPrefRESTService.updateAccount();
    }
}