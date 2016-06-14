/*****************************************************************************
    Name             : PartnerTypeInlineExtension
    Description      : This class is used as visual force controller extension 
    for page PartnerTypeInline page  which is used on Partner page layout
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
******************************************************************************/
public with Sharing class PartnerTypeInlineExtension{

    //Member variable
    public Account oAccount{get;set;}
   
    public List<String> lstPartnerTypeVal{get;set;}
    
    Map<String,String> mapFieldPartnerType{get;set;}
    //Partner type and record map
    public Map<String,Partner_Type__c> mapPartnerTypeData{get;set;} 
    List<Partner_Type__c> lstPartner{get;set;}
    public Id accountId{get;set;}
    public Partner_Type__c oPartnerTypeObj{get;set;}
    //Various Partner type
    public boolean bIsArtist{get;set;}
    public boolean bIsOutputPage{get;set;}
    public boolean bIsBlogger{get;set;}
    public boolean bIsAdvocate{get;set;}
    public boolean bIsSpeaker{get;set;}
    public String sFieldName{get;set;}
    public String sFieldNamePartnerType{get;set;}
    public List<HistoryDetails> lstHistoryWrapperFinal{get;set;}
    public String sRemoveFieldName{get;set;}
    //Partner type and FieldSetMember list
    public Map<String,List<FieldSetMember>> mapCheckboxFieldset{get;set;} 
    public Map<String,List<FieldSetMember>> 
    mapCheckboxFieldsetPartnerType{get;set;}
    public Map<String,boolean> mapFieldCheckbox{get;set;}
    List<Fieldset_Mapping__c> lstFieldSet{get;set;}
    public List<String> lstAllPartnerType{get;set;}
    //List to store history of all Partner type
    public Map<Id,String> mapHistory{get;set;}   
    String oSObjectName;
    String sObjectPartnerType;
    STring sObjectNamePartnerType;
    //Basic constructor to initialize class variable
    public PartnerTypeInlineExtension
    (ApexPages.StandardController Controller){
        oPartnerTypeObj=new Partner_Type__c();
        mapFieldPartnerType=new Map<String,String>();
        accountId=Controller.getId();
        mapPartnerTypeData=new Map<String,Partner_Type__c>();

        mapFieldCheckbox=new Map<String,boolean>();
        //Getting all related partner type
        oAccount=[select Id,Partner_Profile_Type__c 
        from Account where Id=:accountId]; 
        lstAllPartnerType=new List<String>();
        //Get all Partner type List
        lstAllPartnerType=Utility.getPicklistValues
        (new Account(),'Partner_Profile_Type__c'); 
        lstAllPartnerType.sort();
        lstPartner=new List<Partner_Type__c>();
        //Generating Query to get all Partner type records.
        String sQuery=
        Utility.getQueryUsingFieldSet(Utility.getFieldDetails
        (new Partner_Type__c(),'PartnerAllField'));
        sQuery+='Id from Partner_Type__c where Account__c=:accountId';
        lstPartner=(List<Partner_Type__c>)Database.query(sQuery);
        
        //Getting pick list values for Part_Type__c 
        //and mapping between check box and its previously saved value.  
        
        if(oAccount.Partner_Profile_Type__c!=null){  
            
            List<String> lstPicklistValue=new List<String>();
            lstPicklistValue=oAccount.Partner_Profile_Type__c.split(';');
            //Getting user selected Partner type values from Account
            if(lstPicklistValue.size()!=0){

                for(String sPicklistVar:lstAllPartnerType){
                    Integer iCheck=0;
                    
                    for(String sSelectedValueVar:lstPicklistValue){
                        
                        if(sSelectedValueVar==sPicklistVar){
                            //Those partner type which are all selected
                            mapFieldCheckbox.put(sPicklistVar,true);
                            
                            iCheck++;
                        }
                    }
                    //Forming map of Partner type and if its selected or not
                    if(iCheck==0)
                    mapFieldCheckbox.put(sPicklistVar,false); 
                }
            }
        }


        else{
            for(String sPicklistVar:lstAllPartnerType)
            mapFieldCheckbox.put(sPicklistVar,false);

        }  
           
        mapCheckboxFieldset=new Map<String,List<FieldSetMember>> ();
        mapCheckboxFieldsetPartnerType=new Map<String,List<FieldSetMember>> ();
        lstFieldSet=new List<Fieldset_Mapping__c>();
        lstFieldSet=Fieldset_Mapping__c.getAll().values();
        
        oSObjectName=(new Account()).getSObjectType().getDescribe().getName();
        sObjectNamePartnerType=
        (new Partner_Type__c()).getSObjectType().getDescribe().getName();
        bIsOutputPage=true;
       lstPartnerTypeVal=new List<String>();
       lstPartnerTypeVal.addAll(mapCheckboxFieldset.keySet());
       lstPartnerTypeVal.sort();
       
    }

    /**
    * Method name  : generateField
    * Description  : Use this method to get field based on FieldSet
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    public void generateField(){


        String sFieldSetName='';
    
        if(sFieldName!=null){
            for(Fieldset_Mapping__c oFieldsetVar:lstFieldSet){
               
                if(((oFieldsetVar.Name==sFieldName)
                &&(oFieldsetVar.Object_API_Name__c==oSObjectName))
                ||((oFieldsetVar.Name.StartsWith(sFieldName))
                &&(oFieldsetVar.Object_API_Name__c==sObjectNamePartnerType))){
                    
                    //Getting fieldset name for user checked partner type
                    if((oFieldsetVar.Name==sFieldName)
                    &&(oFieldsetVar.Object_API_Name__c==oSObjectName))
                    sFieldSetName=oFieldsetVar.Fieldset_API_Name__c;
                    if((oFieldsetVar.Name.StartsWith(sFieldName))
                    &&(oFieldsetVar.Object_API_Name__c==sObjectNamePartnerType))
                    sFieldNamePartnerType=oFieldsetVar.Fieldset_API_Name__c;
                }
            }
         
            List<FieldSetMember> lstFieldSetVar=new List<FieldSetMember>();
            //Getting Field set for User Selected FieldSet
            lstFieldSetVar=Utility.getFieldDetails(new Account(),sFieldSetName);  
         
            List<FieldSetMember> lstPartnerType=new List<FieldSetMember>();
            
            lstPartnerType=
           Utility.getFieldDetails(new Partner_Type__c(),sFieldNamePartnerType);
          
            mapCheckboxFieldset.put(sFieldSetName,lstFieldSetVar);
            mapCheckboxFieldsetPartnerType.put
            (sFieldNamePartnerType,lstPartnerType);
            Partner_Type__c oPartnerObjVar;
            mapFieldPartnerType.put(sFieldName,sFieldNamePartnerType);
            
            if(lstPartner.size()==0){
                oPartnerObjVar=new Partner_Type__c();
               
            }
            else
            {
                Integer iCheck=0;
                
                for(Partner_Type__c oPartnerVar:lstPartner){
                    if(oPartnerVar.Type__c==sFieldName){
                        oPartnerObjVar=oPartnerVar;
                        iCheck++;
                       
                    }
                }
                if(iCheck==0)
                oPartnerObjVar=new Partner_Type__c();
              
                
            }
           
            oPartnerObjVar.Type__c=sFieldName;
            oPartnerObjVar.Account__c=accountId;
            //Setting Separate recordtype for each partner type
            oPartnerObjVar.recordTypeId=
            Utility.getRecordTypeMap('Partner_Type__c').get(sFieldName);  
            oPartnerObjVar.ownerId=UserInfo.getUserId();
           
            mapPartnerTypeData.put(sFieldSetName,oPartnerObjVar);
            lstPartnerTypeVal=new List<String>();
            lstPartnerTypeVal.addAll(mapCheckboxFieldset.keySet());
            lstPartnerTypeVal.sort();
        }

    }
    /**
    * Method name  : removeField
    * Description  : Use this method to remove field
    based on FieldSet on check box checked on UI
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    public void removeField(){


        String sFieldSetName='';
        if(sRemoveFieldName!=null){
           
            for(Fieldset_Mapping__c oFieldsetVar:lstFieldSet){
               
                if((oFieldsetVar.Name==sRemoveFieldName)
                &&(oFieldsetVar.Object_API_Name__c==oSObjectName)){
                    sFieldSetName=oFieldsetVar.Fieldset_API_Name__c;

                    
                    sObject oAccountVar=(sObject)oAccount;
                    if(mapCheckboxFieldset <> null){
                    for(Schema.FieldSetMember fieldSetValueVar:
                    mapCheckboxFieldset.get(sFieldSetName)){                       
                        
                        oAccountVar.put(fieldSetValueVar.getFieldPath(),null);                        
                        
                    }}
                    oAccount=(Account)oAccountVar;

                }

            }
            //Removing user unselected check box and removing from fieldset map
           
            mapCheckboxFieldset.remove(sFieldSetName);
      
            mapCheckboxFieldsetPartnerType.remove
            (mapFieldPartnerType.get(sRemoveFieldName));
        
            mapPartnerTypeData.remove(sFieldSetName);
           
            lstPartnerTypeVal=new List<String>();
            lstPartnerTypeVal.addAll(mapCheckboxFieldset.keySet());
            lstPartnerTypeVal.sort();
        }

    }
    /**
    * Method name  : getFieldsOnLoad
    * Description  : Use this method to get previously 
                     created partner type details 
                     and default Partner types.
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void getFieldsOnLoad(){

        List<String> lstFieldValue=new List<String>();
        mapHistory=new Map<Id,String>();
        if(oAccount.Partner_Profile_Type__c!=null)
        lstFieldValue=oAccount.Partner_Profile_Type__c.split(';');

        for(String sFieldVar: lstFieldValue){
            String sFieldSetName='';
            //Getting field Set mapping from Custom Setting
            for(Fieldset_Mapping__c oFieldsetVar:lstFieldSet){  

               
                if((oFieldsetVar.Name==sFieldVar)
                &&(oFieldsetVar.Object_API_Name__c==oSObjectName)){
                    sFieldSetName=oFieldsetVar.Fieldset_API_Name__c;
                }
                else if((oFieldsetVar.Name.contains(sFieldVar))
                &&(oFieldsetVar.Object_API_Name__c=='Partner_Type__c')){
                    sFieldNamePartnerType=oFieldsetVar.Fieldset_API_Name__c;
                }
                
            }
            //Getting pick list values from FieldSet
            List<FieldSetMember> lstFieldSetVar=new List<FieldSetMember>();
            List<FieldSetMember> listFieldSetPartnerVar=
            new List<FieldSetMember>();
            lstFieldSetVar=
            Utility.getFieldDetails(new Account(),sFieldSetName);
            listFieldSetPartnerVar=
            Utility.getFieldDetails(new Partner_Type__c(),
            sFieldNamePartnerType);
            mapCheckboxFieldset.put(sFieldSetName,lstFieldSetVar);
            List<FieldSetMember> lstPartnerType=new List<FieldSetMember>();
            
            
            Partner_Type__c oPartnerObjVar;
            for(Partner_Type__c oPartnerTypeVar:lstPartner){
                if(oPartnerTypeVar.Type__c==sFieldVar){
                    oPartnerObjVar=oPartnerTypeVar;
                    
                    mapHistory.put(oPartnerObjVar.Id,oPartnerObjVar.Type__c);
                    
                }
            }
            if(oPartnerObjVar==null)
            oPartnerObjVar=new Partner_Type__c();
            
            //Setting Partner Type values in Map
            mapCheckboxFieldsetPartnerType.put
            (sFieldNamePartnerType,listFieldSetPartnerVar);
            mapFieldPartnerType.put(sFieldName,sFieldNamePartnerType);
            mapPartnerTypeData.put(sFieldSetName,oPartnerObjVar);

        }

        lstHistoryWrapperFinal=getHistoryDetails(mapHistory);
        lstPartnerTypeVal=new List<String>();
        lstPartnerTypeVal.addAll(mapCheckboxFieldset.keySet());
        lstPartnerTypeVal.sort();
        
    }
    //This method is used to toggle between read only to edit mode
    public void changePageMode(){

        bIsOutputPage=false;

    }
    /**
    * Method name  : save
    * Description  : Use this method to create and 
    save existing new partner type 
                     and their values
    *                
    * Return Type  : void
    * Parameter    : void
    **/ 
    public void save(){

        String sPickListValue='';
        List<Partner_Type__c> lstDelete=
        new List<Partner_Type__c>();
        List<Partner_Type__c> lstPartnerClone=
        new List<Partner_Type__c>();
        lstPartnerClone=lstPartner.clone();
        Map<String,Id> mapRecordtypeId=
        Utility.getRecordTypeMap('Partner_Type__c');
        lstPartner.clear();
        for(String sPicklistVar:mapFieldCheckbox.keySet()){

            if(mapFieldCheckbox.get(sPicklistVar)==true)
            sPickListValue+=sPicklistVar+';';
            
            Partner_Type__c oPartnerObjVar=new Partner_Type__c();
            for(Partner_Type__c oPartnerVar:
            mapPartnerTypeData.values()){
                if(oPartnerVar.Type__c==sPicklistVar){
                    
                    oPartnerVar.recordTypeId=mapRecordtypeId.get(sPicklistVar);  
                    lstPartner.add(oPartnerVar);
                }
            }
            
            
            if(mapFieldCheckbox.get(sPicklistVar)==false){                
                for(Partner_Type__c oPartnerVar:lstPartnerClone){
                    if((oPartnerVar.Type__c==sPicklistVar)
                    &&(oPartnerVar.Id!=null)){
                        
                        oPartnerVar.recordTypeId=
                        mapRecordtypeId.get(sPicklistVar);  
                        lstDelete.add(oPartnerVar);
                    }
                }                
            }

        }
        sPickListValue=sPickListValue.substringBeforeLast(';'); 
        oAccount.Partner_Profile_Type__c=sPickListValue;
        boolean bIsErrorOccurred=false;
        try{

            update oAccount;
        }
        catch(Exception ex){
            
            ApexPages.addMessage(new ApexPages.Message
            (ApexPages.Severity.ERROR,
            System.label.AccountUpdateError+' '+ex.getMessage()
           .subStringAFter('FIELD_CUSTOM_VALIDATION_EXCEPTION,').subStringBefore
            (': []')));
            bIsErrorOccurred=true;
            
            //Creating a new Error Log record whenever 
            //any exception is encountered while performing DML Operation
            Error_Log__c oErrorLog = new Error_Log__c();
            oErrorLog.Error_Message__c = ex.getMessage()+'\n'
            +ex.getStackTraceString();
            oErrorLog.sObject__c = 'Account';
            oErrorLog.Related_Record_Id__c = oAccount.id;
            oErrorLog.Error_Module__c = 'PartnerTypeInlineExtension';
            oErrorLog.Error_Sub_Module__c = 'save';
            oErrorLog.Error_Type__c = 'Application';
            oErrorLog.Logged_In_User__c = UserInfo.getUserId();
            oErrorLog.New_Instance__c = String.valueOf(oAccount);
            Utility.insertErrorLog(oErrorLog);
            
        }

        List<Database.UpsertResult> listUpsertResult=
        Database.upsert(lstPartner);
        for(Database.UpsertResult upsertResult: listUpsertResult){
            if (upsertResult.isSuccess()) {
                // Operation was successful, 
                //so get the ID of the record that was processed
                
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : upsertResult.getErrors()) {
                   
                    
                }
            }       
        } 

        mapHistory=new Map<Id,String>();

        for(Partner_Type__c oPartnerVar: lstPartner)
        mapHistory.put(oPartnerVar.Id,oPartnerVar.Type__c);
        if(mapHistory.size()!=0)
        lstHistoryWrapperFinal=getHistoryDetails(mapHistory);
        String sQuery=
        Utility.getQueryUsingFieldSet(Utility.getFieldDetails
        (new Partner_Type__c(),'PartnerAllField'));
        sQuery+='Id from Partner_Type__c where Account__c=:accountId';
        lstPartner=(List<Partner_Type__c>)Database.query(sQuery);
        if(!bIsErrorOccurred)
        bIsOutputPage=true;
        else
        bIsOutputPage=false;

    }
    /**
    * Method name  : getHistoryDetails
    * Description  : Use this method to query and 
    save partner type historical data.
    *                
    * Return Type  : List<HistoryDetails>
    * Parameter    : Map<Id,String>
    **/ 
    private List<HistoryDetails> getHistoryDetails
    (Map<Id,String> mapPartnerType){
        
        List<Partner_Type__History > lstHistory=
        new List<Partner_Type__History >();
        List<HistoryDetails> lstHistoryWrapper=new List<HistoryDetails>();
       
        Set<Id> setUserId=new Set<Id>();
        //Querying history object
        lstHistory=[select Id,ParentId, OldValue, NewValue, Field, 
        CreatedById, CreatedDate 
        FROM Partner_Type__History where ParentId IN :mapPartnerType.keySet() 
        order by CreatedDate desc];
         
        
        Set<String> setFieldName=new Set<String>();
        for(Partner_Type__History oPartnerVar :lstHistory)
        setFieldName.add(((String)oPartnerVar.Field).contains('__c')
        ?(String)oPartnerVar.Field:null );
        
        List<String> lstFieldName=new List<String>();
        lstFieldName.addAll(setFieldName);
        Map<String,String> mapFieldLabel=getFieldLabel(lstFieldName);
        for(Partner_Type__History oPartnerHistory : lstHistory ){
            
            HistoryDetails historyVar=new HistoryDetails();
            if(!oPartnerHistory.Field.equalsIgnoreCase(System.label.Created)){
                if((oPartnerHistory.NewValue!=null)
                &&(!((String)oPartnerHistory.NewValue).startsWith
                (System.label.UserPrefix)))
                historyVar.sNewValue=(String)oPartnerHistory.NewValue;
                if((oPartnerHistory.OldValue!=null)
                &&(!((String)oPartnerHistory.OldValue).startsWith
                (System.label.UserPrefix)))
                historyVar.sOldValue=(String)oPartnerHistory.OldValue;
                historyVar.sField=oPartnerHistory.Field;
            }
            else
            historyVar.sField=oPartnerHistory.Field;
            
           historyVar.sPartnerType=mapPartnerType.get(oPartnerHistory.ParentId);
            if(historyVar.sField!=System.label.Created)
            historyVar.sChangeHistory='Changed <b>'
            +((mapFieldLabel.get(historyVar.sField)!=null)
            ?mapFieldLabel.get(historyVar.sField):historyVar.sField)
            +'</b> from '+historyVar.sOldValue+' to <b>'
            +historyVar.sNewValue+'</b>';
            else
            historyVar.sChangeHistory='Created.';
            
            
            historyVar.oChangedBy=new User(Id=oPartnerHistory.CreatedById);
            setUserId.add(oPartnerHistory.CreatedById);
            historyVar.sModifiedDate=
            DateTime.valueOf(oPartnerHistory.CreatedDate).format();
            if(((historyVar.sOldValue!=null)||(historyVar.sNewValue!=null))
            ||(historyVar.sField.equalsIgnoreCase('created')))
            lstHistoryWrapper.add(historyVar);
            
            
        }

        List<User> listUser=[Select Id,Name from User where Id IN :setUserId];

        for(USer userVar:listUser){

            for(HistoryDetails historyVar: lstHistoryWrapper){
                
                if(historyVar.oChangedBy.Id==userVar.Id)
                historyVar.oChangedBy=userVar;
            }
        }
        return lstHistoryWrapper;

    }

    public class HistoryDetails{

        public String sPartnerType{get;set;}
        public String sChangeHistory{get;set;}
        public String sOldValue{get;set;}
        public String sNewValue{get;set;}
        public String sField{get;set;}
        public User oChangedBy{get;set;}
        public String sModifiedDate{get;set;}
        
        public HistoryDetails(){

        }

    }

    public void getHistory(){

        if(mapHistory.size()!=0)
        lstHistoryWrapperFinal=getHistoryDetails(mapHistory);
       
    }
    /**
    * Method name  : getFieldLabel
    * Description  : Use this method to get all pick list value 
                     of any pick list field
    *                
    * Return Type  : Map<Id,String>
    * Parameter    : List<HistoryDetails>
    **/ 

    private Map<String,String> getFieldLabel(List<String> lstFieldName){
        Map<String,String> mapFieldLabel=new Map<String,String> (); 
        // this can accept list of strings, we describe only one object here
        List<Schema.DescribeSObjectResult> lstDescribeSobjectsResult = 
        Schema.describeSObjects(new List<String>{'Partner_Type__c'}); 
      
        String sObjectLabel = lstDescribeSobjectsResult[0].getLabel();
        Map<String, Schema.SObjectField> mapAllFields = 
        lstDescribeSobjectsResult[0].fields.getMap();
       
        for(String sFieldNameVar: lstFieldName){
            if((sFieldNameVar!=null)
            &&(!sFieldNameVar.equalsIgnoreCase(System.label.Created)))
            mapFieldLabel.put(sFieldNameVar,
            mapAllFields.get(sFieldNameVar).getDescribe().getLabel());             
        }
        return mapFieldLabel;

    }
}