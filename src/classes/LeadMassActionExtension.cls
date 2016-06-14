/*******************************************************************************
    Name             : LeadMassActionExtension
    Description      : This class is vf controller for LeadMassActionpage which 
                      is called from a list button and used to close multiple
                      lead in bulk  using               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014       Created
Subhojit                29/01/2015       Modified for code re-factoring & 
                                         optimization
*******************************************************************************/
public with Sharing class LeadMassActionExtension{

    public Lead oLead{get;set;}
    public List<String> lstLead{get;set;}
    public boolean bIsShowLeadClosedReason{get;set;}
    public LeadMassActionExtension(ApexPages.StandardController controller){

        oLead=new Lead();
        lstLead=new List<String>();
        String sLeadIdVar=ApexPages.currentPage().getParameters().get('LeadId');
        //Getting Lead Ids as one String
        if(sLeadIdVar.contains(','))
        lstLead=sLeadIdVar.split(',');
        else
        lstLead.add(sLeadIdVar);  //Forming array of Lead Ids
    }
    /**
    * Method name  : ShowLeadClosedReason
    * Description  : Use this method to set boolean flag which in turn show
    * pickist choose close reason.
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    public void ShowLeadClosedReason(){

        if(oLead.Status==System.label.Closed)
        bIsShowLeadClosedReason=true;
        else
        bIsShowLeadClosedReason=false;
        
        oLead.Lead_Closed_Reason__c=null;

    }
    /**
    * Method name  : Save
    * Description  : Use this method to save changes and closing Leads
    *                
    * Return Type  : void
    * Parameter    : void
    **/

    public pageReference  Save(){

        List<Lead> lstUpdateLead=new List<Lead>();
        if((oLead.Status==System.label.Closed)&&
        (oLead.Lead_Closed_Reason__c==null)){
           ApexPages.addMessage(new ApexPages.Message
           (ApexPages.Severity.ERROR,System.label.MissingClosedReason));
         return null;
        }
        for(String sLeadIdStr: lstLead){

            Lead oLeadVar=new Lead(Id=sLeadIdStr,Lead_Closed_Reason__c=
            oLead.Lead_Closed_Reason__c,Status=oLead.Status); 
            // Setting Reason to close for all selected Lead
            lstUpdateLead.add(oLeadVar);
        }

        try{

            update lstUpdateLead;
        }
        catch(Exception ex){
            
        //Creating a new Error Log record whenever any exception 
        //is encountered while performing DML Operation
        
         Utility.insertErrorLogApplication
         (ex.getMessage()+'\n'+ex.getStackTraceString(), 'Lead', 
         String.ValueOf(lstLead),
            'LeadMassActionExtension', 'Save', 'Application',
            UserInfo.getUserId(), String.valueOf(lstUpdateLead), null);
        }

        String sKeyPrefix = (new Lead()).getSObjectType().getDescribe
        ().getKeyPrefix();

        return new PageReference('/'+sKeyPrefix);
        // returning back to Lead list view

    }

}