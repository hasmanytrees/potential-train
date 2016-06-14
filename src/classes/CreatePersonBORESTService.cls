/*****************************************************************************
    Name             : CreatePersonBORESTService
    Description      : This REST webservice is used to Call to query all Slot 
                      for that Volunteer till that Time.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               30/10/2014        Created
Subhojit               29/01/2015        Modified for code re-factoring & 
                                         optimization.
****************************************************************************/
@RestResource(urlMapping='/persons/createPerson/*')
global class CreatePersonBORESTService
{
    @HttpPost
    global static void createContact(){

        RestContext.response.statusCode = 200 ; 
        RestRequest request = RestContext.request;
        try{
            RestContext.response.addHeader('Content-Type', 'application/json');
            
           
            List<Contact> lstContact=new List<Contact>();
            lstContact=((List<Contact>)JSONHandlerMethods.deserialize
            (request.requestBody.toString().trim() ,'PersonBOCreateProcess'));
            //Getting input using JSONHandlerMethods
          
            List<Contact>lstContactFinal = new List<Contact>();
            String sAccountId;
            if(lstContact.size()>0)
            sAccountId=lstContact[0].AssistantName;
            List<Account> lstRelatedAccount=new List<Account>();
            List<Contact> lstContactTemp=new List<Contact>();
            List<Account> lstAccountTemp=new List<Account>();
            boolean bIsNewContact=false;
            /* Added part of new CR -22-Apr-15 */
            if(lstContact.size()>0){
                
                lstContactTemp=[select Id from Contact where 
                Contact_Legacy_Id__c =:lstContact[0].Contact_Legacy_Id__c];
                bIsNewContact=true;
                if(lstContactTemp.size()==0)
                {                    
                    lstAccountTemp=[select Id from Account where 
                    Legacy_Supporter_Id__c=:lstContact[0].Contact_Legacy_Id__c];
                    if(lstAccountTemp.size()>0)
                    bIsNewContact=false;
                    else
                    bIsNewContact=true;        
                }
            }
           
            if(!bIsNewContact){
                
                lstAccountTemp.clear();
                lstAccountTemp.add(updateAccount(lstContact[0],new Account()));                
                
                if(lstAccountTemp[0].Id!=null ||
                lstAccountTemp[0].Legacy_Supporter_Id__c!=null){
                    if(lstAccountTemp[0].Home_Phone__c!=null)
                    lstAccountTemp[0].Preferred_Phone__c=System.label.Home;
                    else if(lstAccountTemp[0].Mobile_Phone__c!=null)
                    lstAccountTemp[0].Preferred_Phone__c=System.label.Mobile;
                    lstAccountTemp[0].dupcheck__dc3DisableDuplicateCheck__c = true;
                    Utility.bRecursive=true; 
                    upsert  lstAccountTemp Legacy_Supporter_Id__c;
                }
            }
            
            else{
                lstRelatedAccount=[select Id from Account where
                Legacy_Supporter_Id__c=:sAccountId OR
                Legacy_Partner_Id__c=:sAccountId ];
                //Getting Related Account Id based on Legacy Id
                try{
               
                    if(  lstContact <> NULL && lstContact.size() > 0 && lstRelatedAccount <>  NULL && lstRelatedAccount.size() > 0){
                        for(Contact oContactVar : lstContact)
                        {                            
                            oContactVar.Id=null;
                            Contact oContactTempVar = new Contact();
                            oContactTempVar  = (Contact)oContactVar;
                            oContactTempVar.AccountId=lstRelatedAccount[0].Id;
                            oContactTempVar.dupcheck__dc3DisableDuplicateCheck__c = true;
                            lstContactFinal.add(oContactTempVar );
                          
                        }
                        
                        //upsert clist Contact_Legacy_Id__c;
                        upsert  lstContactFinal Contact_Legacy_Id__c; 
                    }
                }
                catch(Exception ex){
                 Account oAccount=new Account(Background__c='Failure',Description='Internal Server Error');
            
                Map<String,List<sObject>> mapOutputMsg=new Map<String,List<sObject>>();
                mapOutputMsg.put('CompassMessageGroup',
                new List<Account>{oAccount});
                String sResponse=JSONHandlerMethods.serialize
                (mapOutputMsg,'CompassMessage');
              
                
                    RestContext.response.responseBody =
                Blob.valueOf(sResponse);
                    Utility.insertErrorLogIntegration('500',ex.getMessage()+
                    '\n'+ex.getStackTraceString(),'CreatePersonBORESTService',
                    'Integration','CreatePersonBORESTService','Inbound Call',
                    request.requestBody.toString().trim(),UserInfo.getUserId(),
                    'createContact');
                    RestContext.response.statusCode = 500 ; 
                    return;
                }

            }

           Map<String,List<sObject>> mapOutput= new Map<String,List<sObject>>();
            mapOutput.put('PersonBOCreateProcessField',lstContact);
            
            String sResponse=JSONHandlerMethods.serialize(mapOutput,
            'PersonBOCreateProcess');
            
          
            RestContext.response.responseBody = Blob.valueOf(sResponse);
        }
        catch(Exception ex){
            RestContext.response.statusCode = 500 ; 
              Account oAccount=new Account(Background__c='Failure',Description='Internal Server Error');
            
              Map<String,List<sObject>> mapOutputMsg=new Map<String,List<sObject>>();
                mapOutputMsg.put('CompassMessageGroup',
                new List<Account>{oAccount});
             String sResponse=JSONHandlerMethods.serialize
                (mapOutputMsg,'CompassMessage');
                
            RestContext.response.responseBody = Blob.valueOf(sResponse);  
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'CreatePersonBORESTService','Integration',
            'CreatePersonBORESTService','Inbound Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'createContact');
        }   
        
    }
    private Static Account updateAccount(sObject oContact,sObject oAccount){

        Map<String, Object> mapQueriedFieldValues = 
        (Map<String, Object>) JSON.deserializeUntyped
        (JSON.serialize((Contact)oContact));
        
        List<String> lstMappingCondition=new List<String>();
        lstMappingCondition=System.label.ContactToAccountMapping.split('\n');
        Map<String,String> mapContactToAccountField=new Map<String,String>();
        for(String sFieldMapVar: lstMappingCondition)
        mapContactToAccountField.put(sFieldMapVar.split('=')[0].trim(),
        sFieldMapVar.split('=')[1].trim());
       
        for(String sContactFieldApiNameVar: mapQueriedFieldValues.keySet()) {          
            if(mapContactToAccountField.get(sContactFieldApiNameVar)!=null){
    
                if(oContact.get(sContactFieldApiNameVar) instanceOf String)
                oAccount.put((String)mapContactToAccountField.get
                (sContactFieldApiNameVar),
                (String)oContact.get(sContactFieldApiNameVar));
                else if(oContact.get(sContactFieldApiNameVar) instanceOf Date)
                oAccount.put((String)mapContactToAccountField.get
                (sContactFieldApiNameVar),
                (Date)oContact.get(sContactFieldApiNameVar));
               else if(oContact.get(sContactFieldApiNameVar) instanceOf Boolean)
                oAccount.put((String)mapContactToAccountField.get
                (sContactFieldApiNameVar),
                ( Boolean)oContact.get(sContactFieldApiNameVar));
                
            }
        }
        return (Account)oAccount;  
    }

}