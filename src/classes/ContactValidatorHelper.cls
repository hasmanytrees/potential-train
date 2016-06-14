public without Sharing class ContactValidatorHelper{
/*
    **********************************************************************
    Name             : ContactValidatorHelper
    Description      : Helper class used for Validating the primary contact
                       on an account. If more than one primary contact is present
                       on account throw error           
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer           Date              Description
    ---------------------------------------------------------------------------
    Apurva              17/08/2015       Created
    *************************************************************************/

    /**
    * Method name  : checkPrimaryContactOnAccount
    * Description  : Use this method to validate if more than one primary
                    contact is present on an account at same time and
                    then throws an error. 
    * Return Type  : void
    * Parameter    : List<Contact> lstContact
    **/ 
     public static void  checkPrimaryContactOnAccount(List<Contact> lstContact){
         Set<Id> setAccountId = new Set<Id>();
         for(Contact oContactVar: lstContact){
             setAccountId.add(oContactVar.accountid);
         }
         List<Contact> listContact = [Select Id,AccountId from Contact where primary_contact__c = true 
                                     and AccountId in :setAccountId and Id not in :Trigger.New];
         if(listContact.size() >0){
           for (Contact oContactVar : listContact){
             try
                {
                    Trigger.New.get(0).addError
                   (System.label.PrimaryContactError,false);
                }
                catch(Exception ex)
                {
  
                }
           }       
         }
      }
}