/*****************************************************************************
    Name             : CommunicationPrefEditController
    Description      : This class is vf controller for CommunicationPrefEdit 
                       which is used to edit related communication preference 
                       record in one pageReference          
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                23/03/2015            Created
Subhojit                23/03/2015            Modified for code re-factoring 
                                              & optimization
/*****************************************************************************/
public with sharing class CommunicationPrefEditExtension{

    public Id accountId{get;set;}
    public Communication_Preference__c oCommPref{get;set;}
    public List<String> lstFieldName{get;set;}
    public  String sCommPrefId{get;set;}
    public  String sCommPrefName{get;set;}

    public CommunicationPrefEditExtension(){

        accountId=ApexPages.currentPage().getParameters().get('accountId'); 
        // Getting related AccountId
        
        sCommPrefId=ApexPages.currentPage().getParameters().get('commPrefCSId'); 
        //Getting related Communication Preference Custom setting Id
        sCommPrefName=ApexPages.currentPage().getParameters().get
        ('commPrefCSName');
        SObjectType accountType = Schema.getGlobalDescribe().get
        ('Communication_Preference__c');
        String sCategoryType=ApexPages.currentPage().getParameters().get
        ('category');
        Map<String,Schema.SObjectField> mapFieldSchema = 
        accountType.getDescribe().fields.getMap();
        lstFieldName=new List<String>();
        oCommPref=new Communication_Preference__c();
        String sQuery='select ';
        for(String sFieldVar: mapFieldSchema.keySet())
        sQuery+=sFieldVar+',';
        
        sQuery=sQuery.subStringbeforeLast(',');
        sQuery+=' from Communication_Preference__c where Account__c=\''+accountId+'\'';
        List<Communication_Preference__c> lstCommPref=
        new List<Communication_Preference__c>();
        lstCommPref=(List<Communication_Preference__c>)Database.query(sQuery);
        //Getting all fields of related Comm Preference record.
        List<Communication_Preferences__c> lstCommPrefCS=
        new List<Communication_Preferences__c>();
        //Below block checks for if full list to be displayed.
        if((sCommPrefId!=System.label.FULL)&&(sCommPrefId!=''))
        lstCommPrefCS=
        [select Id,Medium__c,Active__c,Category__c,Mapping_Fields__c from
        Communication_Preferences__c where Id=:sCommPrefId ];
        else
        lstCommPrefCS = Communication_Preferences__c.getAll().values();   
        //Retrieving all custom setting data for communication preferences
        sObject oSObjectComm=(sObject)lstCommPref[0];
        for(Communication_Preferences__c oCommPrefCSVar: lstCommPrefCS){
            
            if(oCommPrefCSVar.Mapping_Fields__c!=null){
                //Getting related fields form custom setting record and 
                //setting value to show on UI.  
                List<String> lstAllRelatedFields=new List<String>();
                lstAllRelatedFields=oCommPrefCSVar.Mapping_Fields__c.split(';');
                
                for(String sFieldVar:lstAllRelatedFields){
                 if((sCategoryType!=null)&&(sCategoryType.toUpperCase()=='FALSE')){ 
                 
                     if((!sFieldVar.contains('Active'))&&((sFieldVar=='Name')||(sFieldVar.Contains('_Medium_'))))
                      lstFieldName.add(sFieldVar);
                      }
                      else{
                       if(((!sFieldVar.contains('Active')))&&((!sFieldVar.contains('Language'))))
                          lstFieldName.add(sFieldVar);
                      }
                       
                
                }
                for(String sFieldVar: lstAllRelatedFields){
                    //Setting various fields 
                    if(lstCommPref.size()>0){
                        oSObjectComm=lstCommPref[0];
                        if(sFieldVar.contains(System.label.Active))
                        oCommPref.put
                        (sFieldVar,(Boolean)oSObjectComm.get(sFieldVar));
                        else if(sFieldVar.contains(System.label.Email))
                        oCommPref.put
                        (sFieldVar,(Boolean)oSObjectComm.get(sFieldVar));  
                        else if(sFieldVar.contains(System.label.Text))
                        oCommPref.put
                        (sFieldVar,(Boolean)oSObjectComm.get(sFieldVar)); 
                        else if(sFieldVar.contains(System.label.Mail))
                        oCommPref.put
                        (sFieldVar,(Boolean)oSObjectComm.get(sFieldVar)); 
                        else if(sFieldVar.contains(System.label.Language))
                        oCommPref.put
                        (sFieldVar,(String)oSObjectComm.get(sFieldVar)); 
                        else if(sFieldVar.contains(System.label.Medium))
                        oCommPref.put
                        (sFieldVar,(String)oSObjectComm.get(sFieldVar)); 
                    }                   
                    
                }  
            }            
            
        }
        oCommPref=(Communication_Preference__c)oSObjectComm;
    } 
    /**
    * Method name  : save
    * Description  : Used for saving comm preference records with changes.
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public pageReference save(){

        try
        {
        update oCommPref;
        return new pageReference('/'+accountId);
        }
        catch(Exception ex)
        {
            //Error Occurred
            return null;
        }
    }
}