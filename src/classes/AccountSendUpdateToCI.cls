/*******************************************************************************
Name             : AccountSendUpdateToCI
Description      : Trigger Helper class to Send Support Status Update to FI
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/8/2015            Created
Subhojit                30/8/2015            Modified for code re-factoring 
                                            & optimization
*******************************************************************************/
public with sharing class AccountSendUpdateToCI{

    /**
    * Method name  : sendUpdateCI
    * Description  : Use this method to send Status update to CI using Call out 
                    Assignment
    *                
    * Return Type  : void
    * Parameter    :List<Id>
    **/

    @future(callOut=true)
    public static void sendUpdateCI(List<Id> lstAccountId){


        List<Account> lstAccount=new List<Account>();
        lstAccount=[select Id,Global_Id__c,Primary_Language__c,Correspondence_Delivery_Preference__c,Status__c,
        Legacy_Supporter_Id__c from Account where Id IN : lstAccountId];
        List<Correspondence_Delivery_Preference_Map__c> lstDelPref=new   List<Correspondence_Delivery_Preference_Map__c>();
        lstDelPref=Correspondence_Delivery_Preference_Map__c.getAll().values();         
        for(Account oAccountVar: lstAccount){
            //Getting Corrospondence Delivery Preference mapping 
            for(Correspondence_Delivery_Preference_Map__c oCorrDelvar: lstDelPref){
                
                if(oAccountVar.Correspondence_Delivery_Preference__c!=null && oCorrDelvar.Preference__c.equalsIgnoreCase(oAccountVar.Correspondence_Delivery_Preference__c))
                oAccountVar.Correspondence_Delivery_Preference__c=oCorrDelvar.Mapped_Delivery_Preference__c;
            }
            
            
        }
        
        try{
            
            Map<String,List<sObject>> mapOutput =
            new Map<String,List<sObject>>();                
            
            mapOutput.put('AccountCIUpdateFieldGroup',lstAccount);
            
            
            String sResponse = JSONHandlerMethods.serialize(mapOutput,
            'AccountCIUpdateProcess');
            sResponse=sResponse.replace('"null"','null'); 
            Http http = new Http();

            // Instantiate a new HTTP request, specify the method (POST) as well 
            //as the endpoint
            HttpRequest request = new HttpRequest();
            Integration_Endpoints__c oConnector = 
            Integration_Endpoints__c.getAll().get('Send Recipient to XMPIe'); //End point URL to CI org to Update Status
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
            if(!test.isRunningTest()){
                request.setHeader('Authorization',
                new MasheryOAuthGenerator().generateMasheryOAuth ());
                //Adding authorization Header
                HttpResponse response = http.send(request);
            }  
            
            
        }
        catch(Exception ex){

            
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'AccountSendUpdateToCI','Integration',
            'updateSBCCommunications','Outbound Call',
            '',UserInfo.getUserId(),
            'sendUpdateCI');



        }


    }

}