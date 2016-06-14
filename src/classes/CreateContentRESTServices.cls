/******************************************************************************
    Name             : CreateContentRESTServices
    Description      : This REST webservice is used to insert 
                       Content Records in Salesforce.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 10/06/2014        Created
*****************************************************************************/
@RestResource(urlMapping='/createContent')
global class CreateContentRESTServices
{
    //Constructor
    @HttpPost
    global static void CreateContentRESTServices() {
        RestRequest request = RestContext.request;
        try{
            
            RestContext.response.statusCode = 200; 
             RestContext.response.addHeader('Content-Type', 'application/json');
            List<Content__c> lstContent = 
            (List<Content__c>)JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'ContentCreationProcess');
            List<Content__c> lstContentFinal=new List<Content__c>();
            
            for(sObject oSObjVar: lstContent){                
                
                lstContentFinal.add((Content__c)oSObjVar);
            }
            try{
                insert lstContentFinal;
                //Upserting record from Compass based on legacy Id
            }
            catch(Exception ex){
                RestContext.response.statusCode = 500 ;
                System.debug('#####'+ex);
           
                Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
                ex.getStackTraceString(),'CreateContentRESTServices','Integration',
                'CreateContentRESTServices','Insert Call',
                request.requestBody.toString().trim(),UserInfo.getUserId(),
                'createContent');
                return;
            }
            
           Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
            mapOutput.put('ContentResponseGroup',lstContentFinal);
            String sResponse=JSONHandlerMethods.serialize(mapOutput,
            'ContentCreationResponeProcess');
              sResponse=sResponse.replace('"null"', 'null');
            sResponse=sResponse.replace('true', 'true');
            sResponse=sResponse.replace('false', 'false');
           
           
            RestContext.response.responseBody = Blob.valueOf(sResponse);
                    }
        catch(Exception ex){
            
            RestContext.response.statusCode = 500 ; 
           
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'CreateContentRESTServices','Integration',
            'CreateContentRESTServices','Insert Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'createContent');
            
        } 
    }
    

}