/*******************************************************************************
Name             : ContactTriggerHandler
Description      : Trigger Handler class used to initiate other helper class 
                   based on condition
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Apurva                17/08/2015            Created
*******************************************************************************/
public with Sharing class ContactTriggerHandler{
     /**
    * Method name  : onInsertUpdateCheckPrimaryContact
    * Description  : Use this method to initiate Valdiator class to check 
                     Primary Contact on Account
    * Return Type  : void
    * Parameter    : List<Contact>
    **/
    
    public static void onInsertUpdateCheckPrimaryContact(List<Contact> lstNew){
      List<Contact> lstContact= new List<Contact>();
      for(Contact oContactVar: lstNew){
          if(oContactVar.primary_contact__c == true && oContactVar.accountId!=null){
            lstContact.add(oContactVar);
          }  
          ContactValidatorHelper.checkPrimaryContactOnAccount(lstContact);  
      }
    }
}