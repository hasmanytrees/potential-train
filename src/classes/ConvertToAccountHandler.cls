/******************************************************************************
    Name             : ConvertToAccountHandler
    Description      : This class contains method which is called from Convert 
                        to Partner button.
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014         Created
Subhojit              29/01/2015         Modified for code re-factoring & 
                                         optimization.
Apurva                24/08/2015         Changes made for COR0001472  
Apurva                18/09/2015         Changes made for COR0001591              
******************************************************************************/

global with sharing class ConvertToAccountHandler{

    /**
    * Method name  : convertContact
    * Description  : Use this method to convert any contact to Account
    *                
    * Return Type  : String
    * Parameter    : Id
    **/  
    webservice static String convertContact(Id contactId){

        //Getting contact and related fields  
        Contact oContact= new Contact(); 
        oContact=[select Id,Name,Gender__c,Job_Title__c,Christmas_Gift__c,
        Alternative_Email__c,Children__c,Date_Deceased__c,Date_Widowed__c,
        Marital_Status__c,Employer__c, Preferred_Name__c,Preferred_Email__c,
        Role__c,Wedding_Date__c,Work_Phone__c,Suffix__c,HomePhone,LastName,
        Status__c,Description,MobilePhone,MailingCity,MailingStreet,MailingState
      ,MailingPostalCode,MailingCountry,DoNotCall,Birthdate,AccountId,FirstName
       ,OtherState,OtherStreet,OtherCity,OtherPostalCode,OtherPhone,OtherCountry
        from Contact where Id=:contactId];

        //This fix has been added because of a incident raised which
        //was Volunteer Manager profile Users were receiving error while clicking on
        //Convert to Account Button as the person was not the owner of the contact so received this error
        oContact.OwnerId = UserInfo.getUserId();
        update oContact;
        
        //Mapping contact fiedls to Account Fields
        Account oAccountVar=new Account();
        oAccountVar.recordtypeId=Utility.getRecordtype('Partner','Account'); 
        //Setting record type as partner
        oAccountVar.First_Name__c=oContact.FirstName;
        oAccountVar.Name=oContact.LastName;
        oAccountVar.Mailing_City__c=oContact.MailingCity;
        oAccountVar.Mailing_Street__c=oContact.MailingStreet;
        oAccountVar.Mailing_State_Province__c=oContact.MailingState;
        oAccountVar.Mailing_Country__c=oContact.MailingCountry;
        oAccountVar.Mailing_Zip_Postal_Code__c=oContact.MailingPostalCode;
        oAccountVar.Christmas_Card_Gift__c=oContact.Christmas_Gift__c;
        oAccountVar.Work_Phone__c=oContact.Work_Phone__c;
        oAccountVar.Gender__c=oContact.Gender__c;
        oAccountVar.Mobile_Phone__c=oContact.MobilePhone;
        oAccountVar.Home_Phone__c=oContact.HomePhone;
        oAccountVar.Business_Phone__c=oContact.OtherPhone;
        oAccountVar.Deceased_Date__c=oContact.Date_Deceased__c;
        oAccountVar.Do_Not_Call__c=oContact.DoNotCall;
        oAccountVar.Wedding_Date__c=oContact.Wedding_Date__c;
        oAccountVar.Suffix__c=oContact.suffix__c;
        //Apurva -Changes for COR0001472 start
//        oAccountVar.Personal_Email__c=oContact.Alternative_Email__c;
//        oAccountVar.Business_Email__c=oContact.Preferred_Email__c;
        oAccountVar.Personal_Email__c=oContact.Preferred_Email__c;
        oAccountVar.Business_Email__c=oContact.Alternative_Email__c;
        if(oAccountVar.Personal_Email__c != '' && oAccountVar.Personal_Email__c != null){
            oAccountVar.Preferred_Email__c = 'Personal';
        }
        else if(oAccountVar.Business_Email__c != '' && oAccountVar.Business_Email__c!= null){
            oAccountVar.Preferred_Email__c = 'Business';
        }
        oAccountVar.ADV_Preferred_Radius__c = '100';
        if(oContact.MailingPostalCode != '' && oContact.MailingPostalCode != null){
            if(oContact.MailingPostalCode.length()>5){
              oAccountVar.ADV_Preferred_Zip_Code__c = oContact.MailingPostalCode.substring(0,5);
            }
            else
              oAccountVar.ADV_Preferred_Zip_Code__c = oContact.MailingPostalCode;  
        }
        //Changes for COR0001472 end
        oAccountVar.Status__c=oContact.Status__c;
        oAccountVar.Notes__c=oContact.Description;
        oAccountVar.Wedding_Date__c=oContact.Wedding_Date__c;
        oAccountVar.BillingCity=oContact.OtherCity;
        oAccountVar.BillingState=oContact.OtherState;
        oAccountVar.BillingStreet=oContact.OtherStreet;
        oAccountVar.BillingCountry=oContact.OtherCountry;
        oAccountVar.BillingPostalCode=oContact.OtherPostalCode;
        oAccountVar.Preferred_Name__c=oContact.Preferred_Name__c;
        oAccountVar.Employer__c=oContact.Employer__c;
        oAccountVar.BirthDate__c=oContact.Birthdate;
        oAccountVar.Marital_Status__c=oContact.Marital_Status__c;
        
        oAccountVar.Override_Account_Validation__c=true;
        oAccountVar.Type = 'Individual';
        oAccountVar.Status__c= 'Active' ;
        //Apurva-Changes made for INC0064780 and COR0001581
        //Populate Parent Account Id on Contact if Parent Account type 
        //is Individual,Couple or Family
        if(oContact.AccountId != null){
            List<Account> varAccountLst =
            [select Id, Type from Account where Id =:oContact.AccountId limit 1];
            if(varAccountLst.size() > 0){
                for(Account oAccVar: varAccountLst){
                    if(System.Label.AccTypeForParentIdPopulation.contains(oAccVar.Type)){    
                        oAccountvar.ParentId = oContact.AccountId;
                    }                    
                }
            }
        }
        try{
            insert oAccountVar;
            delete oContact;   //Deleting Contact
            //Changes made for COR0001591
            //Creating relationship group 
            //for newly converted Account
            Relationship_Group__c oRelGroupVar=
            new Relationship_Group__c ();
            oRelGroupVar.Group__c=oContact.AccountId;
            oRelGroupVar.Supporter__c=oAccountVar.Id;
            oRelGroupVar.Status_Of_Relationship__c = 'Active';
            insert oRelGroupVar;
            return oAccountVar.Id;
        }
        catch(Exception ex){
         
            Utility.insertErrorLogApplication(ex.getMessage()+'\n'+
            ex.getStackTraceString(),'Contact',contactId,
            'ConvertToAccountHandler','convertContact','Application',
            UserInfo.getUserId(), String.valueOf(oAccountVar),null);
        
            return 'false';
        }
    }
}