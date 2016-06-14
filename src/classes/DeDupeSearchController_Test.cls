/*****************************************************************************************
    Name             : DeDupeSearchController_Test
    Description      : Main test class  to cover all Id scenarios in Buttons classes                 
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/
@isTest(SeeAllData=true)
public class DeDupeSearchController_Test{

       static testMethod void DeDupe_Test()
    { 
      
   DeDupeSearchController dsc = new DeDupeSearchController();
   dsc.sAccountFirstName = 'test Acc First Name';
      dsc.search();
       dsc.sAccountLastName = 'Acc Last Name'; 
       dsc.search();
       dsc.sAccountEmail = 'abc@gmail.com';
       dsc.search();
       dsc.sAccountPhone = '8623782872';
       dsc.search();
       dsc.sAccountAddress = 'address account';       
      
       dsc.search();
   Account oAccountVar21=new Account(Type='Business',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com');
       insert oAccountVar21;
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = oAccountVar21.id;
       Test.setFixedSearchResults(fixedSearchResults);
      dsc.sAccountFirstName = 'test Acc First Name';
     // dsc.search();
       dsc.sAccountLastName = 'Acc Last Name'; 
       //dsc.search();
       dsc.sAccountEmail = 'abc@gmail.com';
       //dsc.search();
       dsc.sAccountPhone = '8623782872';
       //dsc.search();
       dsc.sAccountAddress = 'address account';       
      
       dsc.search();
       
        dsc.init();
       
       Account oAccountVar1=new Account(Type='Business',Status__c='Active',Name='Testdata',Business_Email__c='testdata1@testdata.com' ,
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oAccountVar1;
       Account oAccountVar2=new Account(Type='Business',Status__c='Active',Name='Testdata',Business_Email__c='testdata2@testdata.com' ,
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oAccountVar2; 
        Account oAccountVar3=new Account(Type='Business',Status__c='Active',Name='Testdata',Business_Email__c='testdata3@testdata.com' , 
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oAccountVar3; 
        Account oAccountVar4=new Account(Type='Business',Status__c='Active',Name='Testdata',Business_Email__c='testdata4@testdata.com' ,
                                        dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oAccountVar4; 
        DeDupeSearchController.AccountWrapper Accwrap = new DeDupeSearchController.AccountWrapper(oAccountVar1,true);     
        Accwrap.oAccount = oAccountVar1;
        Accwrap.bIsSelected = true;   
        DeDupeSearchController.AccountWrapper Accwrap2 = new DeDupeSearchController.AccountWrapper(oAccountVar1,true);     
        Accwrap2.oAccount = oAccountVar2;
        Accwrap2.bIsSelected = true; 
         DeDupeSearchController.AccountWrapper Accwrap3 = new DeDupeSearchController.AccountWrapper(oAccountVar1,true);     
        Accwrap3.oAccount = oAccountVar3;
        Accwrap3.bIsSelected = true;
         DeDupeSearchController.AccountWrapper Accwrap4 = new DeDupeSearchController.AccountWrapper(oAccountVar1,true);     
        Accwrap4.oAccount = oAccountVar4;
        Accwrap4.bIsSelected = true;   
        dsc.lstAccountWrapper.add(Accwrap);
        dsc.lstAccountWrapper.add(Accwrap2);
        dsc.lstAccountWrapper.add(Accwrap3);
        dsc.lstAccountWrapper.add(Accwrap4);
         fixedSearchResults= new Id[4];
       fixedSearchResults[0] = oAccountVar1.id;
       fixedSearchResults[1] = oAccountVar2.id;
       fixedSearchResults[2] = oAccountVar3.id;
       fixedSearchResults[3] = oAccountVar4.id;
       Test.setFixedSearchResults(fixedSearchResults);
        dsc.sAccountLastName = 'Testdata'; 
         dsc.search();
       dsc.sSelectedAccount = '0,' ;
        dsc.mergeAccount();
        dsc.sSelectedAccount = '0,1' ;
        dsc.mergeAccount();
         dsc.sSelectedAccount = '0,1,2,3';
        dsc.mergeAccount();
   } 
   
   static testMethod void DeDupe_Test2()
    { 
      
   DeDupeSearchController dsc = new DeDupeSearchController();
     
       dsc.sAccountLastName = 'Acc Last Name'; 
       dsc.search();
       dsc.sURL = 'Demo URL';
       System.assertEquals('Demo URL', dsc.sURL);    
       Account oAccountVar1=new Account(Type='Business',Mailing_Zip_Postal_Code__c='32145',Mailing_Street__c='test srteet',Mailing_City__c='test City',
                                           Mailing_State_Province__c='test State',Status__c='Active',dupcheck__dc3DisableDuplicateCheck__c = true , 
                                           Name='Testdata1',Business_Email__c='testdata1@testdata.com');
       insert oAccountVar1;
       Account oAccountVar2=new Account(Type='Business',BillingPostalCode='32145',Status__c='Active',Name='Testdata2',Business_Email__c='testdata2@testdata.com' ,
                                           dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oAccountVar2;
       Account oAccountVar3=new Account(Type='Business',ShippingPostalCode='32145',Status__c='Active',Name='Testdata3',Business_Email__c='testdata3@testdata.com' ,
                                           dupcheck__dc3DisableDuplicateCheck__c = true );
       insert oAccountVar3;
       System.assert(oAccountVar1.id <> null);
       
       
       DeDupeSearchController dsc2 = new DeDupeSearchController();
       Id [] fixedSearchResults= new Id[1];
       fixedSearchResults[0] = oAccountVar1.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sAccountAddress = '3214'; 
        dsc2.sAccountLastName = 'Testdata1'; 
       dsc2.search();
       fixedSearchResults[0] = oAccountVar2.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sAccountAddress = '3214'; 
       dsc2.search();
       fixedSearchResults[0] = oAccountVar2.id;
       Test.setFixedSearchResults(fixedSearchResults);
       dsc2.sAccountAddress = '3214'; 
       dsc2.search();
       dsc2.sSelectedAccount=oAccountVar2.id+','+oAccountVar1.id;
       dsc2.mergeAccount();
      
   } 
      
}