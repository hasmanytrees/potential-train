/*******************************************************************************
Name             : SBCCommunicationStatusAssignment
Description      : Trigger Handler class used for assigning 
                   Exception Reason based on provided Business Parameters
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Sumeet                25/08/2015            Created
*******************************************************************************/

public without Sharing class SBCCommunicationStatusAssignment
{

    /**
    * Method name  : assignStatusBasedOnCondition
    * Description  : Use this method to assign the Status
    *                and Exception Reason based on matched conditions
    * Return Type  : void
    * Parameter    : Map<SBC_Communications__c, String>
    **/
    
    public void assignStatusBasedOnCondition(Map<SBC_Communications__c, String> mapSBCRecords)
    {
        Set<SBC_Communications__c> setSBCRecords = mapSBCRecords.keyset();      
        
        for(SBC_Communications__c oSBCCommVar: setSBCRecords)
        {
            System.debug(mapSBCRecords.get(oSBCCommVar));
            if(mapSBCRecords.get(oSBCCommVar) <> null && mapSBCRecords.get(oSBCCommVar) == System.Label.Hold_Final_Letter)
            {
                oSBCCommVar.Status__c = System.Label.Hold_Final_Letter ;
            }
            else
            {
                
                if(mapSBCRecords.get(oSBCCommVar) <> null && mapSBCRecords.get(oSBCCommVar) <> System.Label.Hold_Final_Letter)
                {
                    oSBCCommVar.Exception_Reason__c = mapSBCRecords.get(oSBCCommVar) ; 
                } 
                oSBCCommVar.Status__c = System.Label.Exception ;
            }
            
        }
    }
}