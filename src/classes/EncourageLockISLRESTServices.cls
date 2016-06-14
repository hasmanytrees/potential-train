/*****************************************************************************
    Name             : EncourageLockISLRESTServices
    Description      : This REST webservice is used to stamp encourage Date
                        Beneficiaries 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Jeevan D               25-8-2015 
                                            
******************************************************************************/

@RestResource(urlMapping='/beneficiaries/availabletoencourage/lock')
global class EncourageLockISLRESTServices{

    /**
    * Method name  : updateEncourageLockRESTServices
    * Description  : This REST webservice is used to stamp encourage Date
                    Beneficiaries  
    *                
    * Return Type  : void
    * Parameter    : Void
    **/  
    @HttpPatch
    global static void updateEncourageLockRESTServices() {
            RestRequest request = RestContext.request;
       Map<String,String> mapParam=new Map<String,String>();
       
       for(String sParamName: RestContext.request.params.keySet()){
       if(RestContext.request.params.get(sParamName)!=null){
          
          if(sParamName.equalsIgnoreCase('BeneficiaryId'))
           mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName));
         else
          mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName).toLowerCase());
         }
       }  
        if( mapParam.size()>0){
            RestContext.request.params.clear();
           RestContext.request.params.putAll(mapParam);
           
           
          }
        String sBeneficiaryId = 
        RestContext.request.params.get('beneficiaryid'); 
        String sEncourageLockDate= 
        RestContext.request.params.get('encouragelockdate'); 
        if(sEncourageLockDate <> null && sEncourageLockDate <> '')
        {
            sEncourageLockDate = sEncourageLockDate.replace('t',' ');
            sEncourageLockDate = sEncourageLockDate.replace('z','');
        }
        try{
             List<Account> lstAccountVar=new List<Account>();
             lstAccountVar=[select Id,BEN_Encourager_Lock_Date__c  from Account where Id=:sBeneficiaryId
                                       OR  Compass_Child_Key__c=: sBeneficiaryId limit 1];
            Account oAccountVar;
            if(   lstAccountVar.size()>0){
            
             oAccountVar=new Account();
             oAccountVar=lstAccountVar[0];
            }
            else{
            RestContext.response.statusCode = 404;
            return ;
            }
            RestContext.response.statusCode = 201; 
             if(oAccountVar.BEN_Encourager_Lock_Date__c >System.now()){
                 RestContext.response.statusCode = 200; // If Exsistiing lock has not expired.
                
               }
              else
                 RestContext.response.statusCode = 201;
              
            RestContext.response.addHeader('Content-Type', 'application/json');
            if( !String.IsBlank( sBeneficiaryId  ) && ! String.IsBlank( sEncourageLockDate )  ){
                Account oBenUpdate = new Account () ; 
               
                DateTime  dtEncourageLock = Datetime.valueOfGMT(sEncourageLockDate);
                
                if(sBeneficiaryId .length()<15){
                    oBenUpdate = new Account ( Compass_Child_Key__c= sBeneficiaryId , 
                BEN_Encourager_Lock_Date__c = dtEncourageLock                                            
                ) ; 
              
                try
                {
                    //upsert oBenUpdate BEN_Global_Id__c;
                    upsert oBenUpdate Compass_Child_Key__c;
                      
                }
                catch(Exception ex)
                {
                    RestContext.response.statusCode = 404 ;
                    Utility.insertErrorLogApplication('500',ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'EncourageLockISLRESTServices','Application',
                    'updateBeneficiary','Beneficiary Update',
                    String.valueOf(oBenUpdate) ,UserInfo.getUserId(),
                    'updateBeneficiaryEncourageLock');
                    return;
                }
              }
              else if(sBeneficiaryId .length()>=15){
                oBenUpdate = new Account ( Id= sBeneficiaryId , 
                BEN_Encourager_Lock_Date__c = dtEncourageLock 
                ) ; 
                  try
                {
                    update oBenUpdate;
                }
                catch(Exception ex)
                {
                    RestContext.response.statusCode = 404 ;
                    RestContext.response.statusCode = 500;
                    Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
                    ex.getStackTraceString(),'EncourageLockISLRESTServices','Integration',
                    'updateEncourageLockRESTServices','Inbound Call',
                    String.valueOf(oBenUpdate),UserInfo.getUserId(),
                    'BeneficiaryAccountUpdateFailed'); 
                    return;
                }
              
              }
             
            }
            else
            {
                RestContext.response.statusCode = 400 ;
                return;
            }
        }
        Catch( Exception ex ){
            RestContext.response.statusCode = 500;
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'EncourageLockISLRESTServices','Integration',
            'updateEncourageLockRESTServices','Inbound Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'updateBeneficiaryEncourageLock');     
        }
        
    }        
    
}