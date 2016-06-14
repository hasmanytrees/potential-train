trigger AWTriggerVenue on Venue__c (after delete, after insert, after undelete, after update, before insert, before update) {
     
    // PLEASE CONFIGURE THE FOLLOWING 5 LINES.
    //
    // You need to provide at least the ObjectName and DisableFieldName variables.
     
    // The API Name of the object you are configuring this trigger for.
    String ObjectName = 'Venue__c';
     
    // The API Name of the Disable Duplicate Check field for this object. This should be a checkbox.
    String DisableFieldName = 'Disable_Duplicate_Check__c';
     
    // The threshold score which is used when looking for duplicates. values between 0 and 100
    Integer ThresholdScore = 75;
     
    // Set to true if you which to create search keys, set to false if you don't want to create search keys. Default = true
    Boolean CreateKey = true;
     
    // Set to true if you want to search for duplicates whenever a object is created or edited, false if you don't want this. Default = true
    Boolean FindDuplicates = true;
     
     
    // DO NOT CHANGE ANYTHING BELOW THIS LINE.
    /* 
    awduplicate2.AWCustomTriggerTools CustomTools = new awduplicate2.AWCustomTriggerTools();
     boolean useAdvanced = CustomTools.getConfigBoolean('awUseAdvancedSearch');
     
    if ((CreateKey && useAdvanced) || FindDuplicates) {
         
        Boolean storeObject;
        Map<String,String> StorageFields;
        StorageFields = CustomTools.getSearchKeyStorage(ObjectName);
        if (StorageFields != null) {
            storeObject = true;
        } else {
            storeObject = false;
        }
         
        if (trigger.isInsert || trigger.isUpdate || trigger.isUnDelete) {
            if (trigger.new.size() == 1) {
                 
                Integer i = 0;
                SObject obj = trigger.new[i];
                if (trigger.isInsert || (trigger.isUpdate && CustomTools.isObjectDifferent(trigger.oldMap.get(obj.Id), obj, ObjectName,null))) {
                    List<awduplicate2__awDCKeys__c> ExternalKeys = new List<awduplicate2__awDCKeys__c>();
                    if (CreateKey && useAdvanced) {
                         
                        Map<String,Set<String>> Keys = CustomTools.CreateKeys(obj, ObjectName);
                        Map<String,String> SplittedKeys = CustomTools.SplitKeys(Keys.get('AllKeys'));
                        if (storeObject) {
                            if (trigger.isBefore) {
                                obj.put(StorageFields.get('A'),SplittedKeys.get('A'));
                                obj.put(StorageFields.get('B'),SplittedKeys.get('B'));   
                            }
                         
                        } else {
                            if (trigger.isAfter) {
                                awduplicate2__awDCKeys__c KeyItem = new awduplicate2__awDCKeys__c(
                                    Name = obj.Id,
                                    awduplicate2__KeyA__c = SplittedKeys.get('A'),
                                    awduplicate2__KeyB__c = SplittedKeys.get('B'),
                                    awduplicate2__Object__c = ObjectName);
                                ExternalKeys.add(KeyItem);
                            }   
                        }
                    }
                    if (trigger.isBefore && FindDuplicates && UserInfo.isCurrentUserLicensed('awduplicate2')) {
                        if(boolean.valueof(obj.get(DisableFieldName)) == false) {
                            Map<String,List<awduplicate2.AWFindResult>> FoundResult = CustomTools.Find(obj, ObjectName, ThresholdScore, 'search');
                            if (!FoundResult.isEmpty()) {
                                obj.addError(CustomTools.getHTMLDuplicateMessage(FoundResult), false);
                            }   
                        }
                        obj.put(DisableFieldName,false);
                    }
                    Set<String> toDelete = new Set<String>();
                    toDelete.add(obj.Id);
                    CustomTools.deleteSearchKeysByIds(toDelete,ObjectName);
                    if (ExternalKeys.size() > 0) insert ExternalKeys;
                }
                 
            } else if (CustomTools.getConfigBoolean('awTriggerProcessDelta') && trigger.isAfter)  {
                List<awduplicate2__awDCDelta__c> Deltas = new List<awduplicate2__awDCDelta__c>();
                 
                for (Sobject deltaobj : trigger.new) {
                    boolean isDelta = false;
                    if (trigger.isUpdate) {
                        if (CustomTools.isObjectDifferentDelta(trigger.oldMap.get(deltaobj.Id), trigger.newMap.get(deltaobj.Id), ObjectName)) {
                            isDelta = true;
                        }
                    } else {
                        isDelta = true;
                    }   
                    if (isDelta) {
                        awduplicate2__awDCDelta__c Delta = new awduplicate2__awDCDelta__c(
                            Name = deltaobj.Id,
                            awduplicate2__ObjectName__c = ObjectName,
                            awduplicate2__DeltaType__c = 'Upsert');
                        Deltas.add(Delta);
                    }
                     
                }
                 
                if (Deltas.size() > 0) Upsert Deltas;
            }
        } else if (trigger.isDelete) {
            if (!storeObject) {
                Set<String> toDelete = new Set<String>();
                for (String DelId : trigger.oldMap.keySet()) {
                    toDelete.add(DelId);
                }
                CustomTools.deleteSearchKeysByIds(toDelete,ObjectName);
            }
        }
     
    }
   */  
}