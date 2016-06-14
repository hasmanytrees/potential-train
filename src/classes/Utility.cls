/******************************************************************************
    Name             : Utility
    Description      : This is generic Utility class used for various purpose.
    It contains methods which are used across project                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                            & optimization
Shanu                   6/11/2015             Code changes made for INC0067772
*******************************************************************************/
global with Sharing class Utility
{
    public static boolean bRecursive=false;
    public static boolean bDeliverableStopCancel=false;
    public static boolean bVShiftStopCancel=false;
    public static boolean bVSlotStopCancel=false;
    public Static String sMessageLead='';
    public static  Map<String,Schema.sObjectType> mapStructure;
    public static Boolean bIgnoreTaskOwnerChange = false;
    public Static boolean bIsSourceFromLead=false;
    public Static boolean bToCheckSupporterStatus=true;
    public Utility()
    {
    }
    /**
    * Method name  : getPicklistValues
    * Description  : this method is used to get all picklist value 
                    for any field specified
    *                
    * Return Type  : List<String>
    * Parameter    : String,String
    **/ 
    global static list<String> getPicklistValues(SObject oSObj, String sFId)
    {
        list<String> lstPicklist= new list<String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = oSObj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> mapField = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> lstPicklistEntry =
        mapField.get(sFId).getDescribe().getPickListValues();
        // Add these lstPicklistEntry to the selectoption list.
        for (Schema.PicklistEntry a : lstPicklistEntry)
        { 
            lstPicklist.add(a.getLabel());
        }
        return lstPicklist;
    }
    /**
    * Method name  : formatDate
    * Description  : this method is used to format any date in MM/DD/YYYY
    *                
    * Return Type  : String
    * Parameter    : Date
    **/ 
    public static String formatDate(Date dDateVar)
    {
        if(dDateVar!=null)
        {
            String sStr=String.valueOf(dDateVar);
            String yyyy=sStr.subStringBefore('-');
            sStr=sStr.subStringAfter('-');
            String mm=sStr.subStringBefore('-');
            String dd=sStr.subStringAfter('-');
            String dtFormat=mm+'/'+dd+'/'+yyyy;
            return  dtFormat;
        }
        else
        return '';
    }
    /**
    * Method name  : getRecordTypeMap2
    * Description  : this method is used to get a map of record type name 
                    and their Id
    *                
    * Return Type  : Map<String,String>
    * Parameter    : String
    **/
    public static Map<String,String> getRecordTypeMap2(String sObjectName)
    {
        // This method is used to return all the record types 
        //for corresponding Object. 
        if(mapStructure==null)
        {
            mapStructure=Schema.getGlobalDescribe();
        }
        Schema.SObjectType objType=mapStructure.get(sObjectName);
        Schema.DescribeSObjectResult objTypeResult=objType.getDescribe();
        Map<String,Schema.RecordTypeInfo> mapRecInfo=
        objTypeResult.getRecordTypeInfosByName();
        Set<String> setRecType = new Set<String>();
        Map<String,String> mapRecType = new Map<String,String>();
        setRecType = mapRecInfo.keySet();
        for(String rec : setRecType)
        {
            mapRecType.put(mapRecInfo.get(rec).getRecordTypeId(),rec);
        }
        return mapRecType; /*Returning the Record type Map*/
    } 
    /**
    * Method name  : getRecordType
    * Description  : this method is used to get a Id  record type based on name 
                    and object Name
    *                
    * Return Type  :Id
    * Parameter    : String,String    
    **/
    static webservice Id getRecordType(String sRecType,String sObjectName)
    {
        if(mapStructure==null)
        {
            mapStructure=Schema.getGlobalDescribe();
        }
        Schema.SObjectType objType=mapStructure.get(sObjectName);
        Schema.DescribeSObjectResult objTypeResult=objType.getDescribe();
        Map<String,Schema.RecordTypeInfo> mapRecInfo=
        objTypeResult.getRecordTypeInfosByName();
        /*Returning the Record type */
        return mapRecInfo.get(sRecType).getRecordTypeId(); 
    } 
    /**
    * Method name  : getRecordTypeMap
    * Description  : this method is used to get a map of record type name 
    and their Id
    *                
    * Return Type  : Map<String,Id>
    * Parameter    : String
    **/
    public static Map<String,Id> getRecordTypeMap(String sObjectName)
    {
        // This method is used to return all the record types 
        //for corresponding Object. 
        if(mapStructure==null)
        {
            mapStructure=Schema.getGlobalDescribe();
        }
        Schema.SObjectType objType=mapStructure.get(sObjectName);
        Schema.DescribeSObjectResult objTypeResult=objType.getDescribe();
        Map<String,Schema.RecordTypeInfo> mapRecInfo=
        objTypeResult.getRecordTypeInfosByName();
        Set<String> setRecType = new Set<String>();
        Map<String,Id> mapRecType = new Map<String,Id>();
        setRecType = mapRecInfo.keySet();
        for(String sRecordType : setRecType)
        {
            mapRecType.put
            (sRecordType,mapRecInfo.get(sRecordType).getRecordTypeId());
        }
        return mapRecType; /*Returning the Record type Map*/
    } 
    /**
    * Method name  : getFieldDetails
    * Description  : this method is used fieldset Members
    *                
    * Return Type  : List<Schema.FieldSetMember> 
    * Parameter    : String,String
    **/
    //Taking Object Instace and field set Name
    public static List<Schema.FieldSetMember> getFieldDetails
    (sObject oSObj,String sFieldSetName) 
    {
        Schema.DescribeSObjectResult d ;
        if(d==null)
        {
            d = oSObj.getSObjectType().getDescribe();
        } 
        Map<String, Schema.FieldSet> FsMap =   d.fieldSets.getMap();
        return FsMap.get(sFieldSetName).getFields();  //Returning the field
        //return null;
    }
    /**
    * Method name  : formatDate
    * Description  : this function helps in dateTime formatting from 
                    String value
    *                
    * Return Type  : Datetime
    * Parameter    : String
    **/    
    public static Datetime formatDate(String sEndDate)
    {
        
        sEndDate=EncodingUtil.urlDecode(sEndDate, 'UTF-8');
        String sMonth;
        String sDay;
        String sYear;
        String sHour;
        String sMinute;
        String sTmpStr=sEndDate;
        sMonth=sTmpStr.subStringBefore('/');
        sDay=sTmpStr.subStringAfter('/').subStringBefore('/');
        sYear=
        sTmpStr.subStringAfter('/').subStringAfter('/').subStringBefore(' ');
        sHour=
        sTmpStr.subStringAfter('/').subStringAfter('/').
        subStringAfter(' ').subStringBefore(':');
        sMinute=
        sTmpStr.subStringAfter('/').subStringAfter('/').
        subStringAfter(' ').subStringAfter(':').subStringBefore(' ');
        String sMeridian=
        sTmpStr.subStringAfter('/').subStringAfter('/').
        subStringAfter(' ').subStringAfter(':').subStringAfter(' ');
        if(sMonth.length()!=2)
        {
            sMonth='0'+ sEndDate.subStringBefore('/');
            
        }
        if(sDay.length()!=2)
        {
            sDay='0'+ sDay;
        }
        if(sHour.length()!=2)
        {
            sHour='0'+ sHour;
        }
        String sStringDate=
        sMonth+'-'+sDay+'/'+sYear+'/'+' '+sHour+':'+sMeridian;
        sStringDate=
        sYear+'-'+sMonth+'-'+sDay+' '+sHour+':'+sMinute+':00 '+sMeridian;
        DateTime dtDateTimeVar = datetime.valueOf(sStringDate);
        if(sMeridian=='AM')
        {
            dtDateTimeVar=dtDateTimeVar.addHours(-12);
        }
        
        return dtDateTimeVar;
    }
    /**
    * Method name  : getQueryUsingFieldSet
    * Description  : this function returns the query String from the field set
    *                
    * Return Type  : String
    * Parameter    : List<Schema.FieldSetMember>
    **/    
    public static String getQueryUsingFieldSet
    (List<Schema.FieldSetMember> lstFieldSetMember)
    {
        String sQuery='select ';
        for(Schema.fieldSetMember field:lstFieldSetMember)
        {
            sQuery+=field.getFieldPath()+',';
        }
        return sQuery;
    }
    /**
    * Method name  : getAllFieldList
    * Description  : this function returns tall fields present in any fieldset
    *                
    * Return Type  : List<selectOption>
    * Parameter    : List<Schema.FieldSetMember>
    **/ 
    public static List<selectOption> getAllFieldList
    (List<Schema.FieldSetMember> lstFieldSetMember)
    {
        List<selectOption> lstField=new List<SelectOption>();
        for(Schema.fieldSetMember field:lstFieldSetMember)
        {
            lstField.add(new selectOption(field.getLabel(),field.getLabel()));
        }
        return lstField;
    }
    /**
    * Method name  : getFieldNameList
    * Description  : this method uses existing static globaldescriberesult map 
                    to return list of all fields for multiple objects.
    *                
    * Return Type  : Map<String, List<String>>
    * Parameter    : List<String>
    **/ 
    public static Map<String, List<String>> getFieldNameList
    (List<String> lstObject){
        Map<String, List<String>> mapObjectFieldList = 
        new Map<String, List<String>>();
        if(mapStructure==null)
        {
            mapStructure=Schema.getGlobalDescribe();
        }
        for(String sObjName : lstObject)
        {
            Map<String, Schema.SObjectField> objFieldMap = 
            mapStructure.get(sObjName).getDescribe().fields.getMap();
            Set<String> fieldNameSet = new Set<String>();
            fieldNameSet = objFieldMap.keySet();
            List<String> lstFieldName = new List<String>();
            lstFieldName.addAll(fieldNameSet);
            mapObjectFieldList.put(sObjName,lstFieldName );
        }
        return mapObjectFieldList;
    } 
    /**
    * Method name  : getDateTimeValue
    * Description  : this method is used to form Date with GMT format 
    in integration
    *                
    * Return Type  : Datetime
    * Parameter    : String
    **/ 
    public static Datetime getDateTimeValue(String sDatetime){
        
        String sDate=sDatetime.split(' ').get(0)+' 00:00:00';
        String sTime=sDatetime.split(' ').get(1);
        Time timeVal=
        Time.newInstance(Integer.valueOf(sTime.split(':').get(0)),
        Integer.valueOf(sTime.split(':').get(1)),
        Integer.valueOf(sTime.split(':').get(2)),000);
        Date dateVal=Date.valueOf(sDate);
        
        return Datetime.newInstanceGMT(dateVal,timeVal);
    }
    /**
    * Method name  : getLocationText
    * Description  : this method is used to generate Event Description 
    for XMPie Integration
    *                
    * Return Type  : String
    * Parameter    : String,String,String,String,String,String
    **/ 
    public Static String getLocationText(String sCampaignName,
    String sStartDate ,String sEndDate,String sVenue,String sAddress,
    String sWebSite,boolean bIsHeader,Integer iEventNumber,
    boolean bIsEventDetails,String sDressCode, String sContact,
    String sEmail,String sPhone){
        String sLocationText='';
        if(bIsHeader)
        sLocationText+='<h5><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'>Event '
        +iEventNumber+
        '</font></h5><ul><li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'>';        
        else
        sLocationText+='<p><ul><li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'>';
        sLocationText+='<strong>Event Name:</strong> '+sCampaignName+
        '</font></li>';
        sLocationText+='<li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'><strong>Dates:</strong> '
        +sStartDate +' - '+sEndDate+'</font></li>';      
        sLocationText+='<li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'><strong>Location:</strong> '
        +sVenue+'</font></li>';               
        sLocationText+='<li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'><strong>Location Address:</strong> '+sAddress+'</font></li>';
        if(!bIsEventDetails) 
        sLocationText+='<li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'><strong>Event / Partner Website: </strong><a href=\''
        +sWebSite+'\'> '+sWebSite+'</a></font></li></ul>';        
        else{      
            sLocationText+='<li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'><strong>Dress Code:  </strong>'+sDressCode+'</font></li>';
            sLocationText+='<li><font size=\'2\' face=\'Arial,Helvetica,sans-serif\'><strong>Onsite Support Contact: </strong>'        
            +((sContact!=null)?sContact:'')+ ((sEmail!=null)?', ' + sEmail:'')
            +((sPhone!=null)?', ' +sPhone:'')+'</font></li></ul>';
        }
        if(bIsHeader)
        sLocationText+='';
        else
        sLocationText+='</p>';
        sLocationText=sLocationText.replaceAll('null','');
        return sLocationText;
    }
    /**
    * Method name  : insertErrorLogApplication
    * Description  : this method is used to log error during application 
                    execution
    *                
    * Return Type  : void
    * Parameter    : String,String,String,String,String,String,String,String,
                    String
    **/
    public static void insertErrorLogApplication(String sMessage,
    String sObjectString,String sRelatedRecordId,String sErrorModule,
    String sErrorSubModule,String sErrorType,Id userId,String sNewInstance,
    String sOldInstance){
        Error_Log__c oErrorLog=new Error_Log__c();
        oErrorLog.Error_Message__c=sMessage;
        oErrorLog.sObject__c = sObjectString;
        oErrorLog.Related_Record_Id__c = sRelatedRecordId;
        oErrorLog.Error_Module__c=sErrorModule;
        oErrorLog.Error_Sub_Module__c=sErrorSubModule;
        oErrorLog.Error_Type__c=sErrorType;
        oErrorLog.Logged_In_User__c=userId;
        oErrorLog.New_Instance__c = sNewInstance;
        oErrorLog.Old_Instance__c = sOldInstance;
        Utility.insertErrorLog(oErrorLog);
    }
    /**
    * Method name  : insertErrorLogIntegration
    * Description  : this method is used to log error during integration 
                    execution
    *                
    * Return Type  : void
    * Parameter    : String,String,String,String,String,String,String,
                    String,String
    **/ 
    public Static void  insertErrorLogIntegration(String sErrorCode,
    String sMessage,String sErrorModule,String sType,String sIntName,
    String sIntType,String sJSON,Id userId,String sMethod){
        Error_Log__c oErrorLog=new Error_Log__c();
        oErrorLog.Error_Code__c=sErrorCode;
        oErrorLog.Error_Message__c=sMessage;
        oErrorLog.Error_Module__c=sErrorModule;
        oErrorLog.Error_Type__c=sType;
        oErrorLog.Integration_Name__c=sIntName;
        oErrorLog.Integration_Type__c=sIntType;
        oErrorLog.JSON__c=sJSON;
        oErrorLog.Logged_In_User__c=userId;
        oErrorLog.Method_Causing_Error__c=sMethod;
        Utility.insertErrorLog(oErrorLog);
    }
    /**
    * Method name  : insertErrorLogIntegration2
    * Description  : this method is used to log error during integration scenario 2
                    execution
    *                
    * Return Type  : void
    * Parameter    : String,String,String,String,String,String,String,
                    String,String
    **/ 
    public Static void  insertErrorLogIntegration2(String sErrorCode,
    String sMessage,String sErrorModule,String sType,String sIntName,
    String sIntType,String sJSON,Id userId,String sMethod, String sNewInstance, String sEndpoint){
        Error_Log__c oErrorLog=new Error_Log__c();
        oErrorLog.Error_Code__c=sErrorCode;
        oErrorLog.Error_Message__c=sMessage;
        oErrorLog.Error_Module__c=sErrorModule;
        oErrorLog.Error_Type__c=sType;
        oErrorLog.Integration_Name__c=sIntName;
        oErrorLog.Integration_Type__c=sIntType;
        oErrorLog.JSON__c=sJSON;
        oErrorLog.Logged_In_User__c=userId;
        oErrorLog.New_Instance__c = sNewInstance;
        oErrorLog.Method_Causing_Error__c=sMethod;
        oErrorLog.Endpoint_URL__c = sEndpoint;
        oErrorLog.IsRepeatEnabled__C = true;
        Utility.insertErrorLog(oErrorLog);
    }
     /**
    * Method name  : insertErrorLogIntegration3
    * Description  : this method is used to log error during integration scenario 2
                    execution
    *                
    * Return Type  : void
    * Parameter    : String,String,String,String,String,String,String,
                    String,String
    **/ 
    public Static void  insertErrorLogIntegration3(String sErrorCode,
    String sMessage,String sErrorModule,String sType,String sIntName,
    String sIntType,String sJSON,Id userId,String sMethod, String sNewInstance, String sEndpoint,String shttpMethod){
        Error_Log__c oErrorLog=new Error_Log__c();
        oErrorLog.Error_Code__c=sErrorCode;
        oErrorLog.Error_Message__c=sMessage;
        oErrorLog.Error_Module__c=sErrorModule;
        oErrorLog.Error_Type__c=sType;
        oErrorLog.Integration_Name__c=sIntName;
        oErrorLog.Integration_Type__c=sIntType;
        oErrorLog.JSON__c=sJSON;
        oErrorLog.Logged_In_User__c=userId;
        oErrorLog.New_Instance__c = sNewInstance;
        oErrorLog.Method_Causing_Error__c=sMethod;
        oErrorLog.Endpoint_URL__c = sEndpoint;
        oErrorLog.IsRepeatEnabled__C = true;
        oErrorLog.Method__c=shttpMethod;
        Utility.insertErrorLog(oErrorLog);
    }
    /**
    * Method name  : insertErrorLog
    * Description  : this method is used to log error during application 
                    and integration execution
    *                
    * Return Type  : void
    * Parameter    : Error_Log__c 
    **/   
    public static void insertErrorLog(Error_Log__c oErrorLog){
        List<Error_Log__c> lstErrorRecords = new List<Error_Log__c>();
        try{
            if(oErrorLog.New_Instance__c <> null 
                    && oErrorLog.New_Instance__c.length() > 131072)
            {
                oErrorLog.New_Instance__c = oErrorLog.New_Instance__c.subString(0, 131071);
            }
            if(oErrorLog.Old_Instance__c <> null 
                    && oErrorLog.Old_Instance__c.length() > 131072)
            {
                oErrorLog.Old_Instance__c = oErrorLog.Old_Instance__c.subString(0, 131071);
            }
            if(oErrorLog.Related_Record_Id__c <> null 
                    && oErrorLog.Related_Record_Id__c.length() > 131072)
            {
                oErrorLog.Related_Record_Id__c = oErrorLog.Related_Record_Id__c.subString(0, 131071);
            }
            if(oErrorLog.JSON__c <> null && oErrorLog.JSON__c.length() > 131072)
            {
                oErrorLog.JSON__c = oErrorLog.JSON__c.subString(0, 131071);
            }
            lstErrorRecords.add(oErrorLog);
            if(lstErrorRecords.size() > 0)
            {
                upsert lstErrorRecords;
            }
        }
        catch(Exception ex){
            //Creating a new Error Log record whenever any 
            //exception is encountered while performing DML Operation
            Error_Log__c oNewErrorLog = new Error_Log__c();
            oNewErrorLog.Error_Message__c = ex.getMessage()+'\n'
            +ex.getStackTraceString();
            oNewErrorLog.sObject__c = 'Error Log';
            oNewErrorLog.Related_Record_Id__c = oErrorLog.Related_Record_Id__c;
            oNewErrorLog.Error_Module__c = 'Utility';
            oNewErrorLog.Error_Sub_Module__c = 'insertErrorLog';
            oNewErrorLog.Error_Type__c = 'Application';
            oNewErrorLog.Logged_In_User__c = UserInfo.getUserId();
            oNewErrorLog.New_Instance__c = String.valueOf(oErrorLog);
            lstErrorRecords.add(oErrorLog);
            if(lstErrorRecords.size() > 0)
            {
                upsert lstErrorRecords;
            }
        }
    } 
    /**
    * Method name  : retrieveRESTParameters
    * Description  : this method is used to retrieve REST Parameters
    *                
    * Return Type  : String 
    * Parameter    : Set<String> 
    **/  
    public static String retrieveRESTParameters(Set<String> lstRestParametersId)
    {
        String sRequestURL='';
        for(String sURLVar: lstRestParametersId){
            sRequestURL+=sURLVar+'='+RestContext.request.params.get(sURLVar)+'&';
        }
        sRequestURL=sRequestURL.subStringBeforeLast('&');
        RestContext.response.statusCode = 500 ; 
        return sRequestURL;
    }
    
    /**
    * Method name  : restrictTaskOwnerChange
    * Description  : this method is used to restrict change of task owner  
                    during master record's owner change
    *                
    * Return Type  : void
    * Parameter    : map
    **/  
    
    public static void retrictTaskOwnerChange(Map<Id, Id> mapOwners)
    {
        List<Task> lstTasks = [select id, WhatId, Initial_Task_Owner__c, OwnerId from Task where WhatId in :mapOwners.keyset()];
        for(Task oTaskVar : lstTasks)
        {
            if(oTaskVar.Initial_Task_Owner__c <> null)
            {
                oTaskVar.OwnerId = oTaskVar.Initial_Task_Owner__c;
            }
            else
            {
                oTaskVar.Initial_Task_Owner__c = mapOwners.get(oTaskVar.WhatId);
                oTaskVar.OwnerId = mapOwners.get(oTaskVar.WhatId);
            }
        }
        if(lstTasks.size() > 0)
        update lstTasks;
    }
    
    /**
    * Method name  : retrieveAllFieldsDynamicallyFromObjectForSOQL
    * Description  : This method is used to dynamically retrieve all the 
                    fields from the SObject being passed as parameter.
                    This will prevent the appearance of field not
                    queried exception to occur any more.
    *                
    * Return Type  : String
    * Parameter    : String
    **/
    
    public static String retrieveAllFieldsDynamicallyFromObjectForSOQL(String sObjectName)
    {
        SObjectType sObjType = Schema.getGlobalDescribe().get
        (sObjectName);
        Map<String,Schema.SObjectField> mapFieldSchema = 
        sObjType.getDescribe().fields.getMap();
        
        //Forming the query all fields for communication Preference object.
        String sQuery='select ';
        for(String sFieldVar: mapFieldSchema.keySet())
        sQuery+=sFieldVar+',';
        
        sQuery=sQuery.subStringbeforeLast(',');
        if(sObjectName == 'SBC_Communications__c')
        {
            sQuery += ',Beneficiary__r.Status__c, Beneficiary__r.Compass_Child_Key__c, Supporter__r.Legacy_Supporter_Id__c, Beneficiary__r.BEN_Id__c';
        }
        sQuery+=' from '+ sObjectName;
        
        return sQuery;
    }
    
    //Shanu-Nov 2015 Code changes made for INC0067772
    /**
    * Method name  : checkCreateAccess
    * Description  : this method is used to check whether the user has Create Access
    *                
    * Return Type  : Boolean
    * Parameter    : String
    **/ 
    
    webservice static Boolean checkCreateAccess(String ObjectName){
    sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ; 
    Schema.sObjectType objType = sObj.getSObjectType();  
    Boolean hasAccess = objType.getDescribe().isCreateable(); 
    return hasAccess ;  
  }
    
    //Shanu-Nov 2015 Code changes made for INC0067772
    /**
    * Method name  : checkUpdateAccess
    * Description  : this method is used to check whether the user has Update Access
    *                
    * Return Type  : Boolean
    * Parameter    : String
    **/ 
    //check if the user has Update access 
    webservice static Boolean checkUpdateAccess(String ObjectName){
    sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ; 
    Schema.sObjectType objType = sObj.getSObjectType();  
    Boolean hasAccess = objType.getDescribe().isUpdateable(); 
    return hasAccess ;  
  }   
    
}