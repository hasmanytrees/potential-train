/*******************************************************************************
    Name             : FeedbackRollUpHelper
    Description      : Main Agency Feedback Trigger helper to roll up  feedback 
                       scores                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & 
                                              optimization
*******************************************************************************/
public without Sharing class FeedbackRollUpHelper{ 


    /**
    * Method name  : rollUpAgencyFeedback
    * Description  : Use this method to roll up agency feed back scores.
    *                
    * Return Type  : void
    * Parameter    : Set<Id>
    **/  
    public Static void rollUpAgencyFeedback(Set<Id> setAgencyId){

        
        List<Agency_Feedback__c> lstAllAgencyFeedback =
        new List<Agency_Feedback__c>();
        Map<Id,List<Agency_Feedback__c>> mapAgencyFeedback = 
        new   Map<Id,List<Agency_Feedback__c>>();
        Map<Id,FeedBackScore> mapAgencyScore = 
        new Map<Id,FeedBackScore>();
        List<Account> lstAccountUpdate=new List<Account>();

        lstAllAgencyFeedback=[select Id,Creative__c,Customer_Service__c,
         Pricing__c,Timeliness__c,Overall_Experience__c,Agency__c from 
         Agency_Feedback__c where Agency__c IN :setAgencyId];    
                    // Get Existing Agency Feedback for specified Agency



        for(Id agencyId : setAgencyId){

            List<Agency_Feedback__c> lstAgencyTempVar = 
            new  List<Agency_Feedback__c>();
            for(Agency_Feedback__c oFeedbackVar: lstAllAgencyFeedback){
                // Get Ids for All Agencies
                if(oFeedbackVar.Agency__c==agencyId )
                lstAgencyTempVar.add(oFeedbackVar);
                
                
            }
            mapAgencyFeedback.put(agencyId ,lstAgencyTempVar);  
            // Map with Agency Id and List of related Agency Feedback
        }

        for(Id agencyId: mapAgencyFeedback.keySet()){

            //Initialize different roll up score
            Double dbCreative=0;
            Double dbCustomerExperience=0;
            Double dbPricing=0;
            Double dbTimeliness=0;
            Double dbOverallExp=0;
            Integer iNoOfRecord=0;
            
            // Calculating Roll up values  
         for( Agency_Feedback__c oFeedbackVar: mapAgencyFeedback.get(agencyId)){
                
                iNoOfRecord=mapAgencyFeedback.get(agencyId).size(); 
                // No Of Agency Feedback records.
                
                if(oFeedbackVar.Creative__c!=null)
                dbCreative+=Double.valueOf(oFeedbackVar.Creative__c);   
                // roll up for creative score
                if(oFeedbackVar.Customer_Service__c!=null)
                dbCustomerExperience += Double.valueOf(oFeedbackVar
                .Customer_Service__c);  
                // roll up for Customer Service  score
                
                if(oFeedbackVar.Pricing__c!=null)
                dbPricing+=Double.valueOf(oFeedbackVar.Pricing__c);   
                // roll up for Feedback pricing  score
                if(oFeedbackVar.Timeliness__c!=null)
                dbTimeliness+=Double.valueOf(oFeedbackVar.Timeliness__c); 
                // roll up for Timeliness  score
                if(oFeedbackVar.Overall_Experience__c!=null)
               dbOverallExp+=Double.valueOf(oFeedbackVar.Overall_Experience__c);  
                // roll up for Overall Experience  score
            }
            
            if(iNoOfRecord>0){
                dbCreative=dbCreative/iNoOfRecord;
                dbCustomerExperience=dbCustomerExperience/iNoOfRecord;
                dbPricing=dbPricing/iNoOfRecord;
                dbTimeliness=dbTimeliness/iNoOfRecord;
                dbOverallExp=dbOverallExp/iNoOfRecord;
                
                mapAgencyScore.put( agencyId,new FeedBackScore(dbCreative,
                dbCustomerExperience,dbPricing,dbTimeliness,dbOverallExp));
            }



        }

        for(Id agencyId: mapAgencyScore.keySet()){

            lstAccountUpdate.add(new Account(Id=agencyId,Creative__c = 
            mapAgencyScore.get(agencyId).dbCreative,Customer_Service__c = 
            mapAgencyScore.get(agencyId).dbCustomerExperience,
            Pricing__c = mapAgencyScore.get(agencyId).dbPricing,
            Timeliness__c=mapAgencyScore.get(agencyId).dbTimeliness,
            Overall_Experience__c=mapAgencyScore.get(agencyId).dbOverallExp));


        }

        if(lstAccountUpdate.size()>0)
        {
            try{
                update lstAccountUpdate; 
                // Updating the roll up score to related Agency Account Record
            }
            catch(Exception ex)
            {
                //Error Occured. Please contact System Administartor
            }
        }
    }

    // Feedback Score Wrapper Class
    public class FeedBackScore{

        Double dbCreative;
        Double dbCustomerExperience;
        Double dbPricing;
        Double dbTimeliness;
        Double dbOverallExp;
        
        public FeedBackScore(Double dbCreative,Double dbCustomerExperience,
        Double dbPricing,Double dbTimeliness,Double dbOverallExp){

            this.dbCreative=dbCreative;
            this.dbCustomerExperience=dbCustomerExperience;
            this.dbPricing=dbPricing;
            this.dbTimeliness=dbTimeliness;
            this.dbOverallExp=dbOverallExp;


        }

    }

}