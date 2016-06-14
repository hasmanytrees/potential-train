/*****************************************************************************************
    Name             : AWTrigger_Test
    Description      : Test class to cover scenario of AW_Trigger           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                05/02/2014            Created
Subhojit                
******************************************************************************************/
@isTest(seeAllData=true)
private class AWTrigger_Test{
   
        
        static testmethod void AWTrigger_Test()
    { 
        User u = [select id from User where id =: UserInfo.getUserId()];
        Account oAccountVar1=new Account(RecordtypeId=Utility.getRecordType('Supporter','Account'),Type='Business',Status__c='Active',Name='Testdata1',OwnerId = u.id,
                                         Business_Email__c='testdata1@testdata.com');
        Account oAccountVar2=new Account(RecordtypeId=Utility.getRecordType('Supporter','Account'),Type='Church',Status__c='Active',Name='Testdata2',OwnerId = u.id, 
                                         Business_Email__c='testdata2@testdata.com');       
        
        insert oAccountVar1;
        insert oAccountVar2;
                
        Relationship_Group__c rg = new Relationship_Group__c(Relationship__c = 'Admin', Status_Of_Relationship__c = 'Active',Group__c = oAccountVar1.id,
                                                             Supporter__c = oAccountVar2.id, dc3DisableDuplicateCheck__c= true, 
                                                             Primary_Contact_For_Account__c = true, ownerid = u.id );
        Insert rg;
        
        system.assertEquals('Active',rg.Status_Of_Relationship__c );
        
        rg.Relationship__c = 'Denomination';
        update rg;
        
        delete rg;
        
         Venue__C ven = new Venue__c(RecordtypeId=Utility.getRecordType('Venue','Venue__c'),Name='Venue test', Address_1__c ='abc' , City__c ='Andheri' , State__c ='Maharshtra', ZIP_Code__c='400059', Country__c='India');
        insert Ven; // Initializing Venue Record
        
        system.assertEquals('Venue test',ven.Name);
        
        ven.Name = 'Ven Test Update'; 
        Update Ven;
        
        delete ven;
     }
     
     
}