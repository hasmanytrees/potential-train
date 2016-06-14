/******************************************************************************
Name             : AccountOwnerAssignmentHelper
Description      : Trigger Helper class used to handle 
the scenario of assigning initial account owner based on business rule                  
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
****************************************************************************/

public with Sharing class AccountOwnerAssignmentHelper{

    /**
    * Method name  : setNewAccountOwners
    * Description  : Use this method to set new Account Owner 
                     based on Business rule 
    *                
    * Return Type  : void
    * Parameter    : List<Account>
    **/  
    public static void setNewAccountOwners(List<Account> lstNewAccount){

        List<sObject> lstAccount=lstNewAccount;
        List<Account_Assignment_Rule__c> lstAllAssignmentRule=
        new  List<Account_Assignment_Rule__c>();
        Map<Integer,List<Account_Assignment_Rule__c>> mapRuleOrder=
        new  Map<Integer,List<Account_Assignment_Rule__c>>();
        
        // Getting all Businesses rules from Account Assignment Custom Setting
        lstAllAssignmentRule=Account_Assignment_Rule__c.getAll().values();   
        Set<Integer> setOrder=new Set<Integer>();
        Set<String> setName=new Set<String>();
        Map<String,User> mapUser=new Map<String,User>();

        //Getting Business Rule order and Related user to be assigned
        for(Account_Assignment_Rule__c oAssignVar:lstAllAssignmentRule){
        
            setOrder.add(Integer.valueOf(oAssignVar.Order__c));
            setName.add(oAssignVar.Owner__c);            
        }
        
        // Querying user object to get User Ids from the Owner Name 
        //specified in Business rule
        List<User> lstUser = new List<User>();
        
        lstUser=[select Id,Name from User 
        where Name IN :setName and UserType=:System.Label.Usertype_Standard];  
        
        //Forming map of User name and User record.
        for(User oUserVar:lstUser){
        
            mapUser.put(oUserVar.Name,oUserVar);
        }

        for(Integer iOrderVar:setOrder){
        
            List<Account_Assignment_Rule__c > lstAssignmentVar=
            new List<Account_Assignment_Rule__c >();
            for(Integer iIndex=0;
            iIndex<lstAllAssignmentRule.size();
            iIndex++){
                
                // Arranging all Business Rule based on Order 
                //in ascending order
                if(lstAllAssignmentRule[iIndex].Order__c==iOrderVar)
                lstAssignmentVar.add(lstAllAssignmentRule[iIndex]);
            }
            mapRuleOrder.put(iOrderVar,lstAssignmentVar);
        }
        
        // Code block to find matching rule
        for(sObject oRecordVar: lstAccount){  
        
            // It is used to find out if record matched with any rule
            Integer iCheck=0;  
            for(Integer iOrderVar: mapRuleOrder.keySet()){
            
                Integer iMatched=0;
                
                // If record matches with any rule ignore the iteration 
                //for that record.
                if(iCheck!=0){
                
                    continue;
                }
                for(Account_Assignment_Rule__c oRuleVar:
                mapRuleOrder.get(iOrderVar)){
                    
                    // Below are various matching criteria                    
                    if(oRuleVar.Operator__c==System.Label.EqualSign){
                    
                        if((oRecordVar.get(oRuleVar.Field__c)!=null)
                        &&((String.valueOf
                        (oRecordVar.get(oRuleVar.Field__c))).equalsIgnoreCase
                        ((String.valueOf(oRuleVar.Value__c)))))
                            iMatched++;
                        
                    }
                    else if(oRuleVar.Operator__c.equalsIgnoreCase
                    (System.label.Contains)){
                    
                        if((oRecordVar.get(oRuleVar.Field__c)!=null)
                        &&(((String)oRuleVar.Value__c).containsIgnoreCase
                        ((String)oRecordVar.get(oRuleVar.Field__c))))
                            iMatched++;
                        
                    }
                    else if(oRuleVar.Operator__c.equalsIgnoreCase
                    (System.label.NotContains)){
                    
                        if((oRecordVar.get(oRuleVar.Field__c)!=null)
                        &&(!((String)oRuleVar.Value__c).containsIgnoreCase
                        ((String)oRecordVar.get(oRuleVar.Field__c))))
                            iMatched++;
                        
                    }
                    
                }
                
                if(iMatched==mapRuleOrder.get(iOrderVar).size()){
                
                    oRecordVar.put(System.label.OwnerId,
                    mapUser.get(mapRuleOrder.get(iOrderVar).get(0).Owner__c).Id);
                    iCheck++;
                }
                
                
            }

        }

        
    }

}