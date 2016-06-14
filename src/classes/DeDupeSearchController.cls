public with Sharing class DeDupeSearchController{
 
 public List<AccountWrapper> lstAccountWrapper{get;set;}
 public String sAccountFirstName{get;set;}
 public String sAccountLastName{get;set;}
 public String sAccountEmail{get;set;}
 public String sAccountPhone{get;set;}
 public String sAccountAddress{get;set;}
 public boolean bIsRedirect{get;set;}
 public String sSelectedAccount{get;set;}
 public string sURL{get;set;}
 private final Integer iRECORD_LIMIT=500;

 
  public DeDupeSearchController(){
  
     lstAccountWrapper=new List<AccountWrapper>();
     bIsRedirect=false;
     sSelectedAccount='';
 
  }

 public void init(){
 
    lstAccountWrapper=new List<AccountWrapper>();
    sAccountFirstName=null;
    sAccountLastName=null;
    sAccountEmail=null;
    sAccountPhone=null;
    sAccountAddress=null;

 }

 public void search(){
 
    
     String sQueryName='select Id,Name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c from Account where Id!=null';
     lstAccountWrapper=new List<AccountWrapper>();
     Map<Id,Account> mapNameMatchedAccount=new Map<Id,Account>();
     Map<Id,Account> mapEmailMatchedAccount=new Map<Id,Account>();
     Map<Id,Account> mapPhoneMatchedAccount=new Map<Id,Account>();
     Map<Id,Account> mapAddressMatchedAccount=new Map<Id,Account>();
     Map<Id,Account> mapMatchedAccount=new map<Id,Account>();
     String sAccountName='';
     
     
     boolean bIsBlank=true;
      if((sAccountFirstName!=null)&&(sAccountFirstName!='')){
        
         sAccountName+=sAccountFirstName;
         bIsBlank=false;
         }
       if((sAccountLastName!=null)&&(sAccountLastName!='')){
       
         if(bIsBlank){
         sAccountName+=' '+sAccountLastName;
         
         }
         bIsBlank=false;
         }
       sQueryName+=' ';       
      if(!bIsBlank){ 
       try{
          List<List<sObject>> lstAccount=new List<List<sObject>>();
         if((sAccountLastName!=null)&&(sAccountFirstName!=null)&&(sAccountLastName!='')&&(sAccountFirstName!='')){
          sAccountName='%'+sAccountName;
          lstAccount=[Find :sAccountName IN All FIELDS RETURNING Account(id,name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Concatenated_Address__c,Account_Full_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c
                          where Name =:sAccountLastName and First_Name__c=: sAccountFirstName)   ];
                          
           }
         else if((sAccountFirstName!=null)&&(sAccountFirstName!='')){
           lstAccount=[Find :sAccountName IN All FIELDS RETURNING Account(id,name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Concatenated_Address__c,Account_Full_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c
                        where First_Name__c=:sAccountFirstName)   ];
         }
         
         else if((sAccountLastName!=null)&&(sAccountLastName!='')){
          lstAccount=[Find :sAccountName IN NAME FIELDS RETURNING Account(id,name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,
                      Concatenated_Address__c,Account_Full_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c where Name=:sAccountLastName)   ];
         
         
         }  
         // lstAccount=[Find :sAccountName IN All FIELDS RETURNING Account(id,name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Concatenated_Address__c,Account_Full_Name__c)   ];
          if(lstAccount.size()>0){
          mapNameMatchedAccount.putAll((List<Account>)lstAccount[0]);
          
          
          }
               
         
       }
       catch(Exception ex){
           ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            'No matched account found');
            ApexPages.addMessage(myMsg2);        
       
       }
      }
     if((sAccountEmail!=null)&&(sAccountEmail!='')){
     
       sAccountEmail=String.escapeSingleQuotes(sAccountEmail);
       List<List<sObject>> lstMatchedEmailAccount=new List<List<sObject>> ();
       lstMatchedEmailAccount=[Find :sAccountEmail IN EMAIL FIELDS RETURNING Account(id,name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Concatenated_Address__c,Account_Full_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c) ];
       if(lstMatchedEmailAccount.size()>0)
        mapEmailMatchedAccount =new Map<Id,Account>((List<Account>)lstMatchedEmailAccount[0]); 
        mapMatchedAccount.putAll(mapEmailMatchedAccount );
        mapEmailMatchedAccount =null;
        
     }
    if((sAccountPhone!=null)&&(sAccountPhone!='')){
     
       sAccountEmail=String.escapeSingleQuotes(sAccountPhone);
       List<List<sObject>> lstMatchedPhoneAccount=new List<List<sObject>> ();
       lstMatchedPhoneAccount=[Find :sAccountPhone IN PHONE FIELDS RETURNING Account(id,name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,Concatenated_Address__c,Account_Full_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c) ];
       if(lstMatchedPhoneAccount.size()>0)
        mapPhoneMatchedAccount =new Map<Id,Account>((List<Account>)lstMatchedPhoneAccount[0]); 
        
        mapMatchedAccount.putAll(mapPhoneMatchedAccount );
        mapPhoneMatchedAccount =null;
     }
    if((sAccountAddress!=null)&&(sAccountAddress!='')){
     
     sAccountAddress=String.escapeSingleQuotes(sAccountAddress)+'*';
     List<List<sObject>> lstAccount=new List<List<sObject>>();
          lstAccount=[Find :sAccountAddress IN All FIELDS RETURNING Account(id,name,OwnerId,Owner.Name,Preferred_Email_Address__c,Preferred_Phone_No__c,First_Name__c,ShippingPostalCode,BillingPostalCode,Concatenated_Address__c,Account_Full_Name__c,Mailing_City__c,Mailing_Country__c,Mailing_State_Province__c,Mailing_Street__c,Mailing_Zip_Postal_Code__c ) ];
          if(lstAccount.size()>0){
          for(Account oAccountVar:(List<Account>) lstAccount[0]){
          if(oAccountVar.Mailing_Zip_Postal_Code__c!=null)
              System.debug(oAccountVar.Mailing_Zip_Postal_Code__c.toUpperCase().Contains(sAccountAddress.subStringBeforeLast('*').toUpperCase())+''+oAccountVar.Mailing_Zip_Postal_Code__c);
              if((oAccountVar.Mailing_Zip_Postal_Code__c!=null)&&(oAccountVar.Mailing_Zip_Postal_Code__c.StartsWith(sAccountAddress.subStringBeforeLast('*'))))
              mapMatchedAccount.put(oAccountVar.Id,oAccountVar);
             else if((oAccountVar.BillingPostalCode!=null)&&(oAccountVar.BillingPostalCode.StartsWith(sAccountAddress.subStringBeforeLast('*'))))
               mapMatchedAccount.put(oAccountVar.Id,oAccountVar);
             else  if((oAccountVar.ShippingPostalCode!=null)&&(oAccountVar.ShippingPostalCode.StartsWith(sAccountAddress.subStringBeforeLast('*'))))
               mapMatchedAccount.put(oAccountVar.Id,oAccountVar);
          }
          
        }
     
    
    }
    Integer iNoOfAllowedRecord=0;
    List<AccountWrapper> lstAccountWrapperFinal=new List<AccountWrapper>();
   if(mapNameMatchedAccount.size()>0){
   
      for(Id accountIdVar: mapNameMatchedAccount.keySet()){
        
        if(mapMatchedAccount.size()>0){
          if(mapMatchedAccount.get(accountIdVar)!=null)
          lstAccountWrapperFinal.add(new AccountWrapper(mapNameMatchedAccount.get(accountIdVar),false));
        }
          else
          lstAccountWrapperFinal.add(new AccountWrapper(mapNameMatchedAccount.get(accountIdVar),false));
         
     }
    }
   else{
   
       for(Id accountIdVar: mapMatchedAccount.keySet()){
       
          lstAccountWrapperFinal.add(new AccountWrapper(mapMatchedAccount.get(accountIdVar),false));
          
     }
  }
  for(AccountWrapper accountWrapperVar: lstAccountWrapperFinal){
    if(iNoOfAllowedRecord>iRECORD_LIMIT)
    break;
    else
       lstAccountWrapper.add(accountWrapperVar);
    
    
  
    iNoOfAllowedRecord++;
  }
  if(lstAccountWrapper.size()==0){
  
     ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.NoMatchedAccount);//No matched account found
            ApexPages.addMessage(myMsg2);
  }
  
  
 }
 
 public void mergeAccount(){
 
   Set<Id> setSelectedIds=new Set<Id>();
   Map<String,String> mapAccountNameId=new Map<String,String>();
   String sAccountId='';
   sURL='';
   Integer iVar=0;
   for(AccountWrapper accountWrpVar:lstAccountWrapper){
     mapAccountNameId.put(String.valueOf(iVar),accountWrpVar.oAccount.Id);
      iVar++;
      
      }
     List<String> lstSelectedAccountIds=new  List<String> ();
     //sSelectedAccount=sSelectedAccount.subStringBeforeLast(',');
     if(sSelectedAccount.Contains(',')){
     System.debug(sSelectedAccount);
     lstSelectedAccountIds=sSelectedAccount.split(',');
     for(String sAccountNameVar: lstSelectedAccountIds){
      System.debug(sAccountNameVar+'>>'+mapAccountNameId.get(sAccountNameVar));
       if((mapAccountNameId.get(sAccountNameVar)!=null)&&(mapAccountNameId.get(sAccountNameVar)!='')){
         sAccountId+=mapAccountNameId.get(sAccountNameVar)+',';
         setSelectedIds.add(mapAccountNameId.get(sAccountNameVar));
         System.debug(mapAccountNameId.get(sAccountNameVar));
      }  
     }
     
     }
    if(setSelectedIds.size()==0){
      ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            System.label.SelectAtLeastRecord);//Please select at least one record to procced
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
     sURL=URL.getSalesforceBaseUrl().toExternalForm()+'/apex/dupcheck__dc3Merge?ids='+sAccountId.subStringBeforeLast(',');
     bIsRedirect=true;
     return ;  
   
   }
 
 }

 public class AccountWrapper{

      public Account oAccount{get;set;}
      public boolean bIsSelected{get;set;}
      public string sAccountMailingAddress{get;set;}
      public AccountWrapper(Account oAccountVar,boolean bIsSelectedVar){
      
         oAccount=oAccountVar;
         bIsSelected=bIsSelectedVar;    
         populateMailingAddress(oAccountVar);     
      }
      private void populateMailingAddress(Account oAccountRecordVar)
      {
          sAccountMailingAddress = '';
          if(oAccountRecordVar.Mailing_Street__c <> null)
          sAccountMailingAddress += oAccountRecordVar.Mailing_Street__c+','+'<br/>';
          if(oAccountRecordVar.Mailing_City__c <> null)
          sAccountMailingAddress += oAccountRecordVar.Mailing_City__c+',';
          if(oAccountRecordVar.Mailing_State_Province__c <> null)
          sAccountMailingAddress += oAccountRecordVar.Mailing_State_Province__c+','+'<br/>';
          if(oAccountRecordVar.Mailing_Country__c <> null)
          sAccountMailingAddress += oAccountRecordVar.Mailing_Country__c+'-';
          if(oAccountRecordVar.Mailing_Zip_Postal_Code__c <> null)
          sAccountMailingAddress += oAccountRecordVar.Mailing_Zip_Postal_Code__c ;
      }
  }
}