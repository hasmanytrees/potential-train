/******************************************************************************
Name             : GenerateJSONForSBCCommunicationToCI
Description      : This class is used to generate JSON to be send to SFDC CI for S2B scenario.               
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/8/2015            Modified for code re-factoring 
                                            & optimization
****************************************************************************/                                             
public class GenerateJSONForSBCCommunicationToCI
{
    /**
    * Method name  : generateJSONForCI
    * Description  : Use this method to generate JSON string of SBC   
                     object records for sending as response  
    *                to other systems.
    * Return Type  : String
    * Parameter    : Set<Id>,Boolean
    **/  

    public Static String generateJSONForCI(Set<Id> setSBCId,Boolean bIsXMPIE)
    {
        String sResponse;
        Map<String,String> mapCIUSAStatusValues = new Map<String,String>();
        for(CI_To_USA_Integration_Value_Mapping__c oMapVar : CI_To_USA_Integration_Value_Mapping__c.getAll().values())
        {
            String sUniqueKey = oMapVar.US_Value__c + '' + oMapVar.Direction_c__c;
            if(mapCIUSAStatusValues <> null && !mapCIUSAStatusValues.containsKey(sUniqueKey) && oMapVar.CI_Value__c!='Received')
            mapCIUSAStatusValues.put(sUniqueKey, oMapVar.CI_Value__c);
        }
        
        
        try{
            
            Map<String,Account> mapAccount=new Map<String,Account>();
            List<SBC_Communications__c> lstSBCCommFinal=new List<SBC_Communications__c>();
            SObjectType accountType = Schema.getGlobalDescribe().get
            (System.Label.SBCCommunicationObject);
            
            Map<String,Schema.SObjectField> mapFieldSchema = 
            accountType.getDescribe().fields.getMap();
            List<String> lstFieldName=new List<String>();
            
            String sQuery='select ';
            for(String sFieldVar: mapFieldSchema.keySet())
            sQuery+=sFieldVar+',';
            
            sQuery=sQuery.subStringbeforeLast(',');
            sQuery+=' from SBC_Communications__c where Id IN :setSBCId'; 
            List<SBC_Communications__c > lstSBCComm=new List<SBC_Communications__c >();
            lstSBCComm=(List<SBC_Communications__c >)Database.query(String.escapeSingleQuotes(sQuery));
            Set<Id> setSupporterId =new Set<Id>();
            for(SBC_Communications__c oSBCVar: lstSBCComm){
                setSupporterId.add(oSBCVar.Supporter__c);
                setSupporterId.add(oSBCVar.Beneficiary__c); 
            }
            List<Account> lstAccount=new List<Account>();
            List<Correspondence_Delivery_Preference_Map__c> lstDelPref=new   List<Correspondence_Delivery_Preference_Map__c>();
            lstDelPref=Correspondence_Delivery_Preference_Map__c.getAll().values();         
            boolean bIsSupporter=false; 
            
            

            
            lstAccount=[select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,C_O_Biling_Address__c,C_O_Mailing_Address__c,C_O_Physical_Address__c,
            Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,Global_Id__c,
            Preferred_Email_Address__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c,RecordTypeId,Compass_Child_Key__c,Legacy_Supporter_Id__c,
            Special_Handling__c,Preferred_Name__c,Account_Full_NAme__c,BEN_Age__c,ICP__c,BEN_Global_Id__c,BEN_Local_Id__c,BEN_Id__c,Gender__c,
            Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,ShippingStreet,ShippingPostalCode,
            Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c , Primary_Language__c
            from Account where  Id IN :setSupporterId ];
            
            
            for(Account oAccountVar: lstAccount){
                
                if((oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.SupporterRecordTypeName,System.Label.Account))||((oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.PartnerRecordTypeName,System.Label.Account))))
                mapAccount.put(oAccountVar.Id,oAccountVar);
                else if(oAccountVar.RecordTypeId==Utility.getRecordtype(System.Label.BeneficiaryRecordTypeName,System.Label.Account))
                mapAccount.put(oAccountVar.Id,oAccountVar);
                
            }
            
            
            
            //Settig Values
            List<SBCCommunicationDetailsList.SBCCommunicationDetails> lstSBCCommWrp=new List<SBCCommunicationDetailsList.SBCCommunicationDetails> ();
            
