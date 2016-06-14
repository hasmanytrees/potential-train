/*
    ***************************************************************************
    Name             : ChooseMethodToResubmitController
    Description      : VF Page controller for ChooseMethodToResubmit                  
    Modification Log : 
    ---------------------------------------------------------------------------
    Developer              Date              Description
    ---------------------------------------------------------------------------
    Sumeet                  05/07/2015            Created
    **************************************************************************
*/
public class ChooseMethodToResubmitController{

  public String sSBCId{get;set;}
  SBC_Communications__c oSBCVar{get;set;}
  public List<SelectOption> lstAllDelivaryOption{get;set;}
  public String sSelectedMethod{get;set;}
   String sPreferedEmail;
  String sPreferedAddress;
  public ChooseMethodToResubmitController(){
    
       //sSBCId=controller.getId();
       sSBCId=ApexPages.currentPage().getParameters().get('id'); // Getting related content record Id from URL parameter
       if(sSBCId.contains('%'))
        sSBCId=sSBCId.subStringBefore('%');
       else
        sSBCId=sSBCId.subStringBefore('?parent_domain');
       oSBCVar=new SBC_communications__c();
       oSBCVar=[select Id,Name,Preferred_Address__c,Preferred_Email__c,Date_Physical_Received__c from SBC_communications__c where Id=:sSBCId limit 1];
       lstAllDelivaryOption=new List<SelectOption>();
        lstAllDelivaryOption.add(new SelectOption('','- None -'));
       lstAllDelivaryOption.add(new SelectOption('Email','Email'));
       lstAllDelivaryOption.add(new SelectOption('Mail','Mail'));
    
    }
 public void sendToXMpie(){
 
  boolean bIsPrint=null;
 
  if(oSBCVar.Preferred_Email__c!=null)
      sPreferedEmail=oSBCVar.Preferred_Email__c;
  else if(sPreferedEmail!=null)
    oSBCVar.Preferred_Email__c=sPreferedEmail;
    
   if(oSBCVar.Preferred_Address__c!=null)
      sPreferedAddress=oSBCVar.Preferred_Address__c;
  else if(sPreferedAddress!=null)
    oSBCVar.Preferred_Address__c=sPreferedAddress;
    
 
  if(sSelectedMethod!=null && sSelectedMethod=='Email' ){
     
     if(oSBCVar.Preferred_Email__c ==null){
        ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, Label.CorrespondenceDeliveryError);           
            ApexPages.addMessage(myMsg);
     
     }
     else{
       bIsPrint=false;
       oSBCVar.Preferred_Address__c=null;
       }
     
     }
  else if(sSelectedMethod!=null && sSelectedMethod=='Mail'){
    
     if(oSBCVar.Preferred_Address__c==null){
        ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, Label.CorrespondenceDeliveryError);           
            ApexPages.addMessage(myMsg);
     
     }
     else{
       bIsPrint=true;
        oSBCVar.Preferred_Email__c=null;
       
       }
    } else if((sSelectedMethod=='') || (sSelectedMethod==null)){
    
        ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select one Delivery Type to Proceed');           
            ApexPages.addMessage(myMsg);
     
    }
  if(bIsPrint!=null){
   boolean bIsSuccessResponse=SendEmailUsingXMPie.sendEmailForSBC(new List<SBC_communications__c>{oSBCVar},bIsPrint);
     if(bIsSuccessResponse){
        ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.INFO, 'You communication is sent to XMPie for process.');           
            ApexPages.addMessage(myMsg);
      
     }
    else{
       ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, 'You communication failed to send to XMPie for process.Please Contact System Administrator.');           
            ApexPages.addMessage(myMsg);
    
    }
   }
 }






}