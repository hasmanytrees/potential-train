/******************************************************************************
    Name             : SendEmailUsingXMPie
    Description      : This class is used to make Http call out to XMPie to
                    initiate Email sending job
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                        optimization
*******************************************************************************/

global with Sharing class SendEmailUsingXMPie
{
        
    /**
    * Method name  : sendPrint
    * Description  : Use this method to send Print Mails
    *                to XMPIE Directly
    * Return Type  : Boolean
    * Parameter    : List<Id>
    **/
    webservice static Boolean sendPrint(List<Id> lstOSBCVarIds)
    {
        Set<Id> setSBCIds = new Set<Id>();
        setSBCIds.addAll(lstOSBCVarIds);
        Boolean bIsSent = false;
        //List<SBC_C
        
        String sResponse=GenerateJSONForSBCCommunicationToCI.generateJSONForCI(setSBCIds, true);
        sResponse=sResponse.replaceAll('"null"','null');
        Integration_Endpoints__c oConnectorMail= new Integration_Endpoints__c ();
        oConnectorMail =Integration_Endpoints__c.getAll().get('Send SBC to XMPIe'); 
        HTTPResponse response = sendDataToXMPIE(oConnectorMail, sResponse, setSBCIds);
        
        if(response!=null && response.getStatusCode() == 200)
        {
            bIsSent= true;
        }
        else
        {
            bIsSent = false;
        }
        return bIsSent;  
              
    }
    
    /**
    * Method name  : sendEmail
    * Description  : Use this method to send email  
    *                to Accounts
    * Return Type  : void
    * Parameter    : List<Account>
    **/
    
    public static boolean sendEmail(List<Account> lstAccount)
    {
        Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
        mapOutput.put('SFDCToXMPieProcessResponse',lstAccount);
        String sResponse=JSONHandlerMethods.serialize(mapOutput,
        'SFDCToXMPieProcess');
        sResponse=sResponse.replaceAll('"null"','null');
        Http http = new Http();

        // Instantiate a new HTTP request, specify the method (POST) as well 
        //as the endpoint
        HttpRequest request = new HttpRequest();
        Integration_Endpoints__c oConnector = 
        Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe'); 
        //Getting Endpoint details from custom setting
        request.setMethod('POST');
        request.setBody(sResponse);
        request.setEndpoint(oConnector
        .Endpoint_URL__c+'?api_key='+oConnector.Authorization_Code__c);
        request.setMethod('POST');
        request.setBody(sResponse);
        request.setTimeout(120000); 
        
        request.setHeader('Content-Type', 'application/json');
        // Send the request, and return a response
        if(!test.isRunningTest())
        {
            request.setHeader('Authorization',
            new MasheryOAuthGenerator().generateMasheryOAuth ());
            //Adding authorization Header
            HttpResponse response = http.send(request);
            
            if(response.getStatus()=='OK')
            {
                return true;                
            }
            else
            {
                return false;                
            }
        }
        return true;
    }
    
    /**
    * Method name  : sendEmailForSBC
    * Description  : Use this method to send email  
    *                specific with SBC data to XMPIE
    * Return Type  : boolean
    * Parameter    : List<SBC_Communications__c>
    **/
    
    public static boolean sendEmailForSBC(List<SBC_Communications__c> lstSBCCommunications, Boolean bSendToPrint)
    {
        Set<Id> setSBCIds = new Set<Id>();
        for(SBC_Communications__c oSBCVar : lstSBCCommunications)
        {
            setSBCIds.add(oSBCVar.id);
        }
        
        String sResponse=GenerateJSONForSBCCommunicationToCI.generateJSONForCI(setSBCIds, true);
        sResponse=sResponse.replaceAll('"null"','null');
        
        String sSponserStationaryTemplate=SupporterStationaryTemplate__c.getAll().get('SL1').SupporterStationaryTemplate__c;
        if(sSponserStationaryTemplate!=null)
          sResponse=sResponse.replaceAll('"SponsorStationaryTemplate":null','"SponsorStationaryTemplate":"'+sSponserStationaryTemplate+'"');
          
        Boolean bSendResponse = false;
        HttpResponse response;
        
        if(lstSBCCommunications[0]!=null && lstSBCCommunications[0].Date_Physical_Received__c==null){
        if(bSendToPrint || lstSBCCommunications[0].Preferred_Address__c!=null)
        { 
        Integration_Endpoints__c oConnectorMail= new Integration_Endpoints__c ();
        oConnectorMail =Integration_Endpoints__c.getAll().get('Send SBC to XMPIe'); 
        response = sendDataToXMPIE(oConnectorMail, sResponse, setSBCIds);
        
        }
        
        if(!bSendToPrint && lstSBCCommunications[0].Preferred_Email__c!=null) 
        {
        Integration_Endpoints__c oConnectorEmail= new Integration_Endpoints__c ();
        oConnectorEmail =Integration_Endpoints__c.getAll().get('Send SBC to XMPIe Email');
        response = sendDataToXMPIE(oConnectorEmail, sResponse, setSBCIds);
        
        }
        }
        else if(bSendToPrint){
        
        
        Integration_Endpoints__c oConnectorMail= new Integration_Endpoints__c ();
        oConnectorMail =Integration_Endpoints__c.getAll().get('Send SBC to XMPIe'); 
        response = sendDataToXMPIE(oConnectorMail, sResponse, setSBCIds);
        
        
        }
       else if(!bSendToPrint ) 
        {
        Integration_Endpoints__c oConnectorEmail= new Integration_Endpoints__c ();
        oConnectorEmail =Integration_Endpoints__c.getAll().get('Send SBC to XMPIe Email');
        response = sendDataToXMPIE(oConnectorEmail, sResponse, setSBCIds);
        
        }
        
        
        if(response!=null && response.getStatusCode() == 200)
        {
            bSendResponse = true;
        }
        if(!bSendResponse)
        {
            //Error Log Added here for null response
            
            Utility.insertErrorLogApplication('Error Occured-Status :'+((response!=null)?response.getStatusCode():null)+'===============\n'+'Failed',
            'SBC_Communications__c',String.valueOf(setSBCIds),
            'SendEmailUsingXMPie','sendEmailForSBC','Integration',
            UserInfo.getUserId(),null,null);    
            
            
        }
        
        
        return bSendResponse;
        
        
    }
    
    /**
    * Method name  : sendDataToXMPIE
    * Description  : Use this method to send email  
    *                specific with SBC data to XMPIE
    * Return Type  : boolean
    * Parameter    : List<SBC_Communications__c>
    **/
    private static HttpResponse sendDataToXMPIE(Integration_Endpoints__c connectorDetails, String sResponse, Set<Id> setSBCIds)
    {
        Http http = new Http();

        // Instantiate a new HTTP request, specify the method (POST) as well 
        //as the endpoint
        HttpRequest request = new HttpRequest();
        Integration_Endpoints__c oConnector= connectorDetails;
        //new Integration_Endpoints__c ();
        
        //Getting Endpoint details from custom setting
        request.setMethod('POST');
        request.setBody(sResponse);
        request.setEndpoint(oConnector
        .Endpoint_URL__c+'?api_key='+oConnector.Authorization_Code__c);
        //request.setMethod('POST');
        request.setBody(sResponse);
        request.setTimeout(120000); 
        
        request.setHeader('Content-Type', 'application/json');
        // Send the request, and return a response
        if(!test.isRunningTest() ){
            request.setHeader('Authorization',
            new MasheryOAuthGenerator().generateMasheryOAuth ());
            //Adding authorization Header
              HttpResponse response;
            try{
              response = http.send(request);
            
            if(response .getStatus()!='OK'){
            
               String sEndPoint = oConnector.Endpoint_URL__c+'?api_key='+oConnector.Authorization_Code__c;
               Utility.insertErrorLogIntegration3(response.getStatus(),'Call out Failed','SendEmailUsingXMPie','Integration',
                'XMPieIntegration','Data sent out Call',
                sResponse,UserInfo.getUserId(),
                'sendDataToXMPIE',null,sEndPoint ,'POST');
            }
            return response;
            }
            catch(Exception ex)
            {
               String sEndPoint = oConnector.Endpoint_URL__c+'?api_key='+oConnector.Authorization_Code__c;
               Utility.insertErrorLogIntegration3(response.getStatus(),'Call out Failed','SendEmailUsingXMPie','Integration',
                'XMPieIntegration','Data sent out Call',
                response.getBody(),UserInfo.getUserId(),
                'sendDataToXMPIE',null,sEndPoint ,'POST');
            }
        }
        return null;  
    }
    
    
    
}