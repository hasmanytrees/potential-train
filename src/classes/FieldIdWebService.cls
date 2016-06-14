/*****************************************************************************
    Name             : FieldIdWebService
    Description      : Class used for dynamically identifying the field ids 
                       which can be used for binding values in Custom Buttons 
                       and Links.
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                 10/03/2015            Created
Apurva                 15/09/2015            Modified code  
*******************************************************************************/

global class FieldIdWebService{

    // Get object key prefix.
    Static String sObjectName;
    
    webservice static String getObjectKeyPrefix(String sParameterObjectName){
    
      sObjectName=sParameterObjectName;
        return ('/' + Schema.getGlobalDescribe().get(sObjectName).newSObject
        ().getSObjectType().getDescribe().getKeyPrefix() + '/e?nooverride=1');
    }
     
    // Get field Id of field by Its field label
    webservice static List<String> getFieldId(List<String> lstSfieldlabel,
    String sObjectName1,String sRecordtypeId){
    
        // Obtain the magic ids
        PageReference oPageReference ;
        if(sRecordtypeId != ''){
        oPageReference = new PageReference('/' + Schema.getGlobalDescribe
        ().get(sObjectName1).newSObject().getSObjectType().getDescribe
        ().getKeyPrefix() +
        '/e?RecordType='+sRecordtypeId+'&nooverride=1');
        }
        else{
            oPageReference = new PageReference('/' + Schema.getGlobalDescribe
            ().get(sObjectName1).newSObject().getSObjectType().getDescribe
            ().getKeyPrefix() +
            '/e?nooverride=1');
        }
        String sHtml  = oPageReference.getContent().toString();
        Map<String, String> labelToId = new Map<String, String>();
        Matcher m = Pattern.compile('<label for="(.*?)">(<span class = "requiredMark">\\*</span>)?(.*?)</label>').matcher(sHtml );
        Map<String,String> mapFieldId=new Map<String,String>();
        while (m.find()) {
            String label = m.group(3);
            String id = m.group(1);
            for(String field_LabelVar : lstSfieldlabel){
            if(label.equalsIgnoreCase(field_LabelVar)){
                mapFieldId.put( field_LabelVar,field_LabelVar+':'+id); 
                // return field Id.
           
            }
           }
        }
        return mapFieldId.values();
        
    }
    
}