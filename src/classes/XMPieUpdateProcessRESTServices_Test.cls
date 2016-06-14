/*****************************************************************************************
    Name             : XMPieUpdateProcessRESTServices_Test
    Description      : This REST class is used to upsert communication record related to account from XMPie
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class XMPieUpdateProcessRESTServices_Test{

                  public  testMethod Static void testXMPieUpdateProcess()
       {
  
            Account volunteerTest=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='test4@test.com',preferred_Email__c='Business');
            insert volunteerTest;   //Creating Volunteer
            
             system.assertEquals('Business',volunteerTest.preferred_Email__c);
            List<Campaign> lstCampaign=new List<Campaign>();
            Campaign EventTest1=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(5),Name = 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
            Campaign EventTest2=new Campaign(RecordtypeId=Utility.getRecordType('Event','Campaign'), StartDate=Date.today(),EndDate=Date.today().addDays(5),Name = 'Test Event1', status ='Draft', type = 'Acquisition', EVE_Channel__c = 'Radio',Track_Goals_At__c= 'Event',  Cancellation_Reason__c = 'test Cancel');
            lstCampaign.add(EventTest1);
            lstCampaign.add(EventTest2);
            insert lstCampaign;
            
           Lead lead=new lead(LastName='test Lead',Email='testLead@test.com',Company='Test Comp');
            insert lead;
            
            Contact contact=new Contact(LastName='Test',Email='test@test.com', Lead__c = lead.id);
            insert contact;
           
            
            system.assertEquals('Test Comp',lead.Company);
            
            String sInputJSON1='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test@test.com", "ConID": "'+volunteerTest.Id+'" } ] }';
            String sInputJSON2='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test2@test.com", "ConID": "'+volunteerTest.Id+'" } ] }';
            String sInputJSON3='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'#'+EventTest2.Id+'", "Entity": "Account", "Email": "test3@test.com", "ConID": "'+volunteerTest.Id+'" } ] }';
            String sInputJSON4='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test4@test.com", "ConID": "'+volunteerTest.Id+'" } ] }';
            String sInputJSON5='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test4@test.com", "ConID": "'+volunteerTest.Id+'" } ] }';
            String sInputJSON6='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Sent", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test4@test.com", "Con_ID": "'+volunteerTest.Id+'" } ] }';
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON1);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            test.startTest();
            volunteerTest.Personal_Email__c='test3@test.com';
            update volunteerTest;
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON3);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            volunteerTest.Work_Email__c='test2@test.com';
            update volunteerTest;
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON6);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            volunteerTest.Personal_Email__c='test3@test.com';
            update volunteerTest;
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON3);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            volunteerTest.Undeliverable_Invalid__c='Business';
            update volunteerTest;
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON5);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            volunteerTest.Undeliverable_Invalid__c=null;
            update volunteerTest;
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON5);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            volunteerTest.Business_Email__c=null;
            volunteerTest.Personal_Email__c='test4@test.com';
            volunteerTest.preferred_Email__c='Personal';
            volunteerTest.Undeliverable_Invalid__c='Personal';
            update volunteerTest;
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON5);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            volunteerTest.Business_Email__c=null;
            volunteerTest.Personal_Email__c='test4@test.com';
            volunteerTest.preferred_Email__c='Personal';
            volunteerTest.Undeliverable_Invalid__c=null;
            update volunteerTest;
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON5);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            Test.stopTest();
            req = new RestRequest(); 
            res = new RestResponse();
            volunteerTest.Personal_Email__c=null;
            volunteerTest.Work_Email__c='test4@test.com';
            volunteerTest.preferred_Email__c='Work';
            volunteerTest.Undeliverable_Invalid__c='Work';
            update volunteerTest;
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON5);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            volunteerTest.Personal_Email__c=null;
            volunteerTest.Work_Email__c='test4@test.com';
            volunteerTest.preferred_Email__c='Work';
            volunteerTest.Undeliverable_Invalid__c=null;
            update volunteerTest;
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON5);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON1);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON2);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON3);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            List<Account> lstAccount=new List<Account>();
                     
            Account volunteerTest2=new Account(Override_Account_Validation__c=true,recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='a@b.com');
            insert volunteerTest2;   //Creating Volunteer
            String sInputJSON7='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test@test.com", "ConID": "'+volunteerTest2.Id+'" } ] }';
            Account volunteerTest3=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='a@b.com');
            insert volunteerTest3;   //Creating Volunteer
            String sInputJSON8='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test@test.com", "ConID": "'+volunteerTest3.Id+'" } ] }';
             Account volunteerTest4=new Account(Override_Account_Validation__c=true,recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='a@b.com');
             Account volunteerTest5=new Account(recordtypeId=Utility.getRecordType('Supporter','Account'),Name='Test',Business_Email__c='a@b.com');
            
            lstAccount.add(volunteerTest2);  
            lstAccount.add(volunteerTest3);  
            lstAccount.add(volunteerTest4);  
            lstAccount.add(volunteerTest5);   
            //insert lstAccount;
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON8);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
            
           
            String sInputJSON9='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Link Clicked", "StatusTime": "2015-02-09T16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "rajupac@deloitte.com", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'#'+EventTest2.Id+'", "Entity": "Account", "Email": "test@test.com", "ConID": "'+volunteerTest2.Id+'" } ] }';
           
          
            String sInputJSON10='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Sent", "StatusTime": "2015-02-09T16:06:38.997ZT16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "gateway@celltrust.net", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail.com", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'#'+EventTest2.Id+'", "Entity": "Account", "Email": "test@test.com", "ConID": "'+volunteerTest3.Id+'" } ] }';
            
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON10);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
               String sInputJSON11='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "75646", "Status": "Email Sent", "StatusTime": "2015-02-09T16:06:38.997ZT16:06:38.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Contact", "Email": "'+System.Label.SMSEmail+'", "ConID": "'+contact.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "111122", "Status": "Email Opened", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Lead", "Email": "rajupac@gmail", "ConID": "'+lead.Id+'" }, { "JobID": "25652", "XMPieUniqueID": "227909", "Status": "Email Failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'#'+EventTest2.Id+'", "Entity": "Account", "Email": "test@test.com", "ConID": "'+volunteerTest3.Id+'" } ] }';
            
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON11);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();
            
          String sInputJSON13='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "2279093", "Status": "Status length exceeeding 20 charaters", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "test4@test.com", "ConID": "'+volunteerTest.Id+'" } ] }';                

            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON13);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();   
            
            String sInputJSON12='{ "XMPieAccount": "Compassion TCPT", "CreatedOn": "2015-02-10T14:17:01Z", "Recipient": [ { "JobID": "25652", "XMPieUniqueID": "2279092", "Status": "failed", "StatusTime": "2015-02-09T16:06:34.997Z", "CampaignID": "'+EventTest1.Id+'", "Entity": "Account", "Email": "'+System.label.smsemail+'", "ConID": "'+volunteerTest.Id+'"} ] }';
             req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON12);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication(); 
            
            volunteerTest.Personal_Email__c='test4@test.com';
            volunteerTest.Work_Email__c=null;
            volunteerTest.preferred_Email__c='Personal';
            if(volunteerTest!=null){
                update volunteerTest;
            }
            
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON12);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();  
            
            
            volunteerTest.Personal_Email__c=null;
            volunteerTest.Work_Email__c='test4@test.com';
            volunteerTest.preferred_Email__c='Work';
            if(volunteerTest!=null){
                update volunteerTest;
            }
            req = new RestRequest(); 
            res = new RestResponse();
            req.requestURI ='https://'+System.URL.getSalesforceBaseURL().getHost()+'/services/apexrest/XMPieUpdateProcess';
            req.requestBody =Blob.valueOf(sInputJSON12);
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response = res;
            system.debug('>>>>>>'+req.requestURI );
            XMPieUpdateProcessRESTServices.manageCommunication();   
      }

}