            for(SBC_Communications__c  oSBCVar: lstSBCComm ){
                SBCCommunicationDetailsList.SBCCommunicationDetails svcVar=new SBCCommunicationDetailsList.SBCCommunicationDetails ();
                svcVar.IsDatePhysicalReceived = false;
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
                if(oSBCVar.Number_Of_Pages__c <> null)
                svcVar.NumberOfPages = oSBCVar.Number_Of_Pages__c.intValue();
                
                if(oSBCVar.Correspondence_Type__c!=null) 
                svcvar.RelationshipType=oSBCVar.Correspondence_Type__c.subStringBefore(' ');
                String sDirection = String.valueOf(oSBCVar.Communication_Direction__c);
                String sKey = oSBCVar.Status__c + '' + sDirection;
                  if(!bIsXMPIE)
                {
                    svcVar.SBCGlobalStatus= System.Label.ReceivedInSystem/*mapCIUSAStatusValues.get(sKey)*/;
                }
                else
                {
                    svcVar.SBCGlobalStatus=oSBCVar.Status__c;
                    if(svcVar.SBCGlobalStatus == null || svcVar.SBCGlobalStatus == '')
                    {
                          sKey='Received'+''+ sDirection;
                          
                     }
                     svcVar.SBCGlobalStatus=mapCIUSAStatusValues.get(sKey);
                     svcVar.Exception_Insert = oSBCVar.Exception_Insert__c;
                     if(oSBCVar.Date_Physical_Received__c <> null)      
                     {       
                        svcVar.IsDatePhysicalReceived = true;       
                        svcVar.DatePhysicalReceived = String.valueOf(oSBCVar.Date_Physical_Received__c);        
                     }       
                     else        
                     {       
                        svcVar.IsDatePhysicalReceived = false;      
                     }
                }
                 if(oSBCVar.Exception_Reason__c == System.Label.PastCommunicationIssues)
                {
                    svcVar.Supporter_MandatoryReviewRequired =  true;
                }
                //[select CI_Value__c from CI_To_USA_Integration_Value_Mapping__c where US_Value__c = :oSBCVar.Status__c and Direction_c__c = :sDirection limit 1].CI_Value__c;
                
                if( oSBCVar.Template_ID__c!=null)
                 svcVar.Template=  oSBCVar.Template_ID__c;
                else
                svcVar.Template='BO-A-1S21-1'; /*For Testing Purpose */
                svcVar.Internal_Perceptive_TransactionId=oSBCVar.Transaction_ID__c;
                svcVar.TranslatedText=oSBCVar.Translated_Text__c;
                svcVar.TranslationLanguage=oSBCVar.Translation_Language__c;
                //svcVar.Read=oSBCVar.Read__c;
                oSBCVar.Read__c=false;
                svcVar.Direction=oSBCVar.Communication_Direction__c;
             //   svcVar.RelationshipType=System.Label.Sponsor;
                svcVar.Supporter_CommunicationDeliveryPreference=oSBCVar.Final_Delivery_Preference__c;
                if(mapAccount.get(oSBCVar.Supporter__c)!=null){
                    if(mapAccount.get(oSBCVar.Supporter__c).Primary_Language__c==null){           
                        svcVar.OriginalLanguage='English';            
                     }
                    svcVar.Supporter_CompassConstituentId =(mapAccount.get(oSBCVar.Supporter__c)).Legacy_Supporter_Id__c;
                    svcVar.Supporter_GlobalId=(mapAccount.get(oSBCVar.Supporter__c)).Global_Id__c;
                   if(bIsXMPIE)        
                   {        
                    svcVar.Supporter_CompassConstituentId =oSBCVar.Id;      
                    svcVar.CompassionSBCId=(mapAccount.get(oSBCVar.Supporter__c)).Id;       
                   }
                //    svcVar.Supporter_MandatoryReviewRequired=(mapAccount.get(oSBCVar.Supporter__c)).Special_Handling__c;
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
                    // svcVar.FieldOffice_Name=(mapAccount.get(oSBCVar.Beneficiary__c)).ICP__c;
                    svcVar.Beneficiary_LocalId=(mapAccount.get(oSBCVar.Beneficiary__c)).BEN_Local_Id__c;
                    svcVar.Beneficiary_GlobalId=(mapAccount.get(oSBCVar.Beneficiary__c)).BEN_Id__c;
                    svcVar.Beneficiary_Age=String.valueOf((mapAccount.get(oSBCVar.Beneficiary__c)).BEN_Age__c);
                    
                }
                svcVar.SourceSystem= System.Label.SourceSystem;
                svcVar.SBCTypes =new List<String>();
                svcVar.IsMarkedForRework=false;
                
                
                if(svcVar.SBCTypes!=null){
                    for(String sCommTypeVar: svcVar.SBCTypes){
                        if(sCommTypeVar.equalsIgnoreCase(System.Label.Final_Thank_You)){
                            oSBCVar.Final_Letter__c=true;
                            svcVar.IsFinalLetter=oSBCVar.Final_Letter__c;
                        }
                    }
                    
                    
                }
                //svcVar.GlobalPartnerSBCId=oSBCVar.Id;
                Boolean bIsViaEmail=false;
                Boolean bIsViaMail=false;
                if(mapAccount.get(oSBCVar.Supporter__c)!=null){
                    
                    //Setting Supporter Email
                    if(oSBCVar.Supporter__c!=null){
                        Account oAccountVar=mapAccount.get(oSBCVar.Supporter__c);
                        if(oAccountVar.Preferred_Email__c!=null){
                            if(oAccountVar.Preferred_Email__c==System.Label.Business)
                            svcVar.Internal_Supporter_PersonalEmail=oAccountVar.Business_Email__c;
                            else if(oAccountVar.Preferred_Email__c==System.Label.Personal)
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
            
            SBCCommunicationDetailsList.SBCCommunicationDetailsFin sbcList=new SBCCommunicationDetailsList.SBCCommunicationDetailsFin (lstSBCCommWrp);
            
            if(lstSBCCommWrp.size()>0){
                
                sResponse=JSON.serialize(sbcList);  // Generating JSON
                
                
                
            }
            

            
        }
        catch(Exception ex){
            
            System.debug('#####'+ex+ex.getStackTraceString());
            
            
        }
        
        return sResponse;
    }
}