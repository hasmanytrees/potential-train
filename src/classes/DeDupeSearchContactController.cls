public class DeDupeSearchContactController{
 
 public List<ContactWrapper> lstContactWrapper{get;set;}
 public String sContactFirstName{get;set;}
 public String sContactLastName{get;set;}
 public String sContactEmail{get;set;}
 public String sContactPhone{get;set;}
 public String sContactAddress{get;set;}
 public boolean bIsRedirect{get;set;}
 public String sSelectedContact{get;set;}
 public string sURL{get;set;}
 private final Integer iRECORD_LIMIT=500;
 
  public DeDupeSearchContactController(){
  
     lstContactWrapper=new List<ContactWrapper>();
     bIsRedirect=false;
     sSelectedContact='';
 
  }

 public void init(){
 
    lstContactWrapper=new List<ContactWrapper>();
    sContactFirstName=null;
    sContactLastName=null;
    sContactEmail=null;
    sContactPhone=null;
    sContactAddress=null;

 }

 public void search(){
 
    
   
     lstContactWrapper=new List<ContactWrapper>();
     Map<Id,Contact> mapNameMatchedContact=new Map<Id,Contact>();
     Map<Id,Contact> mapEmailMatchedContact=new Map<Id,Contact>();
     Map<Id,Contact> mapPhoneMatchedContact=new Map<Id,Contact>();
     Map<Id,Contact> mapAddressMatchedContact=new Map<Id,Contact>();
     Map<Id,Contact> mapMatchedContact=new map<Id,Contact>();
     String sContactName='';
     
     
     boolean bIsBlank=true;
      if((sContactFirstName!=null)&&(sContactFirstName!='')){
     
         sContactName+=sContactFirstName;
         bIsBlank=false;
         }
       if((sContactLastName!=null)&&(sContactLastName!='')){
        
         if(bIsBlank){
         sContactName+=' '+sContactLastName;
         
         }
         bIsBlank=false;
         }
              
      if(!bIsBlank){ 
       try{
          List<List<sObject>> lstContact=new List<List<sObject>>();
         if((sContactLastName!=null)&&(sContactFirstName!=null)&&(sContactLastName!='')&&(sContactFirstName!='')){
         
          lstContact=[Find :sContactName IN All FIELDS RETURNING Contact(id,OwnerId,Owner.Name,name,LastName,Preferred_Email__c,HomePhone,FirstName,Mailing_Address__c
                          where LastName=:sContactLastName and FirstName=: sContactFirstName)   limit 1000];
                          
           }
         else if((sContactFirstName!=null)&&(sContactFirstName!='')){
           lstContact=[Find :sContactName IN All FIELDS RETURNING Contact(id,OwnerId,Owner.Name,name,LastName,Preferred_Email__c,HomePhone,FirstName,Mailing_Address__c
                        where FirstName=:sContactFirstName)   limit 1000];
         }
         
         else if((sContactLastName!=null)&&(sContactLastName!='')){
          lstContact=[Find :sContactName IN NAME FIELDS RETURNING Contact(id,OwnerId,Owner.Name,name,LastName,Preferred_Email__c,HomePhone,FirstName,Mailing_Address__c
                       where LastName=:sContactLastName)   limit 1000];
         
         
         }  
         // lstContact=[Find :sContactName IN All FIELDS RETURNING Contact(id,name,Preferred_Preferred_Email__c_Address__c,Preferred_Phone_No__c,First_Name__c,Concatenated_Address__c,Contact_Full_Name__c)   limit 2000];
          if(lstContact.size()>0){
          mapNameMatchedContact.putAll((List<Contact>)lstContact[0]);
          
          
          }
               
         
       }
       catch(Exception ex){
           ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'No matched Contact found');
            ApexPages.addMessage(myMsg2);        
       
       }
      }
     if((sContactEmail!=null)&&(sContactEmail!='')){
     
       sContactEmail=String.escapeSingleQuotes(sContactEmail);
       List<List<sObject>> lstMatchedEmailContact=new List<List<sObject>> ();
       lstMatchedEmailContact=[Find :sContactEmail IN EMAIL FIELDS RETURNING Contact(id,OwnerId,Owner.Name,name,LastName,Preferred_Email__c,HomePhone,FirstName,Mailing_Address__c) limit 2000];
       if(lstMatchedEmailContact.size()>0)
        mapEmailMatchedContact =new Map<Id,Contact>((List<Contact>)lstMatchedEmailContact[0]); 
        mapMatchedContact.putAll(mapEmailMatchedContact );
        mapEmailMatchedContact =null;
        
     }
    if((sContactPhone!=null)&&(sContactPhone!='')){
     
       sContactEmail=String.escapeSingleQuotes(sContactPhone);
       List<List<sObject>> lstMatchedPhoneContact=new List<List<sObject>> ();
       lstMatchedPhoneContact=[Find :sContactPhone IN PHONE FIELDS RETURNING Contact(id,OwnerId,Owner.Name,name,LastName,Preferred_Email__c,HomePhone,FirstName,Mailing_Address__c) limit 2000];
       if(lstMatchedPhoneContact.size()>0)
        mapPhoneMatchedContact =new Map<Id,Contact>((List<Contact>)lstMatchedPhoneContact[0]); 
        
        mapMatchedContact.putAll(mapPhoneMatchedContact );
        mapPhoneMatchedContact =null;
     }
    if((sContactAddress!=null)&&(sContactAddress!='')){
     
     sContactAddress=String.escapeSingleQuotes(sContactAddress)+'*';
     List<List<sObject>> lstContact=new List<List<sObject>>();
          lstContact=[Find :sContactAddress IN All FIELDS RETURNING Contact(id,name,OwnerId,Owner.Name,LastName,Preferred_Email__c,HomePhone,FirstName,Mailing_Address__c,MailingPostalCode,OtherPostalCode) limit 2000];
          if(lstContact.size()>0){
          for(Contact oContactVar:(List<Contact>) lstContact[0]){
              
              if((oContactVar.MailingPostalCode!=null)&&(oContactVar.MailingPostalCode.StartsWith(sContactAddress.subStringBeforeLast('*'))))
              mapMatchedContact.put(oContactVar.Id,oContactVar);
             else if((oContactVar.OtherPostalCode!=null)&&(oContactVar.OtherPostalCode.StartsWith(sContactAddress.subStringBeforeLast('*'))))
             mapMatchedContact.put(oContactVar.Id,oContactVar);
          }
          
        }
     
    
    }
    Integer iNoOfAllowedRecord=0;
    List<ContactWrapper> lstContactWrapperFinal=new  List<ContactWrapper>();
   if(mapNameMatchedContact.size()>0){
   
      for(Id ContactIdVar: mapNameMatchedContact.keySet()){
        
        if(mapMatchedContact.size()>0){
          if(mapMatchedContact.get(ContactIdVar)!=null)
          lstContactWrapper.add(new ContactWrapper(mapNameMatchedContact.get(ContactIdVar),false));
        }
          else
          lstContactWrapperFinal.add(new ContactWrapper(mapNameMatchedContact.get(ContactIdVar),false));
     }
    }
   else{
   
       for(Id ContactIdVar: mapMatchedContact.keySet()){
          lstContactWrapperFinal.add(new ContactWrapper(mapMatchedContact.get(ContactIdVar),false));
     }
  }
  for(ContactWrapper contactWrapperVar: lstContactWrapperFinal){
    if(iNoOfAllowedRecord>iRECORD_LIMIT)
    break;
    else
       lstContactWrapper.add(contactWrapperVar);
    
    
  
    iNoOfAllowedRecord++;
  }
  if(lstContactWrapper.size()==0){
  
     ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'No matched Contact found');
            ApexPages.addMessage(myMsg2);
  }
  
  
 }
 
 public void mergeContact(){
 
   Set<Id> setSelectedIds=new Set<Id>();
   Map<String,String> mapContactNameId=new Map<String,String>();
   String sContactId='';
   sURL='';
   Integer iVar=0;
   for(ContactWrapper ContactWrpVar:lstContactWrapper){
     mapContactNameId.put(String.valueOf(iVar),ContactWrpVar.oContact.Id);
      iVar++;
      
      }
     List<String> lstSelectedContactIds=new  List<String> ();
     //sSelectedContact=sSelectedContact.subStringBeforeLast(',');
     if(sSelectedContact.Contains(',')){
     System.debug(sSelectedContact);
     lstSelectedContactIds=sSelectedContact.split(',');
     for(String sContactNameVar: lstSelectedContactIds){
      System.debug(sContactNameVar+'>>'+mapContactNameId.get(sContactNameVar));
       if((mapContactNameId.get(sContactNameVar)!=null)&&(mapContactNameId.get(sContactNameVar)!='')){
         sContactId+=mapContactNameId.get(sContactNameVar)+',';
         setSelectedIds.add(mapContactNameId.get(sContactNameVar));
         System.debug(mapContactNameId.get(sContactNameVar));
      }  
     }
     
     }
    if(setSelectedIds.size()==0){
      ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'Please select at least one record to procced');
            ApexPages.addMessage(myMsg2);
   return ;
    
    
    }
   if(setSelectedIds.size()>3){
   
     ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'You can merge maximum three records at a time');
            ApexPages.addMessage(myMsg2);
   return ;
   }
   else if(setSelectedIds.size()==1){
   
    ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'Please select at least two record to procced');
            ApexPages.addMessage(myMsg2);
   return ;
   
   }
   else{
     sURL=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/dupcheck__dc3Merge?ids='+sContactId.subStringBeforeLast(',');
     bIsRedirect=true;
     return ;  
   
   }
 
 }

 public class ContactWrapper{

      public Contact oContact{get;set;}
      public boolean bIsSelected{get;set;}
      public string sMailingAddress{get;set;}
      public ContactWrapper(Contact oContactVar,boolean bIsSelectedVar){
      
         oContact=oContactVar;
         bIsSelected=bIsSelectedVar;
         sMailingAddress = '';
         if(oContactVar.Mailing_Address__c <> null)
         sMailingAddress += oContactVar.Mailing_Address__c.replace(',','<br>');
      
      }
  }
}