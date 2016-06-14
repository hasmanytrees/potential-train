/*****************************************************************************
    Name             : ContactBORESTServices
    Description      : This REST webservice is used to Call to query all Slot 
                        for that Volunteer till that Time.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit             30/10/2014      Created
Subhojit             29/01/2015    Modified for code re-factoring & optimization
                                              
******************************************************************************/
@RestResource(urlMapping='/persons/persondetails/*')
global class ContactBORESTServices{

    @HttpGet
    global static void getContactBO() {
        RestContext.response.statusCode = 200 ; 
        try{
            String sContactId = 
            RestContext.request.params.get(System.Label.personid);
            String sAccountId = 
            RestContext.request.params.get(System.Label.organizationid);
            RestContext.response.addHeader('Content-Type', 'application/json');
            
            List<Account> lstAccountRetrieved=new List<Account>(); 
             List<Account> lstAccountRetrievedVar=new List<Account>();
            Set<Id> setRelationshipGroup=new Set<Id>();
            boolean bSpecialCase=false;
            if(sContactId !=null){
               lstAccountRetrievedVar=[select Id,Type,Legacy_Partner_Id__c, 
            Legacy_Supporter_Id__c,First_Name__c,Account_Full_Name__c,
            Preferred_Phone_No__c,Preferred_Phone__c, Name,Preferred_Address__c,
            Preferred_Email_Address__c,Preferred_Name__c,
            Preferred_Email__c,(select Salutation,Id,FirstName,LastName,
            Preferred_Email__c,Preferred_Name__c,Name,AccountId from Contacts)from Account where
            ( Id=:sContactId) AND Status__c='Active' and Type!='Individual'];
            
                if(lstAccountRetrievedVar.size()>0){
                bSpecialCase=true;
                }
            }
           
            //Geting related Account/Contact Details 
            lstAccountRetrievedVar=[select Id,Type,Legacy_Partner_Id__c, 
            Legacy_Supporter_Id__c,First_Name__c,Account_Full_Name__c,
            Preferred_Phone_No__c,Preferred_Phone__c, Name,Preferred_Address__c,
            Preferred_Email_Address__c,Preferred_Name__c,
            Preferred_Email__c,(select Salutation,Id,FirstName,LastName,
            Preferred_Email__c,Preferred_Name__c,Name,AccountId from Contacts)from Account where
            (Id =:sAccountId OR Id=:sContactId) AND Status__c='Active'];
            
            for(Account oAccountVar: lstAccountRetrievedVar){
                
                if(((sContactId!=null)&&(oAccountVar.Type=='Individual'))||(bSpecialCase)){
                    //For Account with type individual
                    oAccountVar.C_O_Physical_Address__c = 
                    oAccountVar.Account_Full_Name__c;
                    oAccountVar.Employer__c=oAccountVar.Id;
                    oAccountVar.Status__c=oAccountVar.Id;
                    oAccountVar.Override_Account_Validation__c=false;
                    oAccountVar.Business_Email__c = 
                    oAccountVar.Preferred_Email_Address__c ;
                    lstAccountRetrieved.add(oAccountVar);
                }
                if(!bSpecialCase){
                for(Contact oContactVar: oAccountVar.Contacts){
                    //To Send contact information,contact fields are mapped to
                    // Account fields.
                    Account oAccountTempVar=new Account();
                    oAccountTempVar.Prefix__c=oContactVar.Salutation;
                    oAccountTempVar.Override_Account_Validation__c=true;
                    oAccountTempVar.Status__C=oContactVar.Id;
                    oAccountTempVar.Employer__c=oContactVar.Id;
                    oAccountTempVar.C_O_Physical_Address__c=oContactVar.Name;
                    oAccountTempVar.Business_Email__c = 
                    oContactVar.Preferred_Email__c;
                    oAccountTempVar.Name=oContactVar.LastName;
                    oAccountTempVar.First_Name__c=oContactVar.FirstName;
                    oAccountTempVar.Preferred_Email__c=null;
                    oAccountTempVar.Preferred_Name__c=oContactVar.Preferred_Name__c;
                    lstAccountRetrieved.add(oAccountTempVar);                    
                }  
               }               
            }            
            
            Id accountIdVar;
            
            if(sAccountId!=null)
            accountIdVar=sAccountId;
            else
            accountIdVar=sContactId;
            
            List<Account> lsttRelationShipAccount=new List<Account>();
            
            lsttRelationShipAccount=[select Id,Type,Legacy_Partner_Id__c ,
            Legacy_Supporter_Id__c,First_Name__c,Account_Full_Name__c,Name, 
            Preferred_Address__c,Preferred_Email_Address__c,Prefix__c,
            Preferred_Email__c from Account where Type='Individual' and             
            ParentId =:accountIdVar and Status__c='Active'];
          if(!bSpecialCase){
            for(Account oAccountVar: lsttRelationShipAccount){
                oAccountVar.C_O_Physical_Address__c = 
                oAccountVar.Account_Full_Name__c;
                oAccountVar.Employer__c=oAccountVar.Id;
                oAccountVar.Override_Account_Validation__c=false;
                oAccountVar.Status__c=oAccountVar.Id;
                oAccountVar.Business_Email__c = 
                oAccountVar.Preferred_Email_Address__c ;
                lstAccountRetrieved.add(oAccountVar);                
            }
           } 
            if(lstAccountRetrieved.size()==0){
                //If no Account found
                if(sAccountId <> null ){
                    RestContext.response.statusCode = 200; 
                }else{
                    RestContext.response.statusCode = 404; 
                    //If user has not proviing any Account Id
                }
                
                return ;
            }
            else{
                
                Map<String,List<sObject>> mapOutput =
                new Map<String,List<sObject>>();                
                
               mapOutput.put('ContactBOResponseFieldGroup',lstAccountRetrieved);
                
                
                String sResponse = JSONHandlerMethods.serialize(mapOutput,
                'ContactBOResponseProcess');
               
             RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(sResponse); 
                // Sending the response back
                return ;
                
            } 
            
        }
        catch(Exception ex){
           
            RestContext.response.statusCode = 500 ; 
            
            
            Utility.insertErrorLogIntegration('500' ,ex.getMessage()+'\n'
            +ex.getStackTraceString(),'ContactBORESTServices','Integration',
            'ContactBORESTServices','Inbound Call',
            URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/'+
            RestContext.request.requestURI+'?'+ Utility.retrieveRESTParameters
            (RestContext.request.params.keyset()),UserInfo.getUserId(),
            'getContactBO');
                       
        }
    }


}