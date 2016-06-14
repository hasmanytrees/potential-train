/*****************************************************************************************
    Name             : SendEmailUsingXMPie_Test
    Description      :          
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=true)
global class SendEmailUsingXMPie_Test implements HttpCalloutMock{

    /**
    * Method name  : respond
    * Description  : Creating Mock Response for Test Classes
    * Return Type  : HttpResponse 
    * Parameter    : HTTPRequest 
    **/
    
    global HttpResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Access Token').Endpoint_URL__c)
        {
            System.assertEquals(Integration_Endpoints__c.getAll().get('Access Token').Endpoint_URL__c, req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token": "testOauthToken","expires_in": 3600,"token_type": "Bearer"}');
            res.setStatusCode(200);
            return res;      
        }
        else if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe').Endpoint_URL__c)
        {
            System.assertEquals(Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe').Endpoint_URL__c, req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Success"}');
            res.setStatusCode(200);
            return res;
        }
        else
        {        
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"zip_codes": [{"zip_code": "93109","distance": 3.744,"city": "Santa Barbara","state": "CA"}]}');
            res.setStatusCode(200);
            return res;
        }
        return null;
    }

    /**
    * Method name  : SendEmailTest
    * Description  : Test methods run for covering all
    *                methods in the class and scenarios
    * Return Type  : void 
    * Parameter    : void
    **/
    
    public static testMethod void SendEmailTest()
    { 
        List<Account> lstAccountTestData=new  List<Account>();
        Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata1', Business_Email__c='testdata1@testdata.com');
        Account oAccountVar2=new Account(Type='Church',Status__c='Active',Name='Testdata2', Business_Email__c='testdata2@testdata.com');
        Account oAccountVar3=new Account(Type='Foundation',Status__c='Active',Name='Testdata3', Business_Email__c='testdata3@testdata.com');
        Account oAccountVar4=new Account(Type='Association',Status__c='Active',Name='Testdata4', Business_Email__c='testdata4@testdata.com'); 
        
        lstAccountTestData.add(oAccountVar1);
        lstAccountTestData.add(oAccountVar2);
        lstAccountTestData.add(oAccountVar3);
        lstAccountTestData.add(oAccountVar4);
        
        insert lstAccountTestData;
        
        system.assertEquals('Active',lstAccountTestData[3].Status__c);
        
        SendEmailUsingXMPie sEmailXmpi = new SendEmailUsingXMPie();
        SendEmailUsingXMPie.sendEmail(lstAccountTestData);
        


    }}