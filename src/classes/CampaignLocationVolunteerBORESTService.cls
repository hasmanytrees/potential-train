/*****************************************************************************
    Name             : CampaignLocationVolunteerBORESTService
    Description      : This REST webservice is used to Call to query all Slot 
                       for that Volunteer till that Time                
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
*****************************************************************************/
@RestResource(urlMapping='/persons/*')
global class CampaignLocationVolunteerBORESTService
{
    //Constructor
    @HttpGet
    global static void getVolunteerDetails() {
       RestContext.response.statusCode = 200 ; 
        try{
            String sVolunteerId= 
            RestContext.request.params.get(System.Label.volunteerid);
            RestContext.response.addHeader('Content-Type', 
            'application/json');
            
            List<Account> lstAccount=new List<Account>();
            lstAccount=[select Id,ADV_Preferred_Zip_Code__c,
            ADV_Preferred_Radius__c,Last_Login_Date_Time__c,
            Preferred_Email__c,
            Preferred_Email_Address__c from Account 
            where Id=:sVolunteerId];
            //Geting volunteer details
            if(lstAccount.size()==0){
                RestContext.response.statusCode = 404 ; 
                return ; 
            }
            else{
                Map<String,List<sObject>> mapOutPut= 
                new Map<String,List<sObject>>();
                mapOutPut.put(
                'CampaignLocationVolunteerBORESTServiceField',lstAccount);
                //Generating JSON response using JSONHandlerMethods
                String sResponse=JSONHandlerMethods.serialize(
                mapOutPut,'CampaignLocationVolunteerBORESTServiceProcess'); 
                //Apurva - changes made to send volunteerlastlogin :"" as per INC0066016
                System.debug('@Apurva@'+ sResponse); 
                String s1 = '\"volunteerlastlogin\":\"null\"';
                String s2 = '\"volunteerlastlogin\":\"\"';
                sResponse=sResponse.replace(s1,s2);
                System.debug('@Apurva@ Final '+ sResponse); 
                RestContext.response.responseBody = Blob.valueOf(sResponse); 
                return;
            }
        }
        catch(Exception ex){
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration('500',ex.getMessage()
            +'\n'+ex.getStackTraceString(),
            'CampaignLocationVolunteerBORESTService','Integration',
            'CampaignLocationVolunteerBORESTService','Inbound Call',
            URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/apexrest/'+RestContext.request.requestURI+'?'+ 
            Utility.retrieveRESTParameters(
            RestContext.request.params.keyset()),
            UserInfo.getUserId(),'getVolunteerDetails');
        }
    }   
    @HttpPost
    global static void setVolunteerDetails() {
        try{
         /*   System.debug('@Apurva@ ' + RestContext.request.params.get(
            System.Label.volunteerid));
            System.debug('@Apurva@ ' + RestContext.request.params.get(
            System.Label.volunteeremail));
            System.debug('@Apurva@ ' + RestContext.request.params.get(
            System.Label.volunteeremailtype));
            System.debug('@Apurva@ ' + RestContext.request.params.get(
            System.Label.volunteersearchpostalcode));
            System.debug('@Apurva@ ' + RestContext.request.params.get(
            System.Label.volunteersearchradius));
            System.debug('@Apurva@ ' + RestContext.request.params.get(
            System.Label.volunteerlastlogin));*/
            String sVolunteerId= 
            RestContext.request.params.get(
            System.Label.volunteerid);
            String sVolunteerEmail= 
            RestContext.request.params.get(
            System.Label.volunteeremail);
            String sVolunteerType= 
            RestContext.request.params.get(
            System.Label.volunteeremailtype);
            String sVolunteerSearchPostalCode= 
            RestContext.request.params.get(
            System.Label.volunteersearchpostalcode); 
            String sVolunteerRadius= 
            RestContext.request.params.get(
            System.Label.volunteersearchradius); 
            String sLastLoginDate= 
            RestContext.request.params.get(
            System.Label.volunteerlastlogin);
            RestContext.response.addHeader('Content-Type', 
            'application/json');
            
            if(sVolunteerId!=null){
                Account oAccountVar=new Account(Id=sVolunteerId);
                //Forming last login date in SFDC specified format
                if(sLastLoginDate!=null){
                    String sTempVar=sLastLoginDate.replace('T',' ');
                    sTempVar=sTempVar.replace('Z','');
                    
                  
                    oAccountVar.Last_Login_Date_Time__c=
                    Datetime.valueOfGMT(sTempVar);
                    
                }
                if((sVolunteerType!=null)&&(sVolunteerEmail!=null)){
                    //Checking for specified email type.
                    if(
                    sVolunteerType.equalsIgnoreCase(System.label.Business))
                    oAccountVar.Business_Email__c=sVolunteerEmail;
                    else if(
                    sVolunteerType.equalsIgnoreCase(System.label.Work))
                    oAccountVar.Work_Email__c=sVolunteerEmail;
                    else if(
                    sVolunteerType.equalsIgnoreCase(System.label.Personal))
                    oAccountVar.Personal_Email__c=sVolunteerEmail;
                }
                if(sVolunteerType!=null){
                    //Updationg Account type
                    oAccountVar.Preferred_Email__c = sVolunteerType; 
                }
                
                if(sVolunteerSearchPostalCode!=null)
                //Updating zip code
                oAccountVar.ADV_Preferred_Zip_Code__c=
                sVolunteerSearchPostalCode;  
                if(sVolunteerRadius!=null)
                //Updating Advocate Zip Radius
                oAccountVar.ADV_Preferred_Radius__c=sVolunteerRadius; 
                
                try{
                   
                    oAccountVar.Override_Account_Validation__c=true;
                    oAccountVar.Override_Email_Validation__c=true;
                    update oAccountVar;
                    RestContext.response.statusCode = 204; 

                    return ;
                }
                catch(Exception ex){
                    RestContext.response.statusCode = 500; 
                    
                    return ;
                }  
            }
            else{
                
                RestContext.response.statusCode = 500; 
                return ;
            }
        }
        catch(Exception ex){
            
            RestContext.response.statusCode = 500 ;
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'
            +ex.getStackTraceString(),
            'CampaignLocationVolunteerBORESTService'
            ,'Integration','CampaignLocationVolunteerBORESTService'
            ,'Inbound Call',URL.getSalesforceBaseUrl().toExternalForm()
            +'/services/apexrest/'+RestContext.request.requestURI+'?'
            + Utility.retrieveRESTParameters(
            RestContext.request.params.keyset())
            ,UserInfo.getUserId(),'setVolunteerDetails');
    }     
        
    } 

}