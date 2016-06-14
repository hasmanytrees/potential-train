/**************************************************************************
    Name             : CommunicationPrefEditAllController
    Description      : This class is vf controller for CommunicationPrefEditAll 
                        which is used to edit all communication preference 
                        record in one pageReference          
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                23/03/2015            Created
Subhojit                23/03/2015            Modified for code re-factoring
                                              & optimization
****************************************************************************/
public with sharing class CommunicationPrefEditAllController{

   


    public Id accountId{get;set;}
    public Communication_Preference__c oCommPref{get;set;}
    public Map<String,List<String>> mapCSFieldCategory{get;set;}
  
     public Map<String,List<String>> mapCSFieldSubscription{get;set;}
    public List<String> lstFieldName{get;set;}
    
    public List<String> lstHeaderCategory{get;set;}
    public List<String> lstHeaderSubscription{get;set;}
    public List<Communication_Preference__c > lstCommPrefVal{get;set;}
    public List<String> lstBooleanField{get;set;}
    public boolean bShowBoolean{get;set;}

    public CommunicationPrefEditAllController(ApexPages.StandardController controller){

        accountId=ApexPages.currentPage().getParameters().get('accountId'); 
        // Getting related Account Id
        
        lstBooleanField=new List<String>();
        lstCommPrefVal=new List<Communication_Preference__c > ();
        SObjectType accountType = Schema.getGlobalDescribe().get
        ('Communication_Preference__c');
        Map<String,Schema.SObjectField> mapFieldSchema = 
        accountType.getDescribe().fields.getMap();
        lstFieldName=new List<String>();
        mapCSFieldCategory=new Map<String,List<String>>();
        mapCSFieldSubscription=new Map<String,List<String>>();
        oCommPref=new Communication_Preference__c();
        //Forming the query all fields for communication Preference object.
        String sQuery='select ';
        for(String sFieldVar: mapFieldSchema.keySet())
        sQuery+=sFieldVar+',';
        
        sQuery=sQuery.subStringbeforeLast(',');
        sQuery+=' from Communication_Preference__c where Account__c=\''+accountId+'\'';
        List<Communication_Preference__c> lstCommPref=
        new List<Communication_Preference__c>();
        lstCommPref=(List<Communication_Preference__c>)Database.query(sQuery);
        List<Communication_Preferences__c> lstCommPrefCS=
        new List<Communication_Preferences__c>();
        lstHeaderCategory=System.label.rowOrderCategory.split(';');  
        lstHeaderSubscription=System.label.rowOrderSubscription.split(';');  
        //Getting default row order
        //Retrieving all custom setting data for communication preferences
        lstCommPrefCS=[ select Id,Name,Active__c,Category__c,Is_Displayed_On_Page__c,Is_Category__c ,Is_Subscription__c,
                        Language__c,Mapping_Fields__c,Medium__c from Communication_Preferences__c where   Is_Displayed_On_Page__c=true and (Is_Category__c=true OR Is_Subscription__c=true) order by Category__c];
        sObject oSObjectComm=(sObject)lstCommPref[0];
        lstBooleanField=
        Communication_Preferences__c.getAll().get
        (System.label.BooleanFieldSection).Mapping_Fields__c.split(';');
        for(Communication_Preferences__c oCommPrefCSVar: lstCommPrefCS){
            
            if((oCommPrefCSVar.Mapping_Fields__c!=null)&&
            (oCommPrefCSVar.Name!=System.label.BooleanFieldSection)&&(oCommPrefCSVar.Is_Displayed_On_Page__c)){
                //Getting related fields form custom setting record and 
                //setting value to show on UI.  
                List<String> lstAllRelatedFields=new List<String>();
                lstAllRelatedFields=oCommPrefCSVar.Mapping_Fields__c.split(';');
                bShowBoolean=oCommPrefCSVar.Is_Displayed_On_Page__c;
                 boolean bIsCategory=oCommPrefCSVar.Is_Category__c;
                   List<String> lstFieldVar=new List<String>();
                if(lstAllRelatedFields.size()>0){
                  
                
              
                   
                for(String sFieldVar:lstAllRelatedFields){
                
                 
                     if((!sFieldVar.contains('Active'))&&((!sFieldVar.Contains('_Language_'))&&(bIsCategory))){
                         lstFieldVar.add(sFieldVar);
                     
                      }
                      else{
                       if(((!sFieldVar.contains('Active')))&&((!sFieldVar.contains('Language'))&&(!sFieldVar.contains('_Opt_Out_')))&&(oCommPrefCSVar.Is_Subscription__c))
                          lstFieldVar.add(sFieldVar);
                             
                      }
                       
                
                }
                  
                if(bIsCategory){    
                
                mapCSFieldCategory.put( oCommPrefCSVar.Name,lstFieldVar);
                
                }
                else
                  mapCSFieldSubscription.put( oCommPrefCSVar.Name,lstFieldVar);
                  lstFieldName=lstFieldVar;
                  
                  }
                  
                
              
                
                for(String sFieldVar: lstFieldName){
                    
                    if(lstCommPref.size()>0){
                        
                        //Setting various fields
                        if(sFieldVar.contains(System.label.Active))
                        oCommPref.put(sFieldVar,(Boolean)oSObjectComm.get
                        (sFieldVar));
                        else if(sFieldVar.contains(System.label.Email))
                        oCommPref.put(sFieldVar,(Boolean)oSObjectComm.get
                        (sFieldVar));  
                        else if(sFieldVar.contains(System.label.Text))
                        oCommPref.put(sFieldVar,(Boolean)oSObjectComm.get
                        (sFieldVar)); 
                        else if(sFieldVar.contains(System.label.Mail))
                        oCommPref.put(sFieldVar,(Boolean)oSObjectComm.get
                        (sFieldVar)); 
                        else if(sFieldVar.contains(System.label.Language))
                        oCommPref.put(sFieldVar,(String)oSObjectComm.get
                        (sFieldVar)); 
                        else if(sFieldVar.contains(System.label.Medium))
                        oCommPref.put(sFieldVar,(String)oSObjectComm.get
                        (sFieldVar)); 
                    }      
                    
                }
                
            }  
            
            
        }
       
        oCommPref=(Communication_Preference__c)oSObjectComm;
        lstCommPrefVal.add(oCommPref);
    }  
    
    
     public CommunicationPrefEditAllController(){}
    
    /**
    * Method name  : save
    * Description  : Used for saving communication preferences with 
    *                user's changes
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