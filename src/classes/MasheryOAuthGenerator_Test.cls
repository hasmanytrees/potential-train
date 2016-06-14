/*****************************************************************************************
    Name             : MasheryOAuthGenerator
    Description      : This class is basic OAuth token generator for any call out to ESB
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=false)
global class MasheryOAuthGenerator_Test implements HttpCalloutMock{
   
  
  global HttpResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        if(req.getEndpoint()==Integration_Endpoints__c.getAll().get('Access Token').Endpoint_URL__c){
           System.assertEquals(Integration_Endpoints__c.getAll().get('Access Token').Endpoint_URL__c, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token": "testOauthToken","expires_in": 3600,"token_type": "Bearer"}');
        res.setStatusCode(200);
        return res;
       
       
       }
       return null;
    }


   public testMethod Static void testMasheryOAuthGenerator(){
   Integration_Endpoints__c oIp=new Integration_Endpoints__c();
   oIp.Name='Access Token';
   oIp.Endpoint_URL__c='https://api2.compassion.com/core/connect/token';
   insert oIp;
   Test.startTest();
   
   
     Test.setMock(HttpCalloutMock.class, new MasheryOAuthGenerator_Test ());
   
     String sToken=new MasheryOAuthGenerator().generateMasheryOAuth ();
   
   
     system.assertEquals(sToken,'Bearer testOauthToken');
  
   
   
   Test.StopTest();
   
   }

















}