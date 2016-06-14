/*******************************************************************************
    Name             : MasheryOAuthGenerator
    Description      : This class is basic OAuth token generator for any call 
                       out to ESB
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Subhojit                29/01/2015       Modified for code re-factoring &
                                         optimization
*******************************************************************************/
public with Sharing class MasheryOAuthGenerator {
    
    public String generateMasheryOAuth ()
    {
        HttpRequest request = new HttpRequest();
        
        request.setMethod('POST');
        
        request.setHeader('content-type', 'application/x-www-form-urlencoded');
        request.setHeader('Host',System.label.Host);
        request.setHeader('Content-Length','46');
        request.setHeader('Connection','keep-alive');
        request.setEndpoint(Integration_Endpoints__c.getAll().get
        ('Access Token').Endpoint_URL__c); 
        // Getting end point URL from custom Setting
        
        String sUsername = System.label.MasheryUserName;//client
        String sPassword = System.label.MasheryPassword;//secret
        Blob blobHeadervalue = Blob.valueOf(sUsername + ':' + sPassword);
        String sAuthHeader = 'BASIC ' + 
        EncodingUtil.base64Encode(blobHeaderValue);
        request.setHeader('Authorization', sAuthHeader);
        
        string sBody = 'grant_type=client_credentials&scope=read+write';
        request.setBody(sBody);
        
        Http http = new Http();
       
        HttpResponse resonse = http.Send(request);
      
        String sToken=(String)((Map<String, Object>) JSON.deserializeUntyped
        (resonse .getBody())).get('access_token'); 
        // Get Access_token from response
       
        return 'Bearer '+sToken;  // returning the basic OAuth token
    }
}