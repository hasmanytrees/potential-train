/*******************************************************************************
Name             : SupporterCommunicationISLRestService
Description      : REST Class for retriving SBC records based on
                   invocation parameters from ISL
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                30/08/2015            Created
Sumeet                23/09/2015            Modified for code re-factoring 
                                            & optimization
*******************************************************************************/

@RestResource(urlMapping='/persons/communications/*')
global with sharing class SupporterCommunicationISLRestService
{

    /**
    * Method name  : getSBCCommunications
    * Description  : Use this method to retrieve SBC records
    *                based on the provided URL Parameters
    * Return Type  : void
    * Parameter    : void
    **/
    
    @HttpGet
    global static void getSBCCommunications() 
    {
       RestRequest request = RestContext.request;
       Map<String,String> mapParam=new Map<String,String>();
       
     
       for(String sParamName: RestContext.request.params.keySet()){
       if(RestContext.request.params.get(sParamName)!=null){
          
          if(sParamName.equalsIgnoreCase('id'))
           mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName));
           else  if(sParamName.equalsIgnoreCase('supporterid'))
           mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName));
           else  if(sParamName.equalsIgnoreCase('beneficiaryid'))
           mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName));
         else
          mapParam.put(sParamName.toLowerCase(),RestContext.request.params.get(sParamName).toLowerCase());
         }
       }  
        if( mapParam.size()>0){
            RestContext.request.params.clear();
           RestContext.request.params.putAll(mapParam);
           
           
          }
        String sQueryType= 
        RestContext.request.params.get('querytype'); 
        String sSupporterId= 
        RestContext.request.params.get('supporterid');
        String sBeneficiaryId= 
        RestContext.request.params.get('beneficiaryid'); 
        String sSBCId=
        RestContext.request.params.get('id');   
        String sCommDate= 
        RestContext.request.params.get('commdate'); 
        String sPhyreceivedDate= 
        RestContext.request.params.get('physicalreceiveddate'); 
        String sreadyforISLDate= 
        RestContext.request.params.get('readyforisldate');
        String sOrderBy= 
        RestContext.request.params.get('orderby'); 
        String sStatus= 
        RestContext.request.params.get('states');  
        String sDirection= 
        RestContext.request.params.get('direction');  
        String sSortDirection= 
        RestContext.request.params.get('sortdirection');  
        String sSkip= 
        RestContext.request.params.get('skip');  
          String sTake= 
        RestContext.request.params.get('take');  
               List<String> lstStatus=new    List<String> ();
        RestContext.response.addHeader('Content-Type', 'application/json');
        if(sOrderBy==null || sOrderBy=='')
           sOrderBy='Ready_For_ISL_Date__c';
        if(sSortDirection==null || sSortDirection=='')
           sSortDirection='desc'; 
        try{ 
            List<Account> lstAccount=new List<Account>();
            List<Correspondence_Delivery_Preference_Map__c> lstDelPref=new   List<Correspondence_Delivery_Preference_Map__c>();
            lstDelPref=Correspondence_Delivery_Preference_Map__c.getAll().values();         
            boolean bIsSupporter=false; 
            if(sSupporterId!=null && sSupporterId!=''){
                
                String sSuporterRecId=Utility.getRecordType(System.Label.SupporterRecordTypeName, System.Label.Account);
                 String sPartnerRecId=Utility.getRecordType( System.Label.PartnerRecordTypeName,System.Label.Account );

                List<Account> lstSupporters =new List<Account>();
                if(sSupporterId.length()>=15)
                lstSupporters =[select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
                Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,
                Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
                Special_Handling__c,Preferred_Name__c,Global_Id__c,BEN_Local_Id__c,
                Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
                Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c
                from Account where (Id=:sSupporterId) ];
               
               else
               lstSupporters =[select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
                Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,
                Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
                Special_Handling__c,Preferred_Name__c,Global_Id__c,BEN_Local_Id__c,
                Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
                Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c
                from Account where (Legacy_Supporter_Id__c=:sSupporterId) ];
                
                
                if(!lstSupporters.isEmpty())
                lstAccount.addAll(lstSupporters);
                bIsSupporter=true;
            }
            if(sBeneficiaryId!=null && sBeneficiaryId!=''){
                
                List<Account> lstBeneficiaries =[select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
                Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,
                Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
                Special_Handling__c,Preferred_Name__c,Global_Id__c,BEN_Local_Id__c,
                Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
                Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c
                from Account where Compass_Child_Key__c =:sBeneficiaryId or Id=:sBeneficiaryId or BEN_Local_Id__c=:sBeneficiaryId];             
                
                
                if(!lstBeneficiaries.isEmpty())
                lstAccount.addAll(lstBeneficiaries);
                bIsSupporter=false;
            }
            Map<String,Account> mapAccount=new Map<String,Account>();
            for(Account oAccountVar: lstAccount){
                
                if((oAccountVar.RecordTypeId==Utility.getRecordtype( System.Label.SupporterRecordTypeName, System.Label.Account))||((oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.PartnerRecordTypeName,System.Label.Account))))
                mapAccount.put(oAccountVar.Id,oAccountVar);
                else if(oAccountVar.RecordTypeId==Utility.getRecordtype( System.Label.BeneficiaryRecordTypeName, System.Label.Account))
                mapAccount.put(oAccountVar.Id,oAccountVar);
                
            }
            List<SBC_Communications__c> lstSBCCommFinal=new List<SBC_Communications__c>();
            SObjectType accountType = Schema.getGlobalDescribe().get
            ('SBC_Communications__c');
            Map<String,Schema.SObjectField> mapFieldSchema = 
            accountType.getDescribe().fields.getMap();
            List<String> lstFieldName=new List<String>();
            
            String sQuery='select ';
            for(String sFieldVar: mapFieldSchema.keySet())
            sQuery+=sFieldVar+',';
            
            sQuery=sQuery.subStringbeforeLast(',');
            sQuery+=' from SBC_Communications__c where Id!=null'; 
            
            if(sQueryType==system.Label.Available){
                
                for(String sFileVar: Utility.getPicklistValues(new SBC_Communications__c(),'Status__c')){
                    if(sFileVar.startsWith(system.Label.Complete) )
                    lstStatus.add(sFileVar);
                    
                }
            }
            else if(sQueryType==System.Label.Transit){
                for(String sFileVar: Utility.getPicklistValues(new SBC_Communications__c(),'Status__c'))
                {
                    if(!sFileVar.startsWith(system.Label.Complete))
                    lstStatus.add(sFileVar);                    
                }
            }
            if(sBeneficiaryId!=null && sBeneficiaryId!='')
            {  
              if(sBeneficiaryId.length()<15)
              {
                  //sQuery+=' and Beneficiary__r.Compass_Child_Key__c=\''+sBeneficiaryId+'\' ';
                  sQuery+=' and Beneficiary__r.BEN_Local_Id__c=:sBeneficiaryId ';
              }
                
              else
                 sQuery+=' and Beneficiary__c=:sBeneficiaryId ';
            }
            if(sSupporterId!=null && sSupporterId!='')
            {  
              if(sSupporterId.length()<15)
                sQuery+=' and Supporter__r.Legacy_Supporter_Id__c=:sSupporterId';
              else
                 sQuery+=' and Supporter__c=:sSupporterId';
            }
            
            
            if(sSBCId!=null && sSBCId!='')
            {
                sQuery+=' and (Id=:sSBCId or SBC_Global_Id__c=:sSBCId)';
            }
            
            if(sCommDate!=null && sCommDate!='')
            { 
                Date dtCommDate=Date.valueOf(sCommDate);
                sQuery+=' and Communication_Date__c>=:dtCommDate';
            }
            if(sPhyreceivedDate!=null && sPhyreceivedDate!='')
            {  
                Date dtPhyreceivedDate=Date.valueOf(sPhyreceivedDate);
                sQuery+=' and Date_Physical_Received__c>=:dtPhyreceivedDate';
            }
            if(sreadyforISLDate!=null && sreadyforISLDate!='')
            { 
                Date dtReadyforISLDate=Date.valueOf(sreadyforISLDate);
                sQuery+=' and Ready_For_ISL_Date__c>=:dtReadyforISLDate';
            }
            if((sStatus!=null && sStatus!='')||(lstStatus.size()>0))
            { 
                if((sQueryType==System.Label.Available)||(sQueryType==System.Label.Transit) )
                sQuery+=' and status__c IN :lstStatus';
                else
                sQuery+=' and status__c=:sStatus';
            }
            
            if(sDirection!=null && sDirection!='')
            { 
                if(sDirection.equalsIgnoreCase(System.Label.DirectionS2B))
                sDirection=Utility.getRecordType(System.Label.S2B,'SBC_Communications__c');
                else
                sDirection=Utility.getRecordType(System.Label.B2S,'SBC_Communications__c');
                sQuery+=' and recordTypeId=:sDirection';
            }
            if(sQueryType==System.Label.read){
            
               sQuery+=' and Read__c=true';
            
            }
            else if(sQueryType==System.Label.Unread){
            
               sQuery+=' and Read__c=false';
            
            }
            if(sOrderBy!=null && sOrderBy!='')
            { 
                sQuery+=' order by '+sOrderBy;
                
            }
            else
            { 
                sQuery+=' order by Communication_Date__c';
                
            }
            if(sSortDirection!=null && sSortDirection!='')
            {
                sQuery+=' '+sSortDirection;
                
            }
            else
            { 
                sQuery+=' ASC';
            }
             if(sTake!=null && sTake!=''){
            
                  Integer iLimit=Integer.valueOf(sTake);
                  if ( iLimit < 100) 
                  sQuery+=' Limit :iLimit';
                  else
                  sQuery+=' Limit 100';
            
            }
            else{
                sQuery+=' Limit 20';
            }
            if(sSkip !=null && sSkip!=''){
            
              Integer  iOffset=Integer.valueOf(sSkip );
              sQuery+=' offset :iOffset';
            
            }
           
            List<SBC_Communications__c > lstSBCComm=new List<SBC_Communications__c >();
            lstSBCComm=(List<SBC_Communications__c >)Database.query(String.escapeSingleQuotes(sQuery));
            Set<String> setSupporterId =new Set<String>();
            for(SBC_Communications__c oSBCVar: lstSBCComm)
            {
                setSupporterId.add(oSBCVar.Supporter__c);
            }
            if(!bIsSupporter) 
            {
                lstAccount=[select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,
                C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
                Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,
                BillingCountry,BillingStreet,BillingPostalCode,Global_ID__c,
                Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,
                RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
                Special_Handling__c,Preferred_Name__c,
                Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,
                ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
                Preferred_Address__c,Undeliverable_Invalid__c,
                Do_Not_Mail__c,Correspondence_Delivery_Preference__c
                from Account where  Id IN :setSupporterId];
            }
            mapAccount=new Map<String,Account>();
            for(Account oAccountVar: lstAccount)
            {                
                if((oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.SupporterRecordTypeName,System.Label.Account))
                ||((oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.PartnerRecordTypeName,System.Label.Account))))
                mapAccount.put(oAccountVar.Id,oAccountVar);
                else if(oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.BeneficiaryRecordTypeName,System.Label.Account))
                mapAccount.put(oAccountVar.Id,oAccountVar);
                
            }
            List<SBCCommunicationDetailsList.SBCCommunicationDetails> lstSBCCommWrp=new List<SBCCommunicationDetailsList.SBCCommunicationDetails> ();
            Set<String> setBenificiaryId=new Set<String>();
            for(SBC_Communications__c  oSBCVar: lstSBCComm )
            {  
               if(oSBCVar.Beneficiary__c!=null)
                setBenificiaryId.add(oSBCVar.Beneficiary__c);
            }
              lstAccount=[select Id,Account_Full_Name__c,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
                Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,
                Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
                Special_Handling__c,Preferred_Name__c,Global_Id__c,BEN_Local_Id__c,Gender__c,BEN_Age__c,BEN_Id__c,ICP__c,
                Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
                Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c
                from Account where  Id IN :setBenificiaryId];
              
           
            for(Account oAccountVar: lstAccount){
                
              
                mapAccount.put(oAccountVar.Id,oAccountVar);
                
            }
           Map<Id,SBC_Communications__c> mapSBCComm=new Map<Id,SBC_Communications__c>();
            for(SBC_Communications__c  oSBCVar: lstSBCComm )
            {
                 SBCCommunicationDetailsList.SBCCommunicationDetails svcVar=new SBCCommunicationDetailsList.SBCCommunicationDetails ();
                mapSBCComm.put(oSBCVar.Id,oSBCVar);
                svcVar.IsFinalLetter=oSBCVar.Final_Letter__c;
                svcVar.IsFinalLetterArchived=oSBCVar.Final_Letter_Archived__c;
                svcVar.FinalLetterURL=oSBCVar.Final_Letter_URL__c;
                svcVar.Font=oSBCVar.Font__c;
                svcVar.FontSize=(oSBCVar.Font_Size__c!=null)?Integer.valueOf(oSBCVar.Font_Size__c):0;
                svcVar.CompassionSBCId=oSBCVar.SBC_Global_Id__c;
                svcVar.GlobalPartnerSBCId=oSBCVar.Name;
                svcVar.ItemNotScannedEligible=oSBCVar.Gift_Not_Scanned_Eligible__c;
                svcVar.ItemNotScannedNotEligible=oSBCVar.Gift_Not_Scanned_Not_Eligible__c;
                svcVar.OriginalLanguage=oSBCVar.Original_Language__c;
                svcVar.IsOriginalLetterArchived=oSBCVar.Original_Letter_Archived__c;
                svcVar.OriginalLetterURL=oSBCVar.Original_Letter_URL__c;
                svcVar.OriginalText=oSBCVar.Original_Text__c;
                
                if(oSBCVar.Number_Of_Pages__c!=null)
                svcVar.NumberOfPages=oSBCVar.Number_Of_Pages__c.intvalue();
                
                if(svcVar.DatePhysicalReceived!=null){                      
                    
               if(svcVar.DatePhysicalReceived.contains('T')){       
                 svcVar.DatePhysicalReceived=svcVar.DatePhysicalReceived.replaceAll('T',' ');       
                  svcVar.DatePhysicalReceived=svcVar.DatePhysicalReceived.subStringBeforelast('Z');     
                   oSBCVar.Date_Physical_Received__c=  Date.valueOf(svcVar.DatePhysicalReceived);       
                }       
                    
                    
                    
            }
                if(oSBCVar.Correspondence_Type__c!=null) 
                svcvar.RelationshipType=oSBCVar.Correspondence_Type__c.subStringBefore(' ');
               
               if( oSBCVar.Template_ID__c!=null)
                 svcVar.Template=  oSBCVar.Template_ID__c;
                else
                svcVar.Template='BO-A-1S21-1'; /*For Testing Purpose */
                svcVar.Internal_Perceptive_TransactionId =oSBCVar.Transaction_ID__c;
                svcVar.TranslatedText=oSBCVar.Translated_Text__c;
                svcVar.SBCGlobalStatus =oSBCVar.Status__c;
                svcVar.TranslationLanguage=oSBCVar.Translation_Language__c;
                //svcVar.Read=oSBCVar.Read__c;
                oSBCVar.Read__c=false;
                svcVar.GlobalPartner_GlobalPartnerId =System.Label.US;
                svcVar.Direction=oSBCVar.Communication_Direction__c;
                svcVar.RelationshipType=System.Label.Sponsor;
                svcVar.Supporter_CommunicationDeliveryPreference=oSBCVar.Final_Delivery_Preference__c;
                if(mapAccount.get(oSBCVar.Supporter__c)!=null){
                    svcVar.Supporter_CompassConstituentId =(mapAccount.get(oSBCVar.Supporter__c)).Legacy_Supporter_Id__c;
                    svcVar.Supporter_GlobalId=(mapAccount.get(oSBCVar.Supporter__c)).Global_Id__c;
                  //  svcVar.Supporter_MandatoryReviewRequired=(mapAccount.get(oSBCVar.Supporter__c)).Special_Handling__c;
                    svcVar.Supporter_PreferredName=(mapAccount.get(oSBCVar.Supporter__c)).Preferred_Name__c;
                    for(Correspondence_Delivery_Preference_Map__c oCorrDelvar: lstDelPref){
                        
                        if(svcVar.Supporter_CommunicationDeliveryPreference!=null && oCorrDelvar.Preference__c.equalsIgnoreCase(svcVar.Supporter_CommunicationDeliveryPreference))
                        svcVar.Supporter_CommunicationDeliveryPreference=oCorrDelvar.Mapped_Delivery_Preference__c;
                    }
                    
                    
                }
                if(mapAccount.get(oSBCVar.Beneficiary__c)!=null){
                    svcVar.Beneficiary_CompassId=(mapAccount.get(oSBCVar.Beneficiary__c)).Compass_Child_Key__c;
                    svcVar.Beneficiary_Name=(mapAccount.get(oSBCVar.Beneficiary__c)).Account_Full_NAme__c;
                    svcVar.Beneficiary_Gender=(mapAccount.get(oSBCVar.Beneficiary__c)).Gender__c;
                    svcVar.ICP_Id=(mapAccount.get(oSBCVar.Beneficiary__c)).ICP__c;
                    svcVar.Beneficiary_LocalId=(mapAccount.get(oSBCVar.Beneficiary__c)).BEN_Local_Id__c;
                    svcVar.Beneficiary_GlobalId=(mapAccount.get(oSBCVar.Beneficiary__c)).BEN_Id__c;
                    svcVar.Beneficiary_Age=String.valueOf((mapAccount.get(oSBCVar.Beneficiary__c)).BEN_Age__c);
                    
                }
                svcVar.SourceSystem=System.Label.SourceSystem;
                svcVar.IsMarkedForRework=false;
                svcVar.ReasonForRework=System.Label.None;
                
                if(svcVar.SBCTypes!=null){ 
                    for(String sCommTypeVar: svcVar.SBCTypes){
                        if(sCommTypeVar.equalsIgnoreCase(System.Label.Final_Thank_You)){
                            oSBCVar.Final_Letter__c=true;
                            svcVar.IsFinalLetter=oSBCVar.Final_Letter__c;
                        }
                    }    
                }
                else{
                    svcVar.SBCTypes=new List<String>();
                }
                svcVar.GlobalPartnerSBCId=oSBCVar.Id;
                Boolean bIsViaEmail=false;
                Boolean bIsViaMail=false;
                if(mapAccount.get(oSBCVar.Supporter__c)!=null){
                    
                    //Setting Supporter Email
                    if(oSBCVar.Supporter__c!=null){
                        Account oAccountVar=mapAccount.get(oSBCVar.Supporter__c);
                        if(oAccountVar.Preferred_Email__c!=null){
                            if(oAccountVar.Preferred_Email__c== System.Label.Business)
                            svcVar.Internal_Supporter_PersonalEmail=oAccountVar.Business_Email__c;
                            else if(oAccountVar.Preferred_Email__c== System.Label.Personal)
                            svcVar.Internal_Supporter_PersonalEmail=oAccountVar.Personal_Email__c; 
                            else if(oAccountVar.Preferred_Email__c==System.Label.Work)
                            svcVar.Internal_Supporter_PersonalEmail=oAccountVar.Work_Email__c; 
                            bIsViaEmail=true;
                        }
                        //Setting Supporter Address
                        if(oAccountVar.Preferred_Address__c!=null){
                            if(oAccountVar.Preferred_Address__c==System.Label.Mailing){
                                svcVar.Internal_Supporter_InCareOfMailingAddress=oAccountVar.C_O_Mailing_Address__c;
                                svcVar.Internal_Supporter_MailingStreet1=oAccountVar.Mailing_Street__c;
                                svcVar.Internal_Supporter_MailingCity=oAccountVar.Mailing_City__c;
                                svcVar.Internal_Supporter_MailingCountryDivision=oAccountVar.Mailing_State_Province__c;
                                svcVar.Internal_Supporter_MailingPostalCode=oAccountVar.Mailing_Zip_Postal_Code__c;
                                svcVar.Internal_Supporter_MailingCountry=oAccountVar.Mailing_Country__c;
                            }
                            else  if(oAccountVar.Preferred_Address__c==System.Label.Bill_To){
                                svcVar.Internal_Supporter_InCareOfMailingAddress=oAccountVar.C_O_Biling_Address__c;
                                svcVar.Internal_Supporter_MailingStreet1=oAccountVar.BillingStreet;
                                svcVar.Internal_Supporter_MailingCity=oAccountVar.BillingCity;
                                svcVar.Internal_Supporter_MailingCountryDivision=oAccountVar.BillingState;
                                svcVar.Internal_Supporter_MailingPostalCode=oAccountVar.BillingPostalCode;
                                svcVar.Internal_Supporter_MailingCountry=oAccountVar.BillingState;
                            }
                            else  if(oAccountVar.Preferred_Address__c==System.Label.Physical){
                                svcVar.Internal_Supporter_InCareOfMailingAddress=oAccountVar.C_O_Physical_Address__c;
                                svcVar.Internal_Supporter_MailingStreet1=oAccountVar.ShippingStreet;
                                svcVar.Internal_Supporter_MailingCity=oAccountVar.ShippingCity;
                                svcVar.Internal_Supporter_MailingCountryDivision=oAccountVar.ShippingState;
                                svcVar.Internal_Supporter_MailingPostalCode=oAccountVar.ShippingPostalCode;
                                svcVar.Internal_Supporter_MailingCountry=oAccountVar.ShippingCountry;
                            } 
                            bIsViaMail=true;
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                if(bIsViaEmail && bIsViaMail)
                svcVar.Internal_Supporter_CommunicationMethod=System.Label.Both;
                else if(bIsViaEmail )
                svcVar.Internal_Supporter_CommunicationMethod=System.Label.Email;
                else if(bIsViaMail )
                svcVar.Internal_Supporter_CommunicationMethod=System.Label.Mail;
                else
                svcVar.Internal_Supporter_CommunicationMethod=System.Label.None;
                
                
                lstSBCCommWrp.add(svcVar);
                
                
            }
            
            
            if((sQueryType==System.Label.Search)||(sQueryType==System.Label.Available)||(sQueryType==System.Label.Transit)||(sQueryType==System.Label.read) || (sQueryType==System.Label.Unread))
            {      
               SBCCommunicationDetailsList.SBCCommunicationDetailsFin sbcList=new SBCCommunicationDetailsList.SBCCommunicationDetailsFin (lstSBCCommWrp);
                if(lstSBCCommWrp.size()>0)
                {
                    String sResponse=JSON.serialize(sbcList);
                    sResponse=addFieldsOnJSON(sResponse,mapSBCComm);
                    //Added by Apurva removeFieldsfromJSON(sResponse)
                    sResponse=removeFieldsfromJSON(sResponse);
                    RestContext.response.responseBody = Blob.valueOf(sResponse);
                    
                }
                else{
                      
                        RestContext.response.statusCode = 200; 
                        return;
                    
                        
                  }
            }
            
            else if(sQueryType==System.Label.Details)
            {
                
                if(lstSBCCommWrp.size()==1)
                {
                    SBCCommunicationDetailsList.SBCCommunicationDetailsFin sbcList=new SBCCommunicationDetailsList.SBCCommunicationDetailsFin (lstSBCCommWrp);
                    //  SBCCommunicationDetailsList sbcList=new SBCCommunicationDetailsList ();
                    String sResponse=JSON.serialize(sbcList);
                      
                      sResponse=addFieldsOnJSON(sResponse,mapSBCComm);
                      //Added by Apurva removeFieldsfromJSON(sResponse)
                    sResponse=removeFieldsfromJSON(sResponse);
                    RestContext.response.responseBody = Blob.valueOf(sResponse);
                    
                }
                else if(lstSBCCommWrp.size()==0) {
                    RestContext.response.statusCode = 200; 
                    return;
                    }
                else if(lstSBCCommWrp.size()>1) {
                    // 1st 3 lines added by jeevan
                    SBCCommunicationDetailsList.SBCCommunicationDetailsFin sbcList=new SBCCommunicationDetailsList.SBCCommunicationDetailsFin (lstSBCCommWrp);
                    //  SBCCommunicationDetailsList sbcList=new SBCCommunicationDetailsList ();
                    String sResponse=JSON.serialize(sbcList);
                    
                      sResponse=addFieldsOnJSON(sResponse,mapSBCComm);
                    //Added by Apurva removeFieldsfromJSON(sResponse)
                    sResponse=removeFieldsfromJSON(sResponse);
                    RestContext.response.responseBody = Blob.valueOf(sResponse);
                    RestContext.response.statusCode = 200; 
                     return;
                    }
                    
                
                if(sSBCId==null || sSBCId=='')
                {
                    RestContext.response.statusCode = 200; 
                    return ;
                }
            }
            else if(sQueryType==System.Label.History)
            {
                
                if(sSBCId==null || sSBCId=='')
                {
                    RestContext.response.statusCode = 404; 
                    return ;
                }
                List<SBC_Communications__History> lstSBCHistory=new  List<SBC_Communications__History>();
                List<SBC_Communications__History> lstSBCHistoryFinal=new  List<SBC_Communications__History>();
                List<SBC_Communications__History> lstSBCHistoryFinal2=new  List<SBC_Communications__History>();     
                List<Account> lstHistoryMapperAccount=new List<Account>();
                lstSBCHistory=[select Id,NewValue,Field,CreatedDate from SBC_Communications__History
                where parentId=:sSBCId and (Field='Status__c' or Field='created') order by CreatedDate]; 
                
                if(lstSBCHistory.size()==0)
                { 
                    RestContext.response.statusCode = 404; 
                    return ;
                } 
                
                for(SBC_Communications__History oSBCHistory: lstSBCHistory){        
                                        
                 Account ohistoryVar=new Account ();        
                  if(oSBCHistory.Field=='created')      
                        ohistoryVar.Status__c='Created';        
                   else{        
                     if(oSBCHistory.Newvalue!=null)     
                       ohistoryVar.Status__c= String.valueOf(oSBCHistory.Newvalue);     
                        
                        
                   }        
                    ohistoryVar.Account_Start_Date__c=oSBCHistory.CreatedDate;      
                    lstHistoryMapperAccount.add(ohistoryVar);       
                        
                }
                
                Map<String,List<sObject>> mapOutput=new  Map<String,List<sObject>>();               
                mapOutput.put('SupporterCommunicationHistoryGroup',lstHistoryMapperAccount);                
                String sResponse=
                JSONHandlerMethods.serialize(mapOutput,
                'SupporterCommunicationHistoryProcess'); 
                sResponse=sResponse.replace('"null"', 'null');
                
                // Sending the response back
                RestContext.response.responseBody = Blob.valueOf(sResponse);                 
            } 
            if(sQueryType== System.Label.Summary )
            {  
                SBC_Communications__c oSBCVar=new SBC_Communications__c(Status__c=String.valueOf(lstSBCCommWrp.size()));
                Map<String,List<sObject>> mapOutput=new  Map<String,List<sObject>>();               
                mapOutput.put('SupporterCommunicationSummaryGroup',new List<SBC_Communications__c>{oSBCVar});                
                String sResponse=
                JSONHandlerMethods.serialize(mapOutput,
                'SupporterCommunicationSummaryProcess'); 
                sResponse=sResponse.replace('"null"', 'null');
               
                // Sending the response back
                RestContext.response.responseBody = Blob.valueOf(sResponse);           
                
            }  
            
        }
        catch(Exception ex)
        {
            RestContext.response.statusCode = 500 ; 
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'SupporterCommunicationISLRestService\\'+sQueryType,'Integration',
            'SupporterCommunicationISLRestService','Insert Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'SupporterCommunicationISLRestService');
            RestContext.response.responseBody = Blob.valueOf(ex.getMessage()+ex.getLineNumber());  
        } 
        
        
    }
    
    /**
    * Method name  : createSBCComm
    * Description  : Use this method to create SBC record
    *                based on the provided JSON
    * Return Type  : void
    * Parameter    : JSON
    **/
    
    @Httppost
    global static void createSBCComm() 
    {
        RestRequest request = RestContext.request;
        
        try
        { 
            String sResponse=CreateSBCCommunicationRESTServices.performSBCInsert('ISL',request.requestBody.toString());
            RestContext.response.statusCode = 201 ; 
              RestContext.response.responseBody = Blob.valueOf(sResponse);           
                
            
            return;
        }
        catch(Exception ex)
        {            
            RestContext.response.statusCode = 500 ; 
            Utility.insertErrorLogIntegration('500',ex.getMessage()+'\n'+
            ex.getStackTraceString(),'SupporterCommunicationISLRestService\\create','Integration',
            'SupporterCommunicationISLRestService','Insert Call',
            request.requestBody.toString().trim(),UserInfo.getUserId(),
            'createSBCComm');
            
        } 
    }
   private static String addFieldsOnJSON(String sResponse,Map<Id,SBC_Communications__c> mapSBCComm){
   
        sResponse=sResponse.replaceAll('\n','');
       String sTempResponse=sResponse;
                    
                    while(sTempResponse.contains('}') && sTempResponse.contains('GlobalPartnerSBCId') ){
                    
                    
                     String  sJSONStr=sTempResponse.subStringBetween('{','},');
                     if(sJSONStr==null)
                       sJSONStr=sTempResponse.subStringBetween('{','}');
                     String sJSONStrCopy=sJSONStr;
                      String  sSBCVarId=sJSONStrCopy.subStringAfter('"GlobalPartnerSBCId":"');
                    sSBCVarId=sSBCVarId.subStringBefore('",');
                         if(mapSBCComm.get(sSBCVarId)!=null){
                         
                           SBC_communications__c oSBCVar=mapSBCComm.get(sSBCVarId);
                         
                         if(oSBCVar.Ready_For_ISL_Date__c!=null){
                         
                             String sDateStr=(String.valueOf(oSBCVar.Ready_For_ISL_Date__c))+' 00:00:00';
                             sDateStr=sDateStr+'Z';
                             sDateStr=sDateStr.replaceAll(' ','T');
                           sJSONStrCopy+=',"ReadyForISLDate" :"'+sDateStr+'",';
                           
                           }else
                              sJSONStrCopy+=',"ReadyForISLDate" :null,';   
                          if(oSBCVar.CreatedDate!=null){
                         
                             String sDateStr=String.valueOf(oSBCVar.CreatedDate);
                             sDateStr=sDateStr+'Z';
                             sDateStr=sDateStr.replaceAll(' ','T');
                           sJSONStrCopy+='"CreatedDate":"'+sDateStr+'",';
                           
                           }
                         sJSONStrCopy=sJSONStrCopy.subStringBeforeLast(',');
                         
                         
                         
                         }
                       sResponse=sResponse.replace(sJSONStr,sJSONStrCopy);
                       sTempResponse=sTempResponse.subStringAfter('},');
                    }
 
   return sResponse;

   }
   
   /**
    * Method name  : removeFieldsfromJSON
    * Description  : Use this method to remove token not required 
                     while invoking from ISL
    * Return Type  : String
    * Parameter    : String
    **/
   //Apurva - Added new function
   private static String removeFieldsfromJSON(String sResponse){ 
       String sTempResponse=sResponse;

        while(sTempResponse.contains('}') && sTempResponse.contains('GlobalPartnerSBCId') ){
          String  sJSONStr=sTempResponse.subStringBetween('{','},');
          if(sJSONStr==null)
               sJSONStr=sTempResponse.subStringBetween('{','}');  
            
            String sJSONStrCopy=sJSONStr;
            if(sJSONStrCopy.contains('"Internal_Perceptive_SequenceNumber"')){
                String  sSBCSequenceVarId=sJSONStrCopy.subStringAfter('"Internal_Perceptive_SequenceNumber"');
                String sTemp ='';
                if(sSBCSequenceVarId.contains(',')){
                    sSBCSequenceVarId=sSBCSequenceVarId.subStringBefore('",');
                    sTemp = '"Internal_Perceptive_SequenceNumber"'+sSBCSequenceVarId+'",';
                }
                else{
                    sSBCSequenceVarId=sSBCSequenceVarId.subStringBefore('"');
                    sTemp = '"Internal_Perceptive_SequenceNumber"'+sSBCSequenceVarId+'"';
                    
                }
                
                if(sTemp!=''){ 
                    sJSONStrCopy=sJSONStrCopy.replace(sTemp,'');
                }    
            }  
            if(sJSONStrCopy.contains('"Internal_Perceptive_BatchId"')){
                String  sSBCBatchVarId=sJSONStrCopy.subStringAfter('"Internal_Perceptive_BatchId"');
                String sTemp ='';
                if(sSBCBatchVarId.contains(',')){
                    sSBCBatchVarId=sSBCBatchVarId.subStringBefore('",');
                    sTemp = '"Internal_Perceptive_BatchId"'+sSBCBatchVarId+'",';
                }
                else{
                    sSBCBatchVarId=sSBCBatchVarId.subStringBefore('"');
                    sTemp = '"Internal_Perceptive_BatchId"'+sSBCBatchVarId+'"';
                }
                if(sTemp!=''){    
                    sJSONStrCopy=sJSONStrCopy.replace(sTemp,'');
                }    
            }  
            sResponse=sResponse.replace(sJSONStr,sJSONStrCopy);
            sTempResponse=sTempResponse.subStringAfter('},');
           
        }

   
       return sResponse;
   }
}