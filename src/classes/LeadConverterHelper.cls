/*******************************************************************************
    Name             : LeadConverterHelper
    Description      : This class is used to convert Lead using custom
                    conversion process including deleting contact on Lead 
                    creation and associating Origin of event for Campaign               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring &
                                            optimization
*******************************************************************************/
Global without Sharing class LeadConverterHelper{
    /**
    * Method name  : convertLeadCustom
    * Description  : Use this method for custom conversion process including 
                    deleting contact on Lead creation and associating Origin of
                    event for Campaign     
    *                
    * Return Type  : Id , boolean
    * Parameter    : String
    **/  
    webservice static String convertLeadCustom
    (Id leadId,boolean bIsCreateOpportunity){
        try{
            Utility.bIsSourceFromLead=true;
            Lead leadTobeConverted=[select Id,FirstName,LastName,Salutation,Name,
            Country,Origin_Source_Code__c,Metro_Area__c,
            Metro_State__c,Street,State,City,PostalCode,
            Campaign_Event__c,Email,Phone,Lead_Type__c,
            (Select Id,WhoId,WhatId from Tasks),
            (Select Id,WhoId,WhatId from Events),
            (Select Id,Lead__c,Account__c from 
            Communication__r)
            from Lead where Id=:leadId];
            // Getting Lead Information
            List<Task> lstTask=new   List<Task> ();
            List<Event> lstEvent=new List<Event>();
            List<Communication__c> lstComm=new List<Communication__c>();
            List<Attachment> lstAttachment=new List<Attachment>();
            List<Note> lstNotesDelete=new List<Note>();
            List<Attachment> lstAttachmentDelete=new List<Attachment>();
            List<Note> lstNotes=new List<Note>();
            lstNotesDelete=[Select  ParentId, OwnerId,Title,  
            LastModifiedDate, LastModifiedById, 
            Id,Body From Note where parentId=:leadId];
            lstAttachmentDelete=[Select  ParentId, OwnerId, Name, 
            LastModifiedDate, LastModifiedById, 
            Id, Description, ContentType, 
            BodyLength, Body From Attachment where 
            ParentId=:leadId];
            for(Task oTaskVar: leadTobeConverted.Tasks){
                oTaskVar.WhoId=null;
                lstTask.add(oTaskVar) ;     
            }
            for(Event oEventVar: leadTobeConverted.Events){
                oEventVar.WhoId=null;
                lstEvent.add(oEventVar) ;     
            }
            for(Communication__c oCommVar: leadTobeConverted.Communication__r){
                oCommVar.Lead__c=null;
                lstComm.add(oCommVar);
            }
            if(lstEvent.size()>0)
            update lstEvent;
            if(lstTask.size()>0)
            update lstTask;
            if(lstComm.size()>0)
            update lstComm;
            if(lstAttachment.size()>0)
            delete lstAttachmentDelete;
            if(lstNotesDelete.size()>0)
            delete lstNotesDelete;
            Id eventId=leadTobeConverted.Campaign_Event__c ;
            String sLeadType=leadTobeConverted.Lead_Type__c ;
           
            List<Partner_Type__c> lstPartnerType=new List<Partner_Type__c>();
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(leadId);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus 
            WHERE IsConverted=true LIMIT 1]; //Getting Lead Convert Status
            leadConvert.setConvertedStatus(convertStatus.MasterLabel);
            leadConvert.setDoNotCreateOpportunity(bIsCreateOpportunity);   
            //Set to create opportunity or not
            Database.LeadConvertResult leadConvertResult;
            try{
                leadConvertResult = Database.convertLead(leadConvert);
            }
            catch(Exception ex){
                if((ex.getMessage()!=null)&&ex.getMessage().contains('</table')) 
                return System.Label.Lead_Conversion_Error2+' '+ex.getMessage();     
                //Please resolve the error(s) before procced
                else 
                return System.Label.Lead_Conversion_Error2+' '+ex.getMessage();    
                //Please resolve the error(s) before proceed
            }
            Account oAccount=new Account(Id=leadConvertResult.getAccountId() ); 
            /* Added on 10-Mar-2015 with New Field Map */
            oAccount.First_Name__c=leadTobeConverted.FirstName;
            oAccount.Mailing_Street__c=leadTobeConverted.Street;
            oAccount.Mailing_State_Province__c=leadTobeConverted.State;
            oAccount.Mailing_City__c=leadTobeConverted.City;
            oAccount.Mailing_Country__c=leadTobeConverted.Country;
            oAccount.Mailing_Zip_Postal_Code__c=leadTobeConverted.PostalCode;
            oAccount.Personal_Email__c=leadTobeConverted.Email;
            oAccount.Preferred_Email__c=
            (oAccount.Personal_Email__c!=null)?System.label.Personal:null;
            oAccount.Mobile_Phone__c=leadTobeConverted.Phone;
            oAccount.Preferred_Phone__c=
            (oAccount.Mobile_Phone__c!=null)?System.label.Mobile:null;
            oAccount.BillingStreet=null;
            oAccount.BillingCity=null;
            oAccount.BillingState=null;
            oAccount.BillingCountry=null;
            oAccount.BillingPostalCode=null;
            oAccount.Phone=null;
            oAccount.Override_Account_Validation__c=true;
            oAccount.Prefix__c=leadTobeConverted.Salutation;
            if((sLeadType!=null)&&(
                        (System.Label.LeadTypeToSupporter.toUpperCase()).contains
                        (sLeadType.toUpperCase())))
            oAccount.recordtypeId=Utility.getRecordtype('Supporter','Account');
            else{
                oAccount.recordtypeId=Utility.getRecordtype('Partner','Account'); 
                //Craeting Partner type based on Lead Type
//Apurva-Aug 2015 : Added bypass for Mobile experience Lead Type
                if(sLeadType != System.Label.Lead_Type_Mobile_Exp){
                Partner_Type__c oPartnerTypeVar=new Partner_Type__c();
                oPartnerTypeVar.Account__c=oAccount.Id;
                oPartnerTypeVar.Metro_State__c=leadTobeConverted.Metro_State__c;
                oPartnerTypeVar.Metro_Area_Pick__c=leadTobeConverted.Metro_Area__c;
               
                oPartnerTypeVar.OwnerId=UserInfo.getUserId();
                oPartnerTypeVar.Type__c=sLeadType;
                oPartnerTypeVar.recordtypeId=Utility.getRecordtype(sLeadType,
                'Partner_Type__c');
                oAccount.Partner_Profile_Type__c=sLeadType;
                lstPartnerType.add(oPartnerTypeVar);
                }
            }
            if(leadTobeConverted.Origin_Source_Code__c!=null)
            oAccount.Origin_Of_Lead__c=leadTobeConverted.Origin_Source_Code__c;
            delete new Contact(Id=leadConvertResult.getContactId());       
            // Delete Newly created Contact
            if(!bIsCreateOpportunity) {
                Opportunity oOpportunity=new
                Opportunity(Id=leadConvertResult.getOpportunityId(),
                StageName=System.label.Pending,CloseDate=date.today
                ().addDays(7)); 
                // Setting Opportunity Stage and Default Close Date
                update oOpportunity;
            }
            for(Task oTaskVar: lstTask)
            oTaskVar.whatId=leadConvertResult.getAccountId();
            for(Event oEventVar: lstEvent)
            oEventVar.whatId=leadConvertResult.getAccountId(); 
            for(Communication__c oCommvar: lstComm)
            oCommvar.Account__c=leadConvertResult.getAccountId(); 
            for( Note oNoteVar: lstNotesDelete){
                Note oNoteVarNew=oNoteVar.clone();
                oNoteVarNew.parentId=leadConvertResult.getAccountId();
                lstNotes.add(oNoteVarNew);
            }
            for( Attachment oAttachmentVar: lstAttachmentDelete){
                Attachment oAttachmentVarNew=oAttachmentVar.clone();
                oAttachmentVarNew.parentId=leadConvertResult.getAccountId();
                lstAttachment.add(oAttachmentVarNew);
            } 
            try{
                if(lstEvent.size()>0)
                update lstEvent;
                if(lstTask.size()>0)
                update lstTask;
                if(lstComm.size()>0)
                update lstComm;
                if(lstPartnerType.size()>0)
                insert lstPartnerType;
                if(lstAttachment.size()>0)
                insert lstAttachment;
                if(lstNotes.size()>0)
                insert lstNotes;
                
                update oAccount;// Updating Custom Lead Mapping
                oAccount.Override_Account_Validation__c=true;
                update oAccount;//Checking for Duplicate Check once again
            }
            catch(Exception ex){
                return System.Label.Lead_Conversion_Waring;   
                //Lead is converted with missing details in oAccount.
                //Please update oAccount record
            } 
            return System.Label.Lead_Conversion_Success;         
            //Lead is converted successfully
        }
        catch(Exception ex){
         
            if((ex.getMessage()!=null)&&(ex.getMessage().contains
                        (System.label.LeadUpdateError)))
            return System.Label.Lead_Conversion_Error;        
            //Lead has been already converted
            else if((ex.getMessage()!=null)&&ex.getMessage().contains('</table')) 
            return System.Label.Lead_Conversion_Error2;       
            //Please resolve the error(s) before procced
            else 
            return System.Label.Lead_Conversion_Error2+' '+ex.getMessage();  
            //Please resolve the error(s) before procced
        }  
    }
}