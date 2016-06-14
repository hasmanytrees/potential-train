/**************************************************************************
    Name             : AssignPMDeliverableHelper
    Description      : Trigger Helper class used to handle scenario of 
                       assigning PM from Campaign Project Manager field                  
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
******************************************************************************/

public with Sharing class AssignPMDeliverableHelper{

    /**
    * Method name  : assignPM
    * Description  : This method is used to handle scenario of assigning PM 
                     from Campaign Project Manager field   
    *                
    * Return Type  : void
    * Parameter    : List<Deliverable__c>
    **/       
    public static void assignPM(List<Deliverable__c> lstDeliverable){

        Set<Id> setCampaignId=new Set<Id>();
        Map<Id,List<Deliverable__c>> mapDeliverableCampaign=
        new Map<Id,List<Deliverable__c>>();
        for(Deliverable__c oDeliverableVar: lstDeliverable ){
        
            if(oDeliverableVar.Campaign__c!=null)
                //Getting Ids Of related Campaign
                setCampaignId.add(oDeliverableVar.Campaign__c); 
        }
        for(Id campaignId: setCampaignId){
            
            List<Deliverable__c> lstDeliverableVar=
            new List<Deliverable__c>(); 
            for(Deliverable__c oDeliverableVar: lstDeliverable ){
            
                if(oDeliverableVar.Campaign__c == campaignId)
                lstDeliverableVar.add(oDeliverableVar);
            }
            //Forming Map of Campaign and related List of Deliverable
            mapDeliverableCampaign.put(campaignId,lstDeliverableVar);  
            
        } 
        
        List<Campaign> lstCampaign=new List<Campaign>();
        //Querying for PM field value from Campaign records.
        lstCampaign=[select Id,Project_Manager__c,OwnerId 
        from campaign where Id IN :setCampaignId];   

        for(Campaign oCampaignVar: lstCampaign){

            for(Deliverable__c oDeliverableVar:
            mapDeliverableCampaign.get(oCampaignVar.Id)){
                
                //Setting values on Project Manager and Campaign Owner 
                //on Deliverable record.        
                oDeliverableVar.Project_Manager__c = 
                oCampaignVar.Project_Manager__c;
                oDeliverableVar.CMGN_Owner__c = 
                oCampaignVar.OwnerId;
                
            }

        }

    }
}