/*******************************************************************************
    Name             : CommunicationHandler
    Description      : Trigger Helper class used to handle the scenario of 
                       creating default Communication Preference related to any 
                       account on Creation                  
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
*******************************************************************************/
public class CommunicationHandler{

    /**
    * Method name  : addCommunicationPref
    * Description  : Use this method to create default Communication preference  
    *                
    * Return Type  : void
    * Parameter    : Set<Id>
    **/  
    public static void addCommunicationPref(Set<Id> setAccId){

        List<Communication_Preferences__c> lstAllPredefinedCommPref=
        new List<Communication_Preferences__c>();
        lstAllPredefinedCommPref=Communication_Preferences__c.getAll().values();               
        // Get all Default Communication Preference Values from Custom Setting.
        List<Communication_Preference__c> lstNewCommPref=
        new List<Communication_Preference__c>();
        
        for(Id accIdVar:setAccId){
            sObject oSObjectComm=new Communication_Preference__c();
            oSObjectComm.put('Account__c',accIdVar);
            for(Communication_Preferences__c oCommPrefCSVar:
            lstAllPredefinedCommPref){
                if(oCommPrefCSVar.Mapping_Fields__c!=null){
                    
                    List<String> lstAllRelatedFields=new List<String>();
                    lstAllRelatedFields=
                    oCommPrefCSVar.Mapping_Fields__c.split(';');
                    
                    for(String sFieldVar: lstAllRelatedFields){
                        
                        if(sFieldVar.contains(System.label.Active))
                        oSObjectComm.put(sFieldVar,oCommPrefCSVar.Active__c);
                        else if(sFieldVar.contains(System.label.Email))
                        oSObjectComm.put(sFieldVar,false); 
                        else if(sFieldVar.contains(System.label.Text))
                        oSObjectComm.put(sFieldVar,false);
                        else if(sFieldVar.contains(System.label.Mail))
                        oSObjectComm.put(sFieldVar,false);
                        else if(sFieldVar.contains(System.label.Language))
                        oSObjectComm.put(sFieldVar,oCommPrefCSVar.Language__c);
                        else if(sFieldVar.contains(System.label.Medium))
                        oSObjectComm.put(sFieldVar,oCommPrefCSVar.Medium__c);          
                    }       
                }
            } 
            lstNewCommPref.add((Communication_Preference__c)oSObjectComm);
        }
        // Inserting Communication Pref. Records.
        List<Database.SaveResult> lstSaveResult=Database.insert(lstNewCommPref);

        for(Database.SaveResult oSaveResultVar:lstSaveResult){

            if (oSaveResultVar.isSuccess()) {
                // Operation was successful, so get the ID of the 
                //record that was processed
               
            }
            else {
                String sCollateErrorMessages = '';
                // Operation failed, so get all errors                
                for(Database.Error oErrorVar : oSaveResultVar.getErrors()) {
                    
                    sCollateErrorMessages += oErrorVar.getMessage();
                    // Show error Message for Error in insert.
                   
                    
                    
                    Utility.insertErrorLogApplication(oErrorVar.getMessage(),
                    'Communication_Preference__c',String.valueOf(setAccId),
                    'CommunicationHandler','addCommunicationPref',
                    'Application',UserInfo.getUserId(), 
                    String.valueOf(lstSaveResult),null);
                }
                //Creating a new Error Log record whenever any exception is 
                //encountered while performing DML Operation
            }  

        }

    }

}