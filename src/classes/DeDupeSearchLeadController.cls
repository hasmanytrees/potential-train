public with Sharing class DeDupeSearchLeadController{
 
 public List<LeadWrapper> lstLeadWrapper{get;set;}
 public String sLeadFirstName{get;set;}
 public String sLeadLastName{get;set;}
 public String sLeadEmail{get;set;}
 public String sLeadPhone{get;set;}
 public String sLeadAddress{get;set;}
 public boolean bIsRedirect{get;set;}
 public String sSelectedLead{get;set;}
 public string sURL{get;set;}
  private final Integer iRECORD_LIMIT=500;
 
  public DeDupeSearchLeadController(){
  
     lstLeadWrapper=new List<LeadWrapper>();
     bIsRedirect=false;
     sSelectedLead='';
 
  }

 public void init(){
 
    lstLeadWrapper=new List<LeadWrapper>();
    sLeadFirstName=null;
    sLeadLastName=null;
    sLeadEmail=null;
    sLeadPhone=null;
    sLeadAddress=null;

 }

 public void search(){
 
    
     
     lstLeadWrapper=new List<LeadWrapper>();
     Map<Id,Lead> mapNameMatchedLead=new Map<Id,Lead>();
     Map<Id,Lead> mapEmailMatchedLead=new Map<Id,Lead>();
     Map<Id,Lead> mapPhoneMatchedLead=new Map<Id,Lead>();
     Map<Id,Lead> mapAddressMatchedLead=new Map<Id,Lead>();
     Map<Id,Lead> mapMatchedLead=new map<Id,Lead>();
     String sLeadName='';
     
     
     boolean bIsBlank=true;
      if((sLeadFirstName!=null)&&(sLeadFirstName!='')){
        
         sLeadName+=sLeadFirstName;
         bIsBlank=false;
         }
       if((sLeadLastName!=null)&&(sLeadLastName!='')){
        
         if(bIsBlank){
         sLeadName+=' '+sLeadLastName;
         
         }
         bIsBlank=false;
         }
            
      if(!bIsBlank){ 
       try{
          List<List<sObject>> lstLead=new List<List<sObject>>();
         if((sLeadLastName!=null)&&(sLeadFirstName!=null)&&(sLeadLastName!='')&&(sLeadFirstName!='')){
          sLeadName='%'+sLeadName;
          sLeadFirstName=sLeadFirstName+'%';
          lstLead=[Find :sLeadName IN All FIELDS RETURNING Lead(id,OwnerId,Owner.Name,EMail,Phone,FirstName,Address,Lead_Address__c,Name,Company
                          where Company=:sLeadLastName and Name LIKE :sLeadFirstName)   ];
                          
           }
         else if((sLeadFirstName!=null)&&(sLeadFirstName!='')){
           sLeadFirstName=sLeadFirstName+'%';
           lstLead=[Find :sLeadName IN NAME FIELDS RETURNING Lead(id,OwnerId,Owner.Name,EMail,Phone,FirstName,Address,Lead_Address__c,Name,Company
                        where Name LIKE :sLeadFirstName)    ];
         }
         
         else if((sLeadLastName!=null)&&(sLeadLastName!='')){
          lstLead=[Find :sLeadName IN All FIELDS RETURNING Lead(id,OwnerId,Owner.Name,EMail,Address,Phone,FirstName,Lead_Address__c,Name,Company where Company=:sLeadLastName)   ];
         
         
         }  
         // lstLead=[Find :sLeadName IN All FIELDS RETURNING Lead(id,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Address,Lead_Address__c,Lead_Full_Name__c)   limit 2000];
          if(lstLead.size()>0){
          mapNameMatchedLead.putAll((List<Lead>)lstLead[0]);
          
          
          }
               
         
       }
       catch(Exception ex){
           ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'No matched Lead found');
            ApexPages.addMessage(myMsg2);        
       
       }
      }
     if((sLeadEmail!=null)&&(sLeadEmail!='')){
     
       sLeadEmail=String.escapeSingleQuotes(sLeadEmail);
       List<List<sObject>> lstMatchedEmailLead=new List<List<sObject>> ();
       lstMatchedEmailLead=[Find :sLeadEmail IN EMAIL FIELDS RETURNING Lead(id,OwnerId,Owner.Name,EMail,Phone,FirstName,Address,Lead_Address__c,Name,Company)  ];
       if(lstMatchedEmailLead.size()>0)
        mapEmailMatchedLead =new Map<Id,Lead>((List<Lead>)lstMatchedEmailLead[0]); 
        mapMatchedLead.putAll(mapEmailMatchedLead );
        mapEmailMatchedLead =null;
        
     }
    if((sLeadPhone!=null)&&(sLeadPhone!='')){
     
       sLeadEmail=String.escapeSingleQuotes(sLeadPhone);
       List<List<sObject>> lstMatchedPhoneLead=new List<List<sObject>> ();
       lstMatchedPhoneLead=[Find :sLeadPhone IN PHONE FIELDS RETURNING Lead(id,OwnerId,Owner.Name,EMail,Phone,FirstName,Address,Lead_Address__c,Name,Company) ];
       if(lstMatchedPhoneLead.size()>0)
        mapPhoneMatchedLead =new Map<Id,Lead>((List<Lead>)lstMatchedPhoneLead[0]); 
        
        mapMatchedLead.putAll(mapPhoneMatchedLead );
        mapPhoneMatchedLead =null;
     }
    if((sLeadAddress!=null)&&(sLeadAddress!='')){
     
     sLeadAddress=String.escapeSingleQuotes(sLeadAddress)+'*';
     List<List<sObject>> lstLead=new List<List<sObject>>();
          lstLead=[Find :sLeadAddress IN All FIELDS RETURNING Lead(id,OwnerId,Owner.Name,EMail,Phone,PostalCode,FirstName,Address,Lead_Address__c,Name,Company) ];
          if(lstLead.size()>0){
          for(Lead oLeadVar:(List<Lead>) lstLead[0]){
              
              if((oLeadVar.PostalCode!=null)&&(oLeadVar.PostalCode).StartsWith(sLeadAddress.subStringBeforeLast('*')))
              mapMatchedLead.put(oLeadVar.Id,oLeadVar);
          
          }
          
        }
     
    
    }
    List<LeadWrapper> lstLeadWrapperFinal=new  List<LeadWrapper>();
   if(mapNameMatchedLead.size()>0){
   
      for(Id LeadIdVar: mapNameMatchedLead.keySet()){
        
        if(mapMatchedLead.size()>0){
          if(mapMatchedLead.get(LeadIdVar)!=null)
          lstLeadWrapper.add(new LeadWrapper(mapNameMatchedLead.get(LeadIdVar),false));
        }
          else
          lstLeadWrapper.add(new LeadWrapper(mapNameMatchedLead.get(LeadIdVar),false));
     }
    }
   else{
   
       for(Id LeadIdVar: mapMatchedLead.keySet()){
          lstLeadWrapper.add(new LeadWrapper(mapMatchedLead.get(LeadIdVar),false));
     }
  }
  Integer iNoOfAllowedRecord=0;
  for(LeadWrapper leadWrapperVar: lstLeadWrapperFinal){
    if(iNoOfAllowedRecord>iRECORD_LIMIT)
    break;
    else
       lstLeadWrapper.add(leadWrapperVar);
    
    
  
    iNoOfAllowedRecord++;
  }
  if(lstLeadWrapper.size()==0){
  
     ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.NoLeadFound);//No matched Lead found
            ApexPages.addMessage(myMsg2);
  }
  
  
 }
 
 public void mergeLead(){
 
   Set<Id> setSelectedIds=new Set<Id>();
   Map<String,String> mapLeadNameId=new Map<String,String>();
   String sLeadId='';
   sURL='';
   Integer iVar=0;
   for(LeadWrapper LeadWrpVar:lstLeadWrapper){
     mapLeadNameId.put(String.valueOf(iVar),LeadWrpVar.oLead.Id);
      iVar++;
      
      }
     List<String> lstSelectedLeadIds=new  List<String> ();
     //sSelectedLead=sSelectedLead.subStringBeforeLast(',');
     if(sSelectedLead.Contains(',')){
     System.debug(sSelectedLead);
     lstSelectedLeadIds=sSelectedLead.split(',');
     for(String sLeadNameVar: lstSelectedLeadIds){
      System.debug(sLeadNameVar+'>>'+mapLeadNameId.get(sLeadNameVar));
       if((mapLeadNameId.get(sLeadNameVar)!=null)&&(mapLeadNameId.get(sLeadNameVar)!='')){
         sLeadId+=mapLeadNameId.get(sLeadNameVar)+',';
         setSelectedIds.add(mapLeadNameId.get(sLeadNameVar));
         System.debug(mapLeadNameId.get(sLeadNameVar));
      }  
     }
     
     }
    if(setSelectedIds.size()==0){
      ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
           System.label.SelectAtLeastRecord );//Please select at least one record to procced
            ApexPages.addMessage(myMsg2);
   return ;
    
    
    }
   if(setSelectedIds.size()>3){
   
     ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.MaxThreeRecord);//You can merge maximum three records at a time
            ApexPages.addMessage(myMsg2);
   return ;
   }
   else if(setSelectedIds.size()==1){
   
    ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.MinTwoRecord);//Please select at least two record to procced
            ApexPages.addMessage(myMsg2);
   return ;
   
   }
   else{
     sURL=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/dupcheck__dc3Merge?ids='+sLeadId.subStringBeforeLast(',');
     bIsRedirect=true;
     return ;  
   
   }
 
 }

 public class LeadWrapper{

      public Lead oLead{get;set;}
      public boolean bIsSelected{get;set;}
      public string sMailingAddress{get;set;}
      public string sOwnerURL{get;set;}
      public LeadWrapper(Lead oLeadVar,boolean bIsSelectedVar){
      
         oLead=oLeadVar;
         bIsSelected=bIsSelectedVar;
         sMailingAddress = '';
         sOwnerURL = '';
         if(oLeadVar.Lead_Address__c <> null)
         {
             sMailingAddress += oLeadVar.Lead_Address__c.replace(',','<br>');              
         }
         if(oLeadVar.OwnerId <> null)
         {
             if(String.valueOf(oLeadVar.OwnerId).substring(0,3) =='00G')
             {
                 sOwnerURL =URL.getSalesforceBaseUrl().toExternalForm()+'/p/own/Queue/d?id=' + oLeadVar.OwnerId;
             }
             else
             {
                 sOwnerURL = URL.getSalesforceBaseUrl().toExternalForm()+'/' + oLeadVar.OwnerId;
             }
         }
      
      }
  }
}