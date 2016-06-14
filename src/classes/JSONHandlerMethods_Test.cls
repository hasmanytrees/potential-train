/*****************************************************************************************
    Name             : JSONHandlerMethods_Test
    Description      : This class is used as dynamic JSON Generator and 
                       also use 
                       in generating serialized String and de serialized 
                       list of sObject              
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(seeAllData=true)
public class JSONHandlerMethods_Test
{
    public static testMethod void testSerialize()
    {
        List<Account> lstAccounts = [select id,Type,Name, IsPartner, Account_Start_Date__c from Account Limit 100];
        
        Map<String,List<sObject>> mapOutput= 
            new Map<String,List<sObject>>();
            
        mapOutput.put('AccountBOResponseProcessGroup',lstAccounts);
        //Getting Final JSON String
        String sResponse=
        JSONHandlerMethods.serialize(mapOutput,
        System.Label.AccountBOResponseProcess); 
    }
}