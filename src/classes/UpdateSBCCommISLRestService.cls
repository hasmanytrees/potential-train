/******************************************************************************
    Name             : UpdateSBCCommISLRestService
    Description      : This REST webservice is used to update
                    SBC Communications records
    Modification Log : 
---------------------------------------------------------------------------
    Developer              Date              Description
---------------------------------------------------------------------------
    Subhojit               30/10/2014        Created
*****************************************************************************/

@RestResource(urlMapping='/persons/communications/state')
global class UpdateSBCCommISLRestService
{
    /**
    * Method name  : CommActivityUpdateISLRESTServices
    * Description  : Use this method to update SBC Communication 
    *                Records based on the ISL JSON
    * Return Type  : void
    * Parameter    : JSON
    **/
    
    @HttpPost
    global static void CommActivityUpdateISLRESTServices() 
    {        
        RestRequest request = RestContext.request;
        String sCommunicationID = 
        RestContext.request.params.get('CommunicationID'); 
        String sIsRead= 
        RestContext.request.params.get('IsRead'); 
        
        try
        {            
            RestContext.response.statusCode = 201; 
            RestContext.response.addHeader('Content-Type', 'application/json');
            String sRequest=request.requestBody.toString().trim();
            system.debug ( 'requestBody??>>>' + request.requestBody.toString().trim() ) ;
            
            if(!String.IsBlank( sCommunicationID  ) 
            && ! String.IsBlank( sIsRead ) 
            && ( sIsRead == 'true' || sIsRead == 'false'))
            {                
                SBC_Communications__c oSBCCommunication = new SBC_Communications__c (
                id = sCommunicationID , 
                Read__c = Boolean.ValueOF( sIsRead ) ) ; 
                try
                {
                    update oSBCCommunication ;
                }
                Catch(Exception ex ) 
                {
                    RestContext.response.statusCode = 404 ;
                     Utility.insertErrorLogApplication('500',ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'CommActivityUpdateISLRESTServices','Application',
                    'CommActivityUpdateISLRESTServices',String.valueOf(oSBCCommunication.id),
                    String.valueOf(oSBCCommunication),UserInfo.getUserId(),
                    'updateBeneficiaryEncourageLock');
                    return;
                }
            }
            else
            {
                RestContext.response.statusCode = 400 ;
                return;
            }
        }
        Catch( exception ex ) 
        {
            RestContext.response.statusCode = 500;
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'CommActivityUpdateISLRESTServices','Integration',
            'CommActivityUpdateISLRESTServices','Inbound Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'updateBeneficiaryEncourageLock');  
        }    
        
    }
}