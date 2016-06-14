/******************************************************************************
    Name             : ChooseOppLeadConversionController
    Description      : This class is used as visual force page 
                       ChooseOpportunityLeadConversion to choose whether to 
                       create opportunity or not
    Modification Log : 
---------------------------------------------------------------------------
Developer           Date              Description
---------------------------------------------------------------------------
Subhojit            30/10/2014        Created
Subhojit            29/01/2015        Modified for code re-factoring & 
                                      optimization.
******************************************************************************/
global without Sharing class ChooseOppLeadConversionController{

    public Lead oLeadVar{get;set;}
    public boolean bCreateOpportunity{get;set;}
    public Id accountId{get;set;}
    public String sMessage{get;set;}
    public Static  boolean bErrorCheck{get;set;}

    //This is the basic constructor of this class  which initiate class variable 
    public ChooseOppLeadConversionController(){

        Id leadId=ApexPages.currentPage().getParameters().get('id')
        .subStringBefore('?parent_domain');  //Getting Lead Id
        oLeadVar=[select Id,Name,ownerId from Lead where Id =:leadId];
        bCreateOpportunity=false;
        bErrorCheck=false;
        QueueSobject oQueue=new  QueueSobject ();
        try{
            //If Lead owner is not user
            if(!((String)oLeadVar.ownerId).StartsWith('005')){
            
                oQueue=[select QueueId from QueueSobject where QueueId
                =:oLeadVar.ownerId];   //Getting oQueue details
                ApexPages.Message myMsg = new
    ApexPages.Message(ApexPages.Severity.ERROR,System.label.LeadOwnedByQueue ); 
    //You can not convert lead owned by oQueue         
                ApexPages.addMessage(myMsg);
                bErrorCheck=true;
            }
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new 
        ApexPages.Message(ApexPages.Severity.ERROR, System.label.UnknownError);
        //Internal Error occurred          

            ApexPages.addMessage(myMsg);
            bErrorCheck=true;  //Disable Convert button
            
        }
    }
    public void showMessage(){
    
      if( sMessage.contains(System.Label.Lead_Conversion_Success)){
                
                ApexPages.Message myMsg = new 
                ApexPages.Message(ApexPages.Severity.INFO, sMessage);   
                //Lead created successfully       
                ApexPages.addMessage(myMsg);
                 //return 'INFO-'+sAccountMsg;
                
            }
            else{                
                ApexPages.Message myMsg = new 
                ApexPages.Message(ApexPages.Severity.WARNING, sMessage);   
                //Lead created with error in Account creation validation       
                ApexPages.addMessage(myMsg);
                 //return 'WARN-'+sAccountMsg;
            }
            
            bErrorCheck=true;
    
    
    }
    /**
    * Method name  : convertLead
    * Description  : Use this method to manage custom lead conversion 
    *                
    * Return Type  : void
    * Parameter    : void
    **/   


  webservice Static String convertLead(Id leadId,boolean bIsCreateOpportunity){
      String sAccountMsg='';
        try{           
           sAccountMsg= 
           LeadConverterHelper.convertLeadCustom(leadId,!bIsCreateOpportunity); 
           //Initiating Lead Conversion process                      
           
        }
        catch(Exception ex){
           sAccountMsg= ex.getMessage();           
            
        }
        return sAccountMsg;
    }

}