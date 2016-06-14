/*******************************************************************************
    Name             : JSONHandlerMethods
    Description      : This class is used as dynamic JSON Generator and 
                       also use 
                       in generating serialized String and de serialized 
                       list of sObject
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
*******************************************************************************/
public with Sharing class JSONHandlerMethods{

    /**
    * Method name  : deserialize
    * Description  : Use this method to deserialize incoming JSON String
    *                
    * Return Type  : List<sObject>
    * Parameter    : String,String
    **/    

    public static List<sObject> deserialize(String sMsgStr,String sProcessName){

        //Getting JSON structure
        List<JSON_Structure__c> lstJsonStructure=[select Id,Name,
        Array_Token_Name__c,
        is_Array__c,JSON_Process__c,Field_Group__c,Object_API_Name__c,
        JSON_Process__r.Array_Token_Name__c,JSON_Process__r.Is_initial_Array__c
        from JSON_Structure__c where JSON_Process__r.Name=:sProcessName];
        sMsgStr = sMsgStr.unescapeJava();
        Integer iTotalNodes=lstJsonStructure.size();
        List<Object> lstDataArray=new List<Object>();
        Set<Id> setFieldGroupId=new  Set<Id>();
        Map<Id,Id> mapFieldGroup=new Map<Id,Id>();
        Map<Id,Map<Id,List<Field_Group_Element__c>>> mapFieldToken=
        new Map<Id,Map<Id,List<Field_Group_Element__c>>>();
        Map<Id,JSON_Structure__c> mapJsonStruc=new Map<Id,JSON_Structure__c>();
       
        //Extracting data from JSON
        boolean bIsInitialArray=lstJsonStructure.get
        (0).JSON_Process__r.Is_initial_Array__c;
        //If no node found adding one Top node called dummyNode
        String sInitialArrayNode=(lstJsonStructure.get(0).
        JSON_Process__r.Is_initial_Array__c)?lstJsonStructure.get(0).
        JSON_Process__r.Array_Token_Name__c : 'DummyNode';
       
        
        //Forming JSON if top Array is not there
        if(!bIsInitialArray)
        sMsgStr='{"'+sInitialArrayNode+'":['+sMsgStr+']}';
      
        for(JSON_Structure__c oJsonVar: lstJsonStructure){
            setFieldGroupId.add(oJsonVar.Field_Group__c);
            mapJsonStruc.put(oJsonVar.Id,oJsonVar);
            
        }
        //Getting related Field Group and Element
        List<Field_Group__c> lstFieldGroup=[select Id,Name,Object_API_Name__c,
        (select Id,Name,Date_Format__c,Field_API_Name__c,
        Field_Type__c,Token_Name__c,Not_Generate_Boolean_As_String__c
        from Field_Group_Elements__r) from Field_Group__c 
        where Id In :setFieldGroupId];
        

        Integer iIndex=0;
        Map<Id,List<Field_Group_Element__c>> mapFieldToken2= 
        new Map<Id,List<Field_Group_Element__c>>();
        for(Field_Group__c oGroupVar: lstFieldGroup)
        mapFieldToken2.put(oGroupVar.Id,oGroupVar.Field_Group_Elements__r);

        for(JSON_Structure__c oJsonVar: lstJsonStructure)
        mapFieldToken.put(oJsonVar.Id,new Map<Id,List<Field_Group_Element__c>>
        {oJsonVar.Field_Group__c=>mapFieldToken2.get(oJsonVar.Field_Group__c)});   
        Map<String, Object> mapDeserializedString=
        (Map<String, Object>) JSON.deserializeUntyped(sMsgStr);
        lstDataArray.addAll((List<Object>)(mapDeserializedString.get
        (sInitialArrayNode)));


        //Setting value of List of sObject from values
        List<sObject> lstSobj=new List<sObject>();
        for(Object objVar : lstDataArray){
            Map<String,Object> mapValue=(Map<String,Object>)objVar ;
            for(JSON_Structure__c oJsonStructureVar : lstJsonStructure){
                sObject oSObj=Schema.getGlobalDescribe().get
                (mapJsonStruc.get
                (oJsonStructureVar.Id).Object_API_Name__c).newSObject() ;
                Integer iiIndex=0;
                List<sObject> lstNodeSObject=new List<SObject>();
                String sArrayToken=''; 
                
                List<Object> lstNodeArray=new List<Object>();
                if(oJsonStructureVar.is_Array__c)
                //Getting Array Token
                sArrayToken=oJsonStructureVar.Array_Token_Name__c;  
                
                
                if(sArrayToken!=''){
                 lstNodeArray.addAll((List<Object>)(mapValue.get(sArrayToken)));
                }
                else
                lstNodeArray.add(objVar);
               
                
                Integer iArraySize=lstNodeArray.size();
                lstNodeSObject=new List<SObject>();
                
                for(Integer i=0;i<iArraySize;i++)
                lstNodeSObject.add(Schema.getGlobalDescribe().
                get(mapJsonStruc.get
                (oJsonStructureVar.Id).Object_API_Name__c).newSObject());
                                
                for(Field_Group_Element__c oFieldElementVar: 
                mapFieldToken.get(oJsonStructureVar.Id).get
                (oJsonStructureVar.Field_Group__c )){
                  
                    iiIndex=0;
                    //Integrating UnTyped Json and casting them
                    //based on Expected data type in Field Group Element
                    for(Object objVar2 : lstNodeArray){
                        
                    String sNodeString='';
                    Integer iNodeInteger=0;
                    Double dbNodeDouble=0.0;
                    Date dtNodeDate;
                    Boolean bNodeBoolean;
                    
                    DateTime dtmNodeDatetime;
                    Map<String,Object> mapValue2=(Map<String,Object>)(objVar2);
                    
                    if(mapValue2.ContainsKey(oFieldElementVar.Token_Name__c)){
                    //Setting field values 
                    if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('TEXT')
                    && ((String.valueOf(mapValue2.get
                    (oFieldElementVar.Token_Name__c)) <> null) 
                    && !(String.valueOf(mapValue2.get
                    (oFieldElementVar.Token_Name__c)).equalsIgnoreCase
                    ('null')) )){
                        sNodeString=(String)(mapValue2.get
                        (oFieldElementVar.Token_Name__c));
                           
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,sNodeString);
                            else
                            oSObj.put(oFieldElementVar.Field_API_Name__c,
                            sNodeString);
                            
                        }
                        else if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('TEXT')){
                            
                            sNodeString=null;
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,sNodeString);
                            else
                            oSObj.put
                            (oFieldElementVar.Field_API_Name__c,sNodeString);
                            
                        }
                        
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Integer')){
                            if(String.valueOf
                          (mapValue2.get(oFieldElementVar.Token_Name__c))!=null)
                            iNodeInteger=
                       (Integer)(mapValue2.get(oFieldElementVar.Token_Name__c));
                            else
                            iNodeInteger=null;
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,iNodeInteger);
                            else
                            oSObj.put
                            (oFieldElementVar.Field_API_Name__c,iNodeInteger);
                            
                        }
                        
                            if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                            ('Double')){
                            if(mapValue2.get
                            (oFieldElementVar.Token_Name__c)!=null)
                            dbNodeDouble=(Double)(mapValue2.get
                            (oFieldElementVar.Token_Name__c));
                            else
                            dbNodeDouble=null;
                           
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,dbNodeDouble);
                            else
                            oSObj.put
                            (oFieldElementVar.Field_API_Name__c,dbNodeDouble);
                            
                        }
                      if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('Date') 
                        && ((String.valueOf(mapValue2.get
                        (oFieldElementVar.Token_Name__c)) <> null) 
                        && !(String.valueOf(mapValue2.get
                        (oFieldElementVar.Token_Name__c)).equalsIgnoreCase
                        ('null')) )){                            
                            
                            if(String.valueOf(mapValue2.get
                            (oFieldElementVar.Token_Name__c)).contains('00:'))
                            {
                                String sTempString = 
                                String.valueOf(mapValue2.get
                                (oFieldElementVar.Token_Name__c));
                                
                                dtNodeDate=Date.valueOf
                                ((sTempString.substringBefore(' 00:')));
                            }
                            else
                            {
                                dtNodeDate=Date.valueOf((mapValue2.get
                                (oFieldElementVar.Token_Name__c)));
                            }
                            
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,dtNodeDate);
                            else
                            oSObj.put(oFieldElementVar.Field_API_Name__c,
                            dtNodeDate);
                            
                            
                        }
                        else if (oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Date') ){
                            dtNodeDate=null;
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,dtNodeDate);
                            else
                            oSObj.put(oFieldElementVar.Field_API_Name__c,
                            dtNodeDate);
                            
                        }
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Datetime') 
                        && ((mapValue2.get(oFieldElementVar.Token_Name__c) <> 
                        null) 
                        && !(String.valueOf(mapValue2.get
                        (oFieldElementVar.Token_Name__c)).equalsIgnoreCase
                        ('null')) )){
                            String sTempString = 
                            String.valueOf(mapValue2.get
                            (oFieldElementVar.Token_Name__c));
                           
                            
                            if(oFieldElementVar.Date_Format__c=='XMPie Format'){
                                //Specific for 2015-02-09T16:06:38.997Z
                                dtmNodeDatetime=(Datetime)JSON.deserialize
                                ('"'+sTempString+'"',datetime.class);
                                
                            }
                            else 
                            dtmNodeDatetime=Datetime.valueOf((sTempString));
                            
                            
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,dtmNodeDatetime);
                            else
                            oSObj.put(oFieldElementVar.Field_API_Name__c,
                            dtmNodeDatetime);
                            
                            
                        }
                        else if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Datetime') ){
                            
                            dtmNodeDatetime=null;
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,dtmNodeDatetime);
                            else
                            oSObj.put(oFieldElementVar.Field_API_Name__c,
                            dtmNodeDatetime);
                            
                            
                        }
                        String sTempString = 
                        String.valueOf(mapValue2.get
                        (oFieldElementVar.Token_Name__c));
                        //For Handling Boolean Data
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Boolean')){
                          if(! oFieldElementVar.Not_Generate_Boolean_As_String__c) {
                            if((String)mapValue2.get
                            (oFieldElementVar.Token_Name__c) <> null)
                            {
                            if((String.valueOf(mapValue2.get
                            (oFieldElementVar.Token_Name__c)).equalsIgnoreCase
                            ('FALSE'))
                            ||(String.valueOf(mapValue2.get
                            (oFieldElementVar.Token_Name__c)).
                            contains('F'))
                            ||(String.valueOf(mapValue2.get
                            (oFieldElementVar.Token_Name__c)).equalsIgnoreCase
                            ('"FALSE"')))
                            {
                                bNodeBoolean = false;
                            }
                            else
                            {
                                bNodeBoolean = true;
                            }
                           }
                          }
                           else{
                           
                              if((boolean)mapValue2.get
                            (oFieldElementVar.Token_Name__c) <> null)
                            {
                            if(boolean.valueOf(mapValue2.get
                            (oFieldElementVar.Token_Name__c))==false)
                            
                            {
                                bNodeBoolean = false;
                            }
                            else
                            {
                                bNodeBoolean = true;
                            }
                           
                           } 
                          }
                            if(iArraySize >1 )
                            lstNodeSObject[iiIndex++].put
                            (oFieldElementVar.Field_API_Name__c,bNodeBoolean );
                            else
                            oSObj.put
                            (oFieldElementVar.Field_API_Name__c,bNodeBoolean );
                            
                            
                        }
                        
                     }       
                        
                   }                  
                                    
                }
                if(lstNodeSObject.size()==1)
                lstSobj.add(oSObj);
                else
                lstSobj.addAll(lstNodeSObject);
                    
            }
        }

        return lstSobj; // returning sObjectList generated from method

    }
    /**
    * Method name  : serialize
    * Description  : Use this method to serialize incoming object to JSON String
    *                
    * Return Type  : List<sObject>
    * Parameter    : String,String
    **/    


    public static String serialize(Map<String,List<SObject>> mapData,
    String sProcessName){

        //Getting JSON structure from Process name 
        List<JSON_Structure__c> lstJsonStructure=[select Id,Name,
        Array_Token_Name__c,
        is_Array__c,JSON_Process__c,Field_Group__c,
        Field_Group__r.Name,Object_API_Name__c,
        JSON_Process__r.Array_Token_Name__c,
        JSON_Process__r.Is_initial_Array__c
        from JSON_Structure__c where JSON_Process__r.Name=:sProcessName];
        

        String sUserTimeZone=[select timezonesidkey from user 
        where Id=:UserInfo.getUserId()][0].timezonesidkey;
        Integer iTotalNodes=lstJsonStructure.size();
        List<Object> lstDataArray=new List<Object>();
        Set<Id> setFieldGroupId=new  Set<Id>();
        Map<Id,Id> mapFieldGroup=new Map<Id,Id>();
        Map<Id,Map<Id,List<Field_Group_Element__c>>> mapFieldToken=
        new Map<Id,Map<Id,List<Field_Group_Element__c>>>();
        Map<Id,JSON_Structure__c> mapJsonStruc=new Map<Id,JSON_Structure__c>();
        
        for(JSON_Structure__c oJsonVar: lstJsonStructure){
        
            setFieldGroupId.add(oJsonVar.Field_Group__c);
            mapJsonStruc.put(oJsonVar.Id,oJsonVar);
        }

        List<Field_Group__c> lstFieldGroup=[select Id,Name,Object_API_Name__c,
        (select Id,Name,Date_Format__c,Field_API_Name__c,Field_Type__c,
        Token_Name__c,Not_Generate_Boolean_As_String__c,Order__c from 
        Field_Group_Elements__r order by Order__c) 
        from Field_Group__c where Id In :setFieldGroupId];
        
        //Forming Token based of Field group and Field group element
        Integer iIndex=0;
        Map<Id,List<Field_Group_Element__c>> mapFieldToken2= 
        new Map<Id,List<Field_Group_Element__c>>();
        for(Field_Group__c oGroupVar: lstFieldGroup)
        mapFieldToken2.put(oGroupVar.Id,oGroupVar.Field_Group_Elements__r);

        for(JSON_Structure__c oJsonVar: lstJsonStructure)
        mapFieldToken.put(oJsonVar.Id,new Map<Id,List<Field_Group_Element__c>>
        {oJsonVar.Field_Group__c=>mapFieldToken2.get(oJsonVar.Field_Group__c)});  
        
        boolean bIsInitialArray=lstJsonStructure.get(0)
        .JSON_Process__r.Is_initial_Array__c;
        String sInitialArrayToken=lstJsonStructure.get(0)
        .JSON_Process__r.Array_Token_Name__c;
        JSONGenerator gen = JSON.createGenerator(true);
        String sJsonStr='{\n';
        Integer iiIndex=0; 
        for(JSON_Structure__c oJsonStructureVar : lstJsonStructure){

            if(iiIndex==0){
                //For outer Array 
                if(bIsInitialArray){
                    sJsonStr+='"'+sInitialArrayToken+'" :';
                    sJsonStr+='[\n';
                    sJsonStr+='{\n';
                }
            }
            iiIndex++;
           
            List<sObject> lstDataArraysObject=new List<sObject> ();
            lstDataArraysObject=mapData.get
            (oJsonStructureVar.Field_Group__r.Name);
            
            if(oJsonStructureVar.is_Array__c){
                
                sJsonStr+='"'+oJsonStructureVar.Array_Token_Name__c+'" :';
                sJsonStr+='[\n';               
                
            }
            
            Integer iiIndex2=0;
            for(sObject oSObj : lstDataArraysObject){                
                
                //Forming external Array
                if(oJsonStructureVar.is_Array__c){
                    sJsonStr+='{\n';
                    
                }
                
                //Checking for various kind of data type and setting value in 
                //JSON String
                for(Field_Group_Element__c oFieldElementVar: mapFieldToken.get
                (oJsonStructureVar.Id).get(oJsonStructureVar.Field_Group__c )){
                    
                    
                    //Handling Field Values based of Field Type 
                    if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('TEXT')){
                     String sTmpString=(String)(oSObj.get
                     (oFieldElementVar.Field_API_Name__c));
                      if((((String)(oSObj.get
                      (oFieldElementVar.Field_API_Name__c)))!=null)
                      &&((sTmpString).contains('"')==true)){
                       
                        sTmpString=(sTmpString).replace('"','\\"');
                       oSObj.put(oFieldElementVar.Field_API_Name__c,sTmpString);
                        
                      }
                  
                    sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                  +(String)(oSObj.get(oFieldElementVar.Field_API_Name__c))+'",';
                                        
                    }
                  if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('Integer'))
                    sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                    +Integer.valueOf(oSObj.get
                    (oFieldElementVar.Field_API_Name__c))+',';
                    
                    
                   if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('Double'))
                    sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                    +Double.valueOf(oSObj.get
                    (oFieldElementVar.Field_API_Name__c))+',';
                                        
                    if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('Date'))
                    sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                    +Date.valueOf(oSObj.get
                    (oFieldElementVar.Field_API_Name__c))+'",';
                    
                    
                    if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                    ('Datetime')){
                        
                        if(oFieldElementVar.Date_Format__c=='XMPie Format'){
                            if(oSObj.get
                            (oFieldElementVar.Field_API_Name__c)!=null)
                            sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                            +(String.valueOf(oSObj.get
                            (oFieldElementVar.Field_API_Name__c))).replace
                            (' ','T')+'Z'+'",';
                            else
                       sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"null",';
                            
                        }
                        else if(oFieldElementVar.Date_Format__c==
                        'Local Time Format'){
                            
                            if(oSObj.get(oFieldElementVar.Field_API_Name__c)
                            !=null){
                             sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                                +((Datetime)oSObj.get
                                (oFieldElementVar.Field_API_Name__c)).format
                               (('YYYY-MM-dd\'T\'HH:mm:ss'),sUserTimeZone)+'",';
                             
                            }else
                       sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"null",';
                                                        
                        }
                        else
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                        +Datetime.valueOf(oSObj.get
                        (oFieldElementVar.Field_API_Name__c))+'",';
                                                
                    }
                    
                 if((oFieldElementVar.Field_Type__c.equalsIgnoreCase('Boolean'))
                 &(oFieldElementVar.Not_Generate_Boolean_As_String__c==false)){
                        
                        if(oSObj.get(oFieldElementVar.Field_API_Name__c)!=null)
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                        +Boolean.valueOf(oSObj.get
                        (oFieldElementVar.Field_API_Name__c))+'",';
                        else
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                        +Boolean.valueOf('false')+'",';
                        
                    }
                else if((oFieldElementVar.Field_Type__c.equalsIgnoreCase(
                'Boolean'))                    
                  &&(oFieldElementVar.Not_Generate_Boolean_As_String__c==true)){
                        
                        if(oSObj.get(oFieldElementVar.Field_API_Name__c)!=null)
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                        +Boolean.valueOf(oSObj.get
                        (oFieldElementVar.Field_API_Name__c))+',';
                        else
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                        +Boolean.valueOf('false')+',';
                        
                    }
                    
                }

                //Ending inner Array
                if(oJsonStructureVar.is_Array__c){
                    sJsonStr=sJsonStr.substringBeforeLast(',');
                    sJsonStr+='\n},';
                    
                } 

            } 
            if(oJsonStructureVar.is_Array__c){
                //Adding End Array
               
                sJsonStr=sJsonStr.substringBeforeLast(',');
                
                sJsonStr+='\n],';   
                
            }
            
        }
        sJsonStr=sJsonStr.substringBeforeLast(',');
        
        sJsonStr+='\n}'; 

        if(bIsInitialArray){
            sJsonStr+='\n]';
            sJsonStr+='\n}';
            
        }
        String sStrTemp=sJsonStr;
        sJsonStr='';
        sJsonStr+=sStrTemp;
        sStrTemp='';
        List<String> lstObj=sJsonStr.split('\n',sJsonStr.length());
        for(String sStrVar :lstObj){
            
            sStrTemp+=sStrVar;
            
        }
        return sStrTemp; 
    }
    /**
    * Method name  : serializeBulk
    * Description  : Use this method to serialize incoming object 
                     to JSON String for 2 level structure
    *                
    * Return Type  : String
    * Parameter    : List<Map<String,List<sObject>>>,String
    **/    
    public static String serializeBulk
    ( List<Map<String,List<sObject>>> mapOutput,
    String sProcessName){
        
        List<JSON_Structure__c> lstJsonStructure=[select Id,Name,
        Array_Token_Name__c,
        is_Array__c,JSON_Process__c,Field_Group__c,Object_API_Name__c,
        JSON_Process__r.Array_Token_Name__c,JSON_Process__r.Is_initial_Array__c,
        Field_Group__r.Name from JSON_Structure__c 
        where JSON_Process__r.Name=:sProcessName];
        
        String sUserTimeZone=[select timezonesidkey from user 
        where Id=:UserInfo.getUserId()][0].timezonesidkey;
        Integer iTotalNodes=lstJsonStructure.size();
        List<Object> lstDataArray=new List<Object>();
        Set<Id> setFieldGroupId=new  Set<Id>();
        Map<Id,Id> mapFieldGroup=new Map<Id,Id>();
        String sMsgStr='';
        Map<Id,Map<Id,List<Field_Group_Element__c>>> mapFieldToken=
        new Map<Id,Map<Id,List<Field_Group_Element__c>>>();
        Map<Id,JSON_Structure__c> mapJsonStruc=new Map<Id,JSON_Structure__c>();
        boolean bIsInitialArray=lstJsonStructure.get(0).
        JSON_Process__r.Is_initial_Array__c;
        String sInitialArrayNode=
        (lstJsonStructure.get(0).
        JSON_Process__r.Is_initial_Array__c)?lstJsonStructure.get(0).
        JSON_Process__r.Array_Token_Name__c : 'DummyNode';
        
        if(!bIsInitialArray)
        sMsgStr='{"'+sInitialArrayNode+'":['+sMsgStr+']}';
      
        //Getting JSON Structure from process    
        for(JSON_Structure__c oJsonVar: lstJsonStructure){
            setFieldGroupId.add(oJsonVar.Field_Group__c);
            mapJsonStruc.put(oJsonVar.Id,oJsonVar);
           
        }
        //Getting field group list 
        List<Field_Group__c> lstFieldGroup=[select Id,Name,Object_API_Name__c,
        (select Id,Name,Date_Format__c,Field_API_Name__c,Field_Type__c,
        Token_Name__c,Not_Generate_Boolean_As_String__c
        from Field_Group_Elements__r) from Field_Group__c 
        where Id In :setFieldGroupId];

        String sJsonString='';
        Integer iiIndex=0;
        if(mapOutput.size()>1){
            //Sending JSONBulkHelper for each iteration
            for(Map<String,List<sObject>> tokenVar: mapOutput){

                String  sJsonStringVar=serializeBulkHelper(lstFieldGroup,
                lstJsonStructure,tokenVar,sUserTimeZone);
                
                sJsonStringVar=sJsonStringVar.subStringBeforeLast(']}');
               
                sJsonStringVar=sJsonStringVar.subStringAfter('{"'
                +sInitialArrayNode+'" :[');
               
                sJsonString+=sJsonStringVar;
                
                if(iiIndex==mapOutput.size()-1){
                    
                    
                    sJsonString='{\n"'+sInitialArrayNode+'":[\n'+sJsonString
                    +'\n]\n}';
                }else{
                    sJsonString+=',\n';
                    
                }
                
                
                iiIndex++;
                

            }
        }
        else{


            sJsonString=serializeBulkHelper(lstFieldGroup,lstJsonStructure,
            mapOutput.get(0),sUserTimeZone);

        }
        return sJsonString;

    }

    /**
    * Method name  : serializeBulkHelper
    * Description  : Use this method to serialize incoming object 
                     to JSON String for 2 level structure
    *                
    * Return Type  : String
    * Parameter    : List<Field_Group__c>,List<JSON_Structure__c>,
                     Map<String,List<SObject>>
    **/    
   private static String serializeBulkHelper(List<Field_Group__c> lstFieldGroup,
    List<JSON_Structure__c> lstJsonStructure ,Map<String,List<SObject>> mapData,
    String sUserTimeZone){
        Integer iIndex=0;
        Integer iTotalNodes=lstJsonStructure.size();
        List<Object> lstDataArray=new List<Object>();
        Set<Id> setFieldGroupId=new  Set<Id>();
        Map<Id,Id> mapFieldGroup=new Map<Id,Id>();
        Map<Id,Map<Id,List<Field_Group_Element__c>>> mapFieldToken=
        new Map<Id,Map<Id,List<Field_Group_Element__c>>>();
        Map<Id,JSON_Structure__c> mapJsonStruc=new Map<Id,JSON_Structure__c>();
        Map<Id,List<Field_Group_Element__c>> mapFieldToken2= 
        new Map<Id,List<Field_Group_Element__c>>();

        //Getting field group
        for(Field_Group__c oGroupVar: lstFieldGroup)
        mapFieldToken2.put(oGroupVar.Id,oGroupVar.Field_Group_Elements__r);
        //Getting JSON Structure
        for(JSON_Structure__c oJsonVar: lstJsonStructure)
        mapFieldToken.put(oJsonVar.Id,
        new Map<Id,List<Field_Group_Element__c>>{oJsonVar.Field_Group__c=>
        mapFieldToken2.get(oJsonVar.Field_Group__c)});  
        
        boolean bIsInitialArray=lstJsonStructure.get(0)
        .JSON_Process__r.Is_initial_Array__c;
        String sInitialArrayToken=lstJsonStructure.get(0)
        .JSON_Process__r.Array_Token_Name__c;
        JSONGenerator gen = JSON.createGenerator(true);
        String sJsonStr='{\n';
        Integer iiIndex=0; 
        //Forming Outer array
        for(JSON_Structure__c oJsonStructureVar : lstJsonStructure){

            if(iiIndex==0){
                
                if(bIsInitialArray){
                    sJsonStr+='"'+sInitialArrayToken+'" :';
                    sJsonStr+='[\n';
                    sJsonStr+='{\n';
                }
            }
            iiIndex++;            
           
            List<sObject> lstDataArraysObject=new List<sObject> ();
            lstDataArraysObject=mapData.get
            (oJsonStructureVar.Field_Group__r.Name);
            
           
            if(oJsonStructureVar.is_Array__c){
              
                sJsonStr+='"'+oJsonStructureVar.Array_Token_Name__c+'" :';
                sJsonStr+='[\n';
            }
            
            if(lstDataArraysObject.size()==0){
                
                sJsonStr+='{,';
                if(oJsonStructureVar.is_Array__c){
                    sJsonStr=sJsonStr.substringBeforeLast(',');
                    sJsonStr+='},';
                } 

                
                if(oJsonStructureVar.is_Array__c){
                   
                    sJsonStr=sJsonStr.substringBeforeLast(',');
                    
                    sJsonStr+='],';                       
                    
                }
                
            }
            else{                 
               
                Integer iiIndex2=0;
                for(sObject oSObj : lstDataArraysObject){
                    
                    
                    if(oJsonStructureVar.is_Array__c){
                        sJsonStr+='{\n';
                    }
                    
                    //Forming string values based on data type
                    for(Field_Group_Element__c oFieldElementVar: 
                    mapFieldToken.get(oJsonStructureVar.Id).get
                    (oJsonStructureVar.Field_Group__c )){
                       
                        
                   if(oFieldElementVar.Field_Type__c.equalsIgnoreCase('TEXT')){
                        
      String sTmpString=(String)(oSObj.get(oFieldElementVar.Field_API_Name__c));
            if((((String)(oSObj.get(oFieldElementVar.Field_API_Name__c)))!=null)
                      &&((sTmpString).contains('"')==true)){
                       
                        sTmpString=(sTmpString).replace('"','\\"');
                       oSObj.put(oFieldElementVar.Field_API_Name__c,sTmpString);                      
                        
                      }
                        
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                        +(String)(oSObj.get(
                        oFieldElementVar.Field_API_Name__c))+'",';                       
                        
                        }
                        
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Integer'))
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                        +Integer.valueOf(oSObj.get(
                        oFieldElementVar.Field_API_Name__c))+',';
                        
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Double'))
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                        +Double.valueOf(oSObj.get(
                        oFieldElementVar.Field_API_Name__c))+',';
                        
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Date'))
                        sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                        +Date.valueOf(oSObj.get(
                        oFieldElementVar.Field_API_Name__c))+'",';
                        
                        if(oFieldElementVar.Field_Type__c.equalsIgnoreCase
                        ('Datetime')){
                            if(oFieldElementVar.Date_Format__c=='XMPie Format'){
                                if(oSObj.get(oFieldElementVar.Field_API_Name__c)
                                !=null)
                                sJsonStr+='"'+oFieldElementVar.Token_Name__c
                                +'":"'
                                +(String.valueOf(oSObj.get(
                                oFieldElementVar.Field_API_Name__c))).replace
                                (' ','T')+'Z'
                                +'",';
                                else
                                sJsonStr+='"'+oFieldElementVar.Token_Name__c
                                +'":"null",';
                                
                            }
                            
                            else if(oFieldElementVar.Date_Format__c
                            =='Local Time Format'){
                                
                                
                                if(oSObj.get(oFieldElementVar.Field_API_Name__c)
                                !=null)
                                sJsonStr+='"'+oFieldElementVar.Token_Name__c
                                +'":"'
                                +((Datetime)oSObj.get(
                                oFieldElementVar.Field_API_Name__c)).format(
                                ('YYYY-MM-dd\'T\'HH:mm:ss'),sUserTimeZone)
                                +'",';
                                else
                                sJsonStr+='"'+oFieldElementVar.Token_Name__c+
                                '":"null",';
                                
                            }
                                                        
                            else
                            sJsonStr+='"'+oFieldElementVar.Token_Name__c+
                            '":"'+Datetime.valueOf(oSObj.get
                            (oFieldElementVar.Field_API_Name__c))+'",';                            
                        }
                 if((oFieldElementVar.Field_Type__c.equalsIgnoreCase('Boolean'))                        
                 &&(oFieldElementVar.Not_Generate_Boolean_As_String__c==false))
                       {                            
                            if(oSObj.get(oFieldElementVar.Field_API_Name__c)
                            !=null)
                            sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                            +Boolean.valueOf(oSObj.get
                            (oFieldElementVar.Field_API_Name__c))
                            +'",';
                            else
                            sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":"'
                            +Boolean.valueOf('false')+'",';
                            
                        }
                        else if((oFieldElementVar.Field_Type__c
                        .equalsIgnoreCase('Boolean'))
                        &&(oFieldElementVar
                        .Not_Generate_Boolean_As_String__c==true)){
                            
                            if(oSObj.get(oFieldElementVar.Field_API_Name__c)
                            !=null)
                            sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                            +Boolean.valueOf(oSObj
                            .get(oFieldElementVar.Field_API_Name__c))
                            +',';
                            else
                            sJsonStr+='"'+oFieldElementVar.Token_Name__c+'":'
                            +Boolean.valueOf('false')+',';
                        }
                        
                    }

                    if(oJsonStructureVar.is_Array__c){
                        sJsonStr=sJsonStr.substringBeforeLast(',');
                        sJsonStr+='\n},';
                    } 

                } 
                if(oJsonStructureVar.is_Array__c){
                  
                    sJsonStr=sJsonStr.substringBeforeLast(',');
                    sJsonStr+='\n],';                       
                    
                }
            }
        }  
        sJsonStr=sJsonStr.substringBeforeLast(',');
        sJsonStr+='\n}'; 

        if(bIsInitialArray){
            sJsonStr+='\n]';
            sJsonStr+='\n}';
        }


        String sStrTemp=sJsonStr;
        sJsonStr='';
        sJsonStr+=sStrTemp;
        sStrTemp='';
        List<String> lstObj=sJsonStr.split('\n',sJsonStr.length());
        for(String strVar :lstObj){
            
            sStrTemp+=strVar;
            
        }
       
        return sStrTemp; 


    } 

}