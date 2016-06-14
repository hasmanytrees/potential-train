/**********************************************************************
    Name             : CommunicationPrefExtension
    Description      : This class is vf controller for CommunicationPref which
                       is used as View related list page
                       related communication preference record
                       in one pageReference          
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                23/03/2015            Created
Subhojit                23/03/2015            Modified for code re-factoring 
                                              & optimization
/**********************************************************************/
public with sharing class CommunicationPrefExtension{

    public Id accountId{get;set;}
    public List<Communication_Preference__c> lstCommPref{get;set;}
    public Communication_Preferences__c oCommPrefBooleanCS{get;set;}
    Public Integer iTableLength{get;set;}
    public List<String> lstBooleanField{get;set;}
    public Id booleanCSId{get;set;}
    public List<CommmPrefWrapper> lstCommPrefWrapper{get;set;}
    public List<CommmPrefWrapper> lstCommPrefWrapperFinal{get;set;}
    public List<CommmPrefWrapper> lstCommPrefWrapperSubscription{get;set;}
     public List<CommmPrefWrapper> lstCommPrefWrapperCategory{get;set;}
    public Integer iCurrentPageSize{get;set;}
    public Integer iFullPageSize{get;set;}
    public boolean bAllPage{get;set;}
    public Integer iNoOfRecords{get;set;}
    public boolean bIsShowPage{get;set;}
    public boolean bShowBooean{get;set;}
    public CommunicationPrefExtension(ApexPages.StandardController controller){

        accountId=controller.getId();  //Getting related Account Id
        iFullPageSize=0;
        iTableLength=0;
        iCurrentPageSize=10;
        iNoOfRecords=0;
        lstCommPrefWrapperSubscription=new List<CommmPrefWrapper>();
        lstCommPrefWrapperCategory=new List<CommmPrefWrapper>();
        lstBooleanField=new List<String>();
        String sShowFullList=ApexPages.currentPage().getParameters().get
        ('FullPage');  
        //This parameter is set if to show full page
        SObjectType accountType = Schema.getGlobalDescribe().get
        ('Communication_Preference__c');
        Map<String,Schema.SObjectField> mapFieldSchema = 
        accountType.getDescribe().fields.getMap();
        lstCommPrefWrapper=new List<CommmPrefWrapper>();
        lstCommPrefWrapperFinal=new List<CommmPrefWrapper>();
        String sQuery='select ';
        for(String sFieldVar: mapFieldSchema.keySet())
        sQuery+=sFieldVar+',';
        
        sQuery=sQuery.subStringbeforeLast(',');
        sQuery+=' from Communication_Preference__c where Account__c=\''+accountId+'\'';
        //Getting all field values of related Account's communication record.
        lstCommPref=(List<Communication_Preference__c>)Database.query(sQuery);
        if(lstCommPref.size()==0){
           ApexPages.Message myMsg = new ApexPages.Message
           (ApexPages.Severity.INFO,System.Label.NoRelatedCommPrefFound);
           //No Communication preference record found
           ApexPages.addMessage(myMsg);
           bIsShowPage=false;
           return;  
        
        }
        
        bIsShowPage=true;
        List<Communication_Preferences__c> lstCommPrefCS=
        new List<Communication_Preferences__c>();
        lstCommPrefCS=[select Id,Name,Active__c,Category__c,Is_Displayed_On_Page__c,
                        Language__c,Mapping_Fields__c,Medium__c,Is_Subscription__c,Is_Category__c
                        from Communication_Preferences__c  order by Category__c]; 
        //Retrieving all Custom settings for comm Preferences
       oCommPrefBooleanCS=Communication_Preferences__c.getAll().get
        (System.label.BooleanFieldSection);
        booleanCSId=oCommPrefBooleanCS.Id;
        if(oCommPrefBooleanCS.Mapping_Fields__c.contains(';'))
        lstBooleanField=oCommPrefBooleanCS.Mapping_Fields__c.split(';');
        else
         lstBooleanField.add(oCommPrefBooleanCS.Mapping_Fields__c);
        bShowBooean=oCommPrefBooleanCS.Is_Displayed_On_Page__c;
        for(Communication_Preferences__c oCommPrefCSVar: lstCommPrefCS){
            //Setting various field value.
            if(oCommPrefCSVar.Mapping_Fields__c!=null){
               //Getting related fields form custom setting record and 
               //setting value to show on UI.   
                List<String> lstAllRelatedFields=new List<String>();
                lstAllRelatedFields=oCommPrefCSVar.Mapping_Fields__c.split(';');
                CommmPrefWrapper comPrefWrapperVar=new CommmPrefWrapper();
                comPrefWrapperVar.sCommName=oCommPrefCSVar.Category__c;
                comPrefWrapperVar.bIsShowedOnPage=oCommPrefCSVar.Is_Displayed_On_Page__c; 
                comPrefWrapperVar.sCommPrefCSId=oCommPrefCSVar.Id;
                comPrefWrapperVar.bIsCategory=oCommPrefCSVar.Is_Category__c;
                
                for(String sFieldVar: lstAllRelatedFields){
                    sObject oSObjectComm;
                    if(lstCommPref.size()>0){
                        oSObjectComm=lstCommPref[0];
                        if(sFieldVar.contains(System.label.Active))
                        comPrefWrapperVar.bIsActive=
                        (Boolean)oSObjectComm.get(sFieldVar);
                        else if(sFieldVar.contains(System.label.Email))
                        comPrefWrapperVar.bIsEmailOptOut=
                        (Boolean)oSObjectComm.get(sFieldVar);  
                        else if(sFieldVar.contains(System.label.Text))
                        comPrefWrapperVar.bIsTextOptOut=
                        (Boolean)oSObjectComm.get(sFieldVar); 
                        else if(sFieldVar.contains(System.label.Mail))
                        comPrefWrapperVar.bIsMailOptOut=
                        (Boolean)oSObjectComm.get(sFieldVar); 
                        else if(sFieldVar.contains(System.label.Language))
                        comPrefWrapperVar.sLanguage =
                        (String)oSObjectComm.get(sFieldVar); 
                        else if(sFieldVar.contains(System.label.Medium))
                        comPrefWrapperVar.sMedium=
                        (String)oSObjectComm.get(sFieldVar); 
                        
                    }  
                             
                }
                if(comPrefWrapperVar.bIsShowedOnPage){
                  lstCommPrefWrapper.add(comPrefWrapperVar);
                if(comPrefWrapperVar.bIsCategory)
                 lstCommPrefWrapperCategory.add(comPrefWrapperVar);
                else if(oCommPrefCSVar.Is_Subscription__c)
                  lstCommPrefWrapperSubscription.add(comPrefWrapperVar);
                }
            }            
        }

        //If full list is to be displayed
        if(sShowFullList==System.label.TRUE)
        showFull();
        else{
             iTableLength=5;
            //If only first 10 default records  list is to be displayed
             iFullPageSize=lstCommPrefWrapperCategory.size()+lstCommPrefWrapperSubscription.size();
            if(iCurrentPageSize>=lstCommPrefWrapper.size())
            iCurrentPageSize=lstCommPrefWrapper.size();
            for(Integer iIndex=0;iIndex<iCurrentPageSize;iIndex++)
            lstCommPrefWrapperFinal.add(lstCommPrefWrapper[iIndex]);
            
        }
        if(iFullPageSize-iCurrentPageSize>10)
        iNoOfRecords=10;
        else
        iNoOfRecords= iFullPageSize-iCurrentPageSize;
       iFullPageSize=lstCommPrefWrapperCategory.size()+lstCommPrefWrapperSubscription.size();
    }

    /**
    * Method name  : showMore
    * Description  : This method is used to show 10 more record every time
    * Return Type  : void
    * Parameter    : void
    **/   
    public void showMore(){
        iCurrentPageSize+=10;  // Incrementing counter by 10.
        lstCommPrefWrapperFinal=new List<CommmPrefWrapper>();
        if(iCurrentPageSize>=lstCommPrefWrapper.size())
        iCurrentPageSize=lstCommPrefWrapper.size();
        for(Integer iIndex=0;iIndex<iCurrentPageSize;iIndex++)
        lstCommPrefWrapperFinal.add(lstCommPrefWrapper[iIndex]);

        if(iFullPageSize-iCurrentPageSize>10)
        iNoOfRecords=10;
        else
        iNoOfRecords= iFullPageSize-iCurrentPageSize;
        //No of record more have to show


    }
    /**
    * Method name  : showFull
    * Description  : This method is used to show all comm Preference record 
    * Return Type  : void
    * Parameter    : void
    **/   
    public void showFull(){

        iCurrentPageSize=lstCommPrefWrapper.size();  
        //setting page size as full length of retrieved array
        lstCommPrefWrapperFinal=new List<CommmPrefWrapper>();
        if(iCurrentPageSize>=lstCommPrefWrapper.size())
        iCurrentPageSize=lstCommPrefWrapper.size();
        for(Integer iIndex=0;iIndex<iCurrentPageSize;iIndex++)
        lstCommPrefWrapperFinal.add(lstCommPrefWrapper[iIndex]);
        iTableLength=17;
        bAllPage=true;
    }
    //Wrapper class to wrapp values and display on UI.
    public class CommmPrefWrapper{
        public String sCommName{get;set;}
        public String sCommPrefCSId{get;set;}
        public String sMedium{get;set;}
        public String sLanguage {get;set;}
        public boolean bIsActive{get;set;}
        public boolean bIsEmailOptOut{get;set;}
        public boolean bIsTextOptOut{get;set;}
        public boolean bIsMailOptOut{get;set;}
        public boolean bIsShowedOnPage{get;set;}
        public boolean bIsCategory{get;set;}


       
        public CommmPrefWrapper(){

        }
    }

}