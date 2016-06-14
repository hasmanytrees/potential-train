/******************************************************************************
Name             : SBCPreferenceHelper
Description      : Trigger Helper class used to determine Supporters Delivery Preferences               
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/8/2015            Modified for code re-factoring 
                                            & optimization
****************************************************************************/
public class SBCPreferenceHelper{

    /**
    * Method name  : getSupporterPreferences
    * Description  : Use this method to get Supporter Preference without override
    *                
    * Return Type  : Map<String,Map<Id,String>>
    * Parameter    : Set<Id>
    **/  
    public static Map<String,Map<Id,String>> getSupporterPreferences(Set<Id> setSupporterId){

        Map<Id,Account> mapAccount=new Map<Id,Account>([select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,
        Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,
        Preferred_Email_Address__c,
        Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,
        Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c from 
        Account where Id In :setSupporterId]);
        Map<String,Map<Id,String>> mapAccountFinal=new Map<String,Map<Id,String>>();
        Map<Id,String> mapAccountPref=new Map<Id,String>();  
        Map<Id,String> mapAccountEmail=new Map<Id,String>();  
        Map<Id,String> mapAccountAddress=new Map<Id,String>();      
        for(Id accountId: mapAccount.KeySet()){
            Account oAccountVar=mapAccount.get(accountId);
            boolean bIsPhysicalAddressNotNull=false;
            boolean bIsMailingAddressNotNull=false;
            boolean bIsBillingAddressNotNull=false;
            boolean bIsPreferredAddressNotNull=false;
            boolean bIsAddressFound=false;
            boolean bIsEmailFound=false;
            String sPreferredAddress;
            String sPreferredEmail;         
            boolean bFlag=true;            
            //Checking  if Billing Address is present
            if( oAccountVar.BillingCity!=null && oAccountVar.BillingState!=null &&  oAccountVar.BillingCountry!=null ){
                
                if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2))
                bIsBillingAddressNotNull=true;
                
                else if(oAccountVar.Undeliverable_Invalid__c==null)
                bIsBillingAddressNotNull=true;
                
            }
            //Checking  if Physical  Address is present
            if( oAccountVar.ShippingCity!=null && oAccountVar.ShippingState!=null &&  oAccountVar.ShippingCountry!=null){
                // bIsPhysicalAddressNotNull=true;
                
                if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical))
                bIsPhysicalAddressNotNull=true;
                
                else if(oAccountVar.Undeliverable_Invalid__c==null)
                bIsPhysicalAddressNotNull=true;
                
            }
            //Checking  if Mailing  Address is present
            if( oAccountVar.Mailing_City__c!=null && oAccountVar.Mailing_State_Province__c!=null &&  oAccountVar.Mailing_Country__c!=null){
                // bIsMailingAddressNotNull=true;
                
                if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing))
                bIsMailingAddressNotNull=true;
                
                else if(oAccountVar.Undeliverable_Invalid__c==null)
                bIsMailingAddressNotNull=true;
                
                
             }
            //Checking  if Preferred Address is present
            if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Preferred_Address__c.contains(System.Label.Bill_to2)))  
            bIsPreferredAddressNotNull=bIsBillingAddressNotNull;  
            else if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Preferred_Address__c.contains(System.Label.Mailing)))  
            bIsPreferredAddressNotNull=bIsMailingAddressNotNull;  
            
            else if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Preferred_Address__c.contains(System.Label.Physical)))  
            bIsPreferredAddressNotNull=bIsPhysicalAddressNotNull;  
            if((bIsPhysicalAddressNotNull || bIsMailingAddressNotNull || bIsBillingAddressNotNull)==true)
            bIsAddressFound=true;
            
            
            //Setting Name of Address Preference 
            if(bIsPreferredAddressNotNull && oAccountVar.Undeliverable_Invalid__c!=null && (oAccountVar.Preferred_Address__c!=null)&&(!oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase()))  ){
                sPreferredAddress=oAccountVar.Preferred_Address__c;
            }
            else if((oAccountVar.Undeliverable_Invalid__c==null) && bIsPreferredAddressNotNull )
            sPreferredAddress=oAccountVar.Preferred_Address__c;

            else if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsMailingAddressNotNull){
                sPreferredAddress=System.Label.Mailing;
                
            }
            else if((oAccountVar.Undeliverable_Invalid__c==null) && bIsMailingAddressNotNull )
            sPreferredAddress=System.Label.Mailing;
            else if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsBillingAddressNotNull){
                sPreferredAddress=System.Label.Bill_to;
                
            }
            else if((oAccountVar.Preferred_Address__c==null) && bIsBillingAddressNotNull)
            sPreferredAddress=System.Label.Bill_to;
            else if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsPhysicalAddressNotNull){
                sPreferredAddress=System.Label.Physical;
                
            }
            else if((oAccountVar.Undeliverable_Invalid__c==null) && bIsPhysicalAddressNotNull)
            sPreferredAddress=System.Label.Physical;
            
            
            
            //Checking  Email Address 
            if(oAccountVar.Business_Email__c!=null || oAccountVar.Personal_Email__c!=null || oAccountVar.Work_Email__c!=null){
                
                // If Business Email is present
                if(oAccountVar.Business_Email__c!=null){
                    
                    if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email))
                    bIsEmailFound=true;
                    
                    else if(oAccountVar.Undeliverable_Invalid__c==null)
                    bIsEmailFound=true;
                }
                else if(oAccountVar.Personal_Email__c!=null){
                    // If Personal Email is present
                    if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal_Email))
                    bIsEmailFound=true;
                    
                    else if(oAccountVar.Undeliverable_Invalid__c==null)
                    bIsEmailFound=true;
                }
                else if(oAccountVar.Work_Email__c!=null){
                    // If Work Email is present
                    if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email))
                    bIsEmailFound=true;
                    
                    else if(oAccountVar.Undeliverable_Invalid__c==null)
                    bIsEmailFound=true;
                }
                
            }
            //Setting Name of Email Preference 
            if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && (oAccountVar.Preferred_Email_Address__c!=null)){
                sPreferredEmail=oAccountVar.Preferred_Email__c;
            }
            else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Preferred_Email_Address__c!=null)
            sPreferredEmail=oAccountVar.Preferred_Email__c;
            else   if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && (oAccountVar.Personal_Email__c!=null)){
                sPreferredEmail=System.Label.Personal;
            } 
            else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Personal_Email__c!=null)
            sPreferredEmail=System.Label.Personal;
            else  if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && (oAccountVar.Business_Email__c!=null)){
                sPreferredEmail=System.Label.Business;
            } 
            else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Business_Email__c!=null)
            sPreferredEmail=System.Label.Business;
            else  if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && (oAccountVar.Work_Email__c!=null)){
                
                sPreferredEmail=System.Label.Work;
            } 
            else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Work_Email__c!=null)
            sPreferredEmail=System.Label.Work;
            //If any of the Do Not Cheek boxes are checked
            if((oAccountVar.Do_Not_Contact__c)||(oAccountVar.Do_Not_Email__c)||(oAccountVar.Do_Not_Mail__c)){
                
                if(oAccountVar.Do_Not_Contact__c)
                mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);    // If Do not Contact is checked,set Preference to NONE
                else {
                    Integer iFlag=0;
                    if((oAccountVar.Do_Not_Email__c)&&(!oAccountVar.Do_Not_Mail__c)&&((oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Physical))||(oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Printed)))&&(!oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Email))){
                        // If  Correspondence Delivery Is Printed Digital Document Or Physical Original Document
                        if(oAccountVar.Undeliverable_Invalid__c!=null){
                            // If Undelivered is Not Blank and any of the address is present
                            if(bIsPreferredAddressNotNull && (oAccountVar.Preferred_Address__c!=null)&&(!oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase()))){
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);    // If Preferred Address is present,set Preference to MAIL
                                iFlag++;
                            }
                            else if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsMailingAddressNotNull){
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);    // If Mailing Address is present,set Preference to MAIL
                                iFlag++;
                            }
                            else if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsBillingAddressNotNull){
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);    // If Bill To Address is present,set Preference to MAIL
                                iFlag++; 
                            }
                            else if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsPhysicalAddressNotNull){
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);     // If Bill To Address is present,set Preference to MAIL
                                iFlag++;
                            }
                        }
                        else{
                            if(bIsAddressFound){
                                // If Undelivered is Blank and any of the address is present
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);  
                                iFlag++;
                                
                            }
                        }
                    }
                    else if(oAccountVar.Correspondence_Delivery_Preference__c!=null && (oAccountVar.Do_Not_Mail__c)&&(!oAccountVar.Do_Not_Email__c)&&(oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Email))){
                        // If  Correspondence Delivery Is Email of Letter Image
                        if(oAccountVar.Undeliverable_Invalid__c!=null){
                            // If Undelivered is not Blank and any of the Email is present
                            if(!oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && (oAccountVar.Preferred_Email_Address__c!=null)){
                                iFlag++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);   // If Preferred EMail is present,set Preference to EMAIL
                            }
                            else   if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && (oAccountVar.Personal_Email__c!=null)){
                                iFlag++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);  // If Personal EMail is present,set Preference to EMAIL
                            } 
                            else  if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && (oAccountVar.Business_Email__c!=null)){
                                iFlag++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);  // If Business EMail is present,set Preference to EMAIL
                            } 
                            else  if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && (oAccountVar.Work_Email__c!=null)){
                                
                                iFlag++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);  // If Work EMail is present,set Preference to EMAIL
                            } 
                        }  
                        else {
                            if(bIsEmailFound ){
                                // If Undelivered is  Blank and any of the Email is present
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                                iFlag++;
                            }
                            
                        }  
                    }
                    else if((oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Email))&& ((oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Print)|| oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Physical)))){
                        // If  Correspondence Delivery Is Email of Letter Image and Printed Digital Document or Email of Letter Image and Physical Original Document
                        mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2);
                        Integer iFlag1=0;
                        Integer iFlag2=0;
                        Integer Icheck=0;
                        Integer Icheck2=0;
                        
                        if(oAccountVar.Undeliverable_Invalid__c!=null){
                            // If Undelivered is not Blank and any of the Email and any of Address is present
                            //Checking for if Email Field value is present
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && bIsAddressFound){
                                iFlag1++;
                                Icheck++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            }
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && bIsAddressFound){
                                iFlag1++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            } 
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && bIsAddressFound){
                                iFlag1++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            } 
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && bIsAddressFound){
                                iFlag1++;
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            }      
                            //Checking for if Address Field value is present
                            if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase())) && bIsEmailFound){
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                                iFlag2++;
                                Icheck2++;
                            }
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsEmailFound){
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                                iFlag2++;
                            }
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsEmailFound){
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                                iFlag2++;
                            }
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsEmailFound){
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                                iFlag2++;
                            }
                            iFlag1=iFlag1-Icheck;
                            iFlag2=iFlag2-Icheck2;
                            if((iFlag1>=3)&&(iFlag2>=3))
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);    // If more than three fields are undelivered
                            else if((iFlag1<3)&&(iFlag2>=3) && bIsEmailFound && oAccountVar.Do_Not_EMail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);   // If more than three Address field are undelivered But at least one Email Field available
                            else if((iFlag1>=3)&&(iFlag2<3) && bIsAddressFound && oAccountVar.Do_Not_Mail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);   // If more than three Email field are undelivered But at least one Address Field available
                            
                            else if(bIsEmailFound && bIsAddressFound   && oAccountVar.Do_Not_EMail__c==false && oAccountVar.Do_Not_Mail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2  );   // If Both at least one EMail and Address Field is Available
                            else if(bIsEmailFound  && iFlag1<3 && oAccountVar.Do_Not_EMail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            else if(bIsAddressFound && iFlag2<3 && oAccountVar.Do_Not_Mail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            else
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);

                        }  
                        else {
                            // If Undelivered is  Blank and any of the Email and any of Address is present
                            if(bIsEmailFound && bIsAddressFound && !oAccountVar.Do_Not_EMail__c && !oAccountVar.Do_Not_Mail__c )
                            mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2);
                            else if(bIsEmailFound && oAccountVar.Do_Not_EMail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            else if(bIsAddressFound && oAccountVar.Do_Not_Mail__c==false)
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            else
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                            
                        }
                        
                        
                        bFlag=false;
                        
                        
                        
                        
                    }
                    if((iFlag>1) && bFlag)
                    mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2);
                    else if(bFlag){
                        
                        
                        if( bIsEmailFound && oAccountVar.Do_Not_EMail__c==false) 
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else if( bIsAddressFound && oAccountVar.Do_Not_Mail__c==false) 
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                        
                        
                        
                        
                        
                    }
                }
                
                
            }
            else{
                //If any of the Do Not Cheek boxes are not checked
                if(oAccountVar.Correspondence_Delivery_Preference__c!=null && ((oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Physical))
                            ||(oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Printed)))
                        &&(oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Email))){
                    
                    mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2);
                    Integer iFlag1=0;
                    Integer iFlag2=0;
                    Integer Icheck=0;
                    Integer Icheck2=0;
                    // It performs similar checks like above block
                    if(oAccountVar.Undeliverable_Invalid__c!=null){
                       //If Undelivered field is not black
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && bIsAddressFound){
                            iFlag1++;
                            Icheck++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);  // for preferred Email
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);  // for Personal Email
                        } 
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);  // for Business Email
                        } 
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);  // for Work Email
                        }      
                        
                        if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase())) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);     // If all Address is Undelivered,but Prefered Email is available
                            iFlag2++;
                            Icheck2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);  // If all Address is Undelivered,but Mailing Email is available
                            iFlag2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);   // If all Address is Undelivered,but Bill To Email is available
                            iFlag2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);   // If all Address is Undelivered,but Physical Email is available
                            iFlag2++;
                        }
                        iFlag1=iFlag1-Icheck;
                        iFlag2=iFlag2-Icheck2;
                        if((iFlag1>=3)&&(iFlag2>=3))
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2); 
                        else if((iFlag1<3)&&(iFlag2>=3) && bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2); 
                        else if((iFlag1>=3)&&(iFlag2<3) && bIsAddressFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        
                        else if(bIsEmailFound && bIsAddressFound )
                        mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2);
                        else if(bIsEmailFound  && iFlag1<3)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else if(bIsAddressFound && iFlag2<3)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);

                    }  
                    else {
                        if(bIsEmailFound && bIsAddressFound )
                        mapAccountPref.put(oAccountVar.Id,System.Label.BOTH2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                    }
                    
                }
                else if(oAccountVar.Correspondence_Delivery_Preference__c!=null && ((oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Physical))
                            ||(oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Printed)))){
                    // If  Correspondence Delivery Is Printed Digital Document Or Physical Original Document
                    Integer iFlag1=0;
                    Integer iFlag2=0;
                    Integer Icheck=0;
                    Integer Icheck2=0;
                    
                    if(oAccountVar.Undeliverable_Invalid__c!=null){
                        
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && bIsAddressFound){
                            iFlag1++;
                            Icheck++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && bIsAddressFound ){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        } 
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && bIsAddressFound) {
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        } 
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        }      
                        
                        if((oAccountVar.Preferred_Address__c!=null)&&
                                (oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase())) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                            Icheck2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                        }
                        iFlag1=iFlag1-Icheck;
                        iFlag2=iFlag2-Icheck2;
                        if((iFlag1>=3)&&(iFlag2>=3))
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2); 
                        else if((iFlag1<3)&&(iFlag2>=3) && bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2); 
                        else if((iFlag1>=3)&&(iFlag2<3) && bIsAddressFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else if((iFlag1<3)&&(iFlag2<3) && bIsAddressFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else if((iFlag1<3) && bIsAddressFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2); 
                        else if ((iFlag2<3) && bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                    } 
                    else{
                        
                        if( bIsAddressFound )
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                        
                    }
                }
                else if(oAccountVar.Correspondence_Delivery_Preference__c!=null && oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Email)){
                    // If  Correspondence Delivery Is Email of Letter Image
                    Integer iFlag1=0;
                    Integer iFlag2=0;
                    Integer Icheck=0;
                    Integer Icheck2=0;
                    if(oAccountVar.Undeliverable_Invalid__c!=null){
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && bIsAddressFound){
                            iFlag1++;
                            Icheck++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        } 
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        } 
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && bIsAddressFound){
                            iFlag1++;
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        }      
                        
                        if((oAccountVar.Preferred_Address__c!=null)
                                &&(oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase()) &&  bIsEmailFound)){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                            Icheck2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                        }
                        if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            iFlag2++;
                        }
                        iFlag1=iFlag1-Icheck;
                        iFlag2=iFlag2-Icheck2;
                        if((iFlag1>=3)&&(iFlag2>=3))
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2); 
                        else if((iFlag1<3)&&(iFlag2>=3) && bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2); 
                        else if((iFlag1>=3)&&(iFlag2<3) && bIsAddressFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else if((iFlag1<3)&&(iFlag2<3) && bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else if ((iFlag2<3) && bIsAddressFound ) 
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else if ((iFlag1<3) && bIsEmailFound) 
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                    } 
                    else{
                        // mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        
                        if( bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                        
                        
                    }
                }
                
                
                
                
            }
            if( mapAccountPref.get(oAccountVar.Id)!=null){ 
                String sPref= mapAccountPref.get(oAccountVar.Id);
                
                if(sPref==System.Label.EMAIL2)
                mapAccountEmail.put(oAccountVar.Id,sPreferredEmail);
                else if(sPref==System.Label.MAIL2)
                mapAccountAddress.put(oAccountVar.Id,sPreferredAddress);
                else if(sPref==System.Label.BOTH2){
                    mapAccountAddress.put(oAccountVar.Id,sPreferredAddress); 
                    mapAccountEmail.put(oAccountVar.Id,sPreferredEmail);
                }
                mapAccountFinal.put(System.Label.Preference,mapAccountPref);
                mapAccountFinal.put(System.Label.Email,mapAccountEmail);
                mapAccountFinal.put(System.Label.Mail,mapAccountAddress);
            }
            
            
        }



        return mapAccountFinal;

    }

    public Map<SBC_Communications__c,String> SBCPrefBasedOnSupporter(List<SBC_Communications__c> lstSBCComm,Map<Id,String> mapAccountPref){


        Map<SBC_Communications__c,String> mapSBCCommPref=new Map<SBC_Communications__c,String>();
        
        for(SBC_Communications__c oSBCCommVar : lstSBCComm){
            
            
            oSBCCommVar.Status__c=System.Label.Delivered;
            if(mapAccountPref.get(oSBCCommVar.Supporter__c)==System.Label.MAIL2)
            mapSBCCommPref.put(oSBCCommVar ,System.Label.MAIL2);
            else if(mapAccountPref.get(oSBCCommVar.Supporter__c)==System.Label.EMAIL2)
            mapSBCCommPref.put(oSBCCommVar ,System.Label.EMAIL2);
            else if(mapAccountPref.get(oSBCCommVar.Supporter__c)==System.Label.BOTH2)
            mapSBCCommPref.put(oSBCCommVar ,System.Label.BOTH2);
            else{
                
                oSBCCommVar.Status__c=System.Label.Complete_Undelivered;
                mapSBCCommPref.put(oSBCCommVar ,System.Label.NONE2); 
            }
            
            
            
        }

        return mapSBCCommPref;
    }

    public static Map<String,Map<Id,String>> overrideDeliveryPref(Map<Id,String> mapAccountPrefVar){

        Map<Id,Account> mapAccount=new Map<Id,Account>([select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,
        Business_Email__c,Personal_Email__c,Work_Email__c,BillingCity,BillingState,BillingCountry,
        Preferred_Email_Address__c,
        Mailing_State_Province__c,Mailing_City__c,Mailing_Country__c,ShippingCity,ShippingState,ShippingCountry,
        Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c from Account where Id In :mapAccountPrefVar.keySet()]);
        
        Map<String,Map<Id,String>> mapAccountFinal=new Map<String,Map<Id,String>>();
        Map<Id,String> mapAccountPref=new Map<Id,String>();  
        Map<Id,String> mapAccountEmail=new Map<Id,String>();  
        Map<Id,String> mapAccountAddress=new Map<Id,String>();   
        
        for(Id accountId : mapAccount.keySet()){
            
            
            Account oAccountVar=mapAccount.get(accountId);
            
            boolean bIsPhysicalAddressNotNull=false;
            boolean bIsMailingAddressNotNull=false;
            boolean bIsBillingAddressNotNull=false;
            boolean bIsPreferredAddressNotNull=false;
            boolean bIsAddressFound=false;
            boolean bIsEmailFound=false;
            String sPreferredEmail;
            String sPreferredAddress;
            
                       
            
            
            if(mapAccountPrefVar.get(accountId)==System.Label.NONE2){
                
                
                
                
                
                if( oAccountVar.BillingCity!=null && oAccountVar.BillingState!=null &&  oAccountVar.BillingCountry!=null ){
                    
                    if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2))
                    bIsBillingAddressNotNull=true;
                    
                    else if(oAccountVar.Undeliverable_Invalid__c==null)
                    bIsBillingAddressNotNull=true;
                    
                }
                else if( oAccountVar.ShippingCity!=null && oAccountVar.ShippingState!=null &&  oAccountVar.ShippingCountry!=null){
                    // bIsPhysicalAddressNotNull=true;
                    
                    if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical))
                    bIsPhysicalAddressNotNull=true;
                    
                    else if(oAccountVar.Undeliverable_Invalid__c==null)
                    bIsPhysicalAddressNotNull=true;
                    
                }
                else if( oAccountVar.Mailing_City__c!=null && oAccountVar.Mailing_State_Province__c!=null &&  oAccountVar.Mailing_Country__c!=null){
                    // bIsMailingAddressNotNull=true;
                    
                    if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing))
                    bIsMailingAddressNotNull=true;
                    
                    else if(oAccountVar.Undeliverable_Invalid__c==null)
                    bIsMailingAddressNotNull=true;
                    
                    
                }
                if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Preferred_Address__c.contains(System.Label.Bill_to2)))  
                bIsPreferredAddressNotNull=bIsBillingAddressNotNull;  
                else if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Preferred_Address__c.contains(System.Label.Mailing)))  
                bIsPreferredAddressNotNull=bIsMailingAddressNotNull;  
                
                else if((oAccountVar.Preferred_Address__c!=null)&&(oAccountVar.Preferred_Address__c.contains(System.Label.Physical)))  
                bIsPreferredAddressNotNull=bIsPhysicalAddressNotNull;  
                if((bIsPhysicalAddressNotNull || bIsMailingAddressNotNull || bIsBillingAddressNotNull)==true && !oAccountVar.Do_Not_Mail__c)
                bIsAddressFound=true;
                
                
                if(bIsPreferredAddressNotNull && oAccountVar.Undeliverable_Invalid__c!=null && (oAccountVar.Preferred_Address__c!=null)&&(!oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase()))  ){
                    sPreferredAddress=oAccountVar.Preferred_Address__c;
                }
                else if((oAccountVar.Preferred_Address__c!=null) && bIsPreferredAddressNotNull )
                sPreferredAddress=oAccountVar.Preferred_Address__c;

                else if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsMailingAddressNotNull){
                    sPreferredAddress=System.Label.Mailing;
                    
                }
                else if(bIsMailingAddressNotNull )
                sPreferredAddress=System.Label.Mailing;
                else if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsBillingAddressNotNull){
                    sPreferredAddress=System.Label.Bill_to;
                    
                }
                else if(bIsBillingAddressNotNull)
                sPreferredAddress=System.Label.Bill_to;
                else if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsPhysicalAddressNotNull){
                    sPreferredAddress=System.Label.Physical;
                    
                }
                else if(bIsPhysicalAddressNotNull)
                sPreferredAddress=System.Label.Physical;
                
                
                
                 
                
                
                if(oAccountVar.Business_Email__c!=null || oAccountVar.Personal_Email__c!=null || oAccountVar.Work_Email__c!=null){
                    
                    if(oAccountVar.Business_Email__c!=null){
                        
                        if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && !oAccountVar.Do_Not_Email__c)
                        bIsEmailFound=true;
                        
                        else if(oAccountVar.Undeliverable_Invalid__c==null)
                        bIsEmailFound=true;
                    }
                    else if(oAccountVar.Personal_Email__c!=null){
                        
                        if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal_Email)  && !oAccountVar.Do_Not_Email__c)
                        bIsEmailFound=true;
                        
                        else if(oAccountVar.Undeliverable_Invalid__c==null)
                        bIsEmailFound=true;
                    }
                    else if(oAccountVar.Work_Email__c!=null){
                        
                        if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email)  && !oAccountVar.Do_Not_Email__c)
                        bIsEmailFound=true;
                        
                        else if(oAccountVar.Undeliverable_Invalid__c==null)
                        bIsEmailFound=true;
                    }
                    
                }
                 
                if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && (oAccountVar.Preferred_Email_Address__c!=null)){
                    sPreferredEmail=oAccountVar.Preferred_Email__c;
                }
                else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Preferred_Email_Address__c!=null){
                sPreferredEmail=oAccountVar.Preferred_Email__c;
              
                }
                else   if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && (oAccountVar.Personal_Email__c!=null)){
                    sPreferredEmail=System.Label.Personal;
                } 
                else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Personal_Email__c!=null){
                sPreferredEmail=System.Label.Personal;
                 
                }
                else  if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && (oAccountVar.Business_Email__c!=null)){
                    sPreferredEmail=System.Label.Business;
                } 
                else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Business_Email__c!=null){
                sPreferredEmail=System.Label.Business;
               
                }
                else  if(oAccountVar.Undeliverable_Invalid__c!=null && !oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && (oAccountVar.Work_Email__c!=null)){
                    sPreferredEmail=System.Label.Work;
                } 
                else if(oAccountVar.Undeliverable_Invalid__c==null && oAccountVar.Work_Email__c!=null)
                sPreferredEmail=System.Label.Work;
                
                                 
                if(oAccountVar.Do_Not_Contact__c)
                mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                
                
                else if((oAccountVar.Do_Not_Email__c)&&(!oAccountVar.Do_Not_Mail__c)){
                    if(oAccountVar.Undeliverable_Invalid__c!=null){
                        if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing)){
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        }
                        if((oAccountVar.Preferred_Address__c!=null)&&
                                (!oAccountVar.Undeliverable_Invalid__c.toUpperCase().Contains(oAccountVar.Preferred_Address__c.toUpperCase())) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            
                        }
                        else if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            
                        }
                        
                        else if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            
                        }
                        
                        else if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical) && bIsEmailFound){
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            
                        }
                        
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                    } 
                    else{
                        // mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        if( bIsAddressFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        
                    }
                }     
                else if((oAccountVar.Do_Not_Mail__c)&&(!oAccountVar.Do_Not_Email__c)){
                    if(oAccountVar.Undeliverable_Invalid__c!=null){
                        if(!oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email') && (oAccountVar.Preferred_Email_Address__c!=null)){
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        }
                        else   if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Personal) && (oAccountVar.Personal_Email__c!=null)){
                            
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        } 
                        else  if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Business_Email) && (oAccountVar.Business_Email__c!=null)){
                            
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        } 
                        else  if(!oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Work_Email) && (oAccountVar.Work_Email__c!=null)){
                            
                            mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        } 
                        
                        
                        else{
                            
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing))
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2); 
                            else if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Bill_to2))
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                            else if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Physical))
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                            else
                            mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                            
                        }
                    }
                    else{
                        if( bIsEmailFound)
                        mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        else
                        mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        //  mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                        
                        
                    }
                }
                else if((!oAccountVar.Do_Not_Mail__c)&&(!oAccountVar.Do_Not_Email__c)&&(!oAccountVar.Do_Not_Contact__c)){
                    
                    if(oAccountVar.Correspondence_Delivery_Preference__c.Contains(System.Label.Email)) {
                        Integer iFlag=0;
                        if(oAccountVar.Undeliverable_Invalid__c!=null){
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(oAccountVar.Preferred_Email__c+' Email' ) && bIsAddressFound){
                                mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                                iFlag++;
                                
                            }
                            if(oAccountVar.Undeliverable_Invalid__c.Contains(System.Label.Mailing) && bIsAddressFound){
                                mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                                iFlag++;
                                
                            }
                            
                            if(iFlag>1)
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                            
                        }
                        else{
                           
                            
                            if(bIsEmailFound)
                               mapAccountPref.put(oAccountVar.Id,System.Label.EMAIL2);
                            else if(bIsAddressFound)
                               mapAccountPref.put(oAccountVar.Id,System.Label.MAIL2);
                           
                            else
                            mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                        }
                        
                    }
                    
                    
                    
                }
                else
                mapAccountPref.put(oAccountVar.Id,System.Label.NONE2);
                
                if( mapAccountPref.get(oAccountVar.Id)!=null){ 
                    String sPref= mapAccountPref.get(oAccountVar.Id);
                    
                    if(sPref==System.Label.EMAIL2)
                    mapAccountEmail.put(oAccountVar.Id,sPreferredEmail);
                    else if(sPref==System.Label.MAIL2)
                    mapAccountAddress.put(oAccountVar.Id,sPreferredAddress);
                    else if(sPref==System.Label.BOTH2){
                        mapAccountAddress.put(oAccountVar.Id,sPreferredAddress); 
                        mapAccountEmail.put(oAccountVar.Id,sPreferredEmail);
                    }
                }
                mapAccountFinal.put(System.Label.Preference,mapAccountPref);
                mapAccountFinal.put(System.Label.Email,mapAccountEmail);
                mapAccountFinal.put(System.Label.Mail,mapAccountAddress);
                
            } 
        }  

        
        
        
        return mapAccountFinal;

    }
    /**
    * Method name  : setFianlDeliveryPreference
    * Description  : Use this method to override supporter preference if supporter is unreachable using preferred scenario
    *                
    * Return Type  : Map<Id,String> 
    * Parameter    : Map<Id,String> ,Map<Id,String> 
    **/  
    public static Map<Id,String> setFianlDeliveryPreference(Map<Id,String> mapAccountVar,Map<Id,String> mapAccountOverrideVar){


        Map<Id,Account> mapAccount=new Map<Id,Account>([select Id,Do_Not_Contact__c,Do_Not_Email__c,Preferred_Email__c,
        Business_Email__c,Personal_Email__c,Work_Email__c,
        Preferred_Address__c,Undeliverable_Invalid__c,Do_Not_Mail__c,Correspondence_Delivery_Preference__c 
        from Account where Id In :mapAccountVar.keySet() ]);
        Map<Id,String> mapAccountPref=new Map<Id,String>();      
        for(Id accountId: mapAccount.KeySet()){
            
            if(mapAccountOverrideVar!=null && mapAccountOverrideVar.get(accountId)!=null){
                String sPrefvar=mapAccountOverrideVar.get(accountId);
                
                if(sPrefvar!=System.Label.BOTH2){
                    if(mapAccount.get(accountId).Correspondence_Delivery_Preference__c!=null &&
                            ( mapAccount.get(accountId).Correspondence_Delivery_Preference__c.StartsWith(System.Label.Print)
                                ||mapAccount.get(accountId).Correspondence_Delivery_Preference__c.StartsWith(System.Label.Physical)) && sPrefvar==System.Label.MAIL2)
                    mapAccountPref.put(accountId,mapAccount.get(accountId).Correspondence_Delivery_Preference__c);
                    else
                    mapAccountPref.put(accountId,Final_Delivery_Preference_Map__c.getAll().get(sPrefvar).Final_Delivery_Preference__c);
                }
                else  {
                    
                    mapAccountPref.put(accountId,mapAccount.get(accountId).Correspondence_Delivery_Preference__c);
                    
                    
                }
            } 
            else  if(mapAccountVar.get(accountId)!=null){
                String sPrefvar=mapAccountVar.get(accountId);
                if(sPrefvar!=System.Label.BOTH2){
                    if(mapAccount.get(accountId).Correspondence_Delivery_Preference__c!=null &&
                            ( mapAccount.get(accountId).Correspondence_Delivery_Preference__c.StartsWith(System.Label.Print)
                                ||mapAccount.get(accountId).Correspondence_Delivery_Preference__c.StartsWith(System.Label.Physical)) && sPrefvar==System.Label.MAIL2)
                    mapAccountPref.put(accountId,mapAccount.get(accountId).Correspondence_Delivery_Preference__c);
                    else
                    mapAccountPref.put(accountId,Final_Delivery_Preference_Map__c.getAll().get(sPrefvar).Final_Delivery_Preference__c);
                }
                else  {
                    
                    mapAccountPref.put(accountId,mapAccount.get(accountId).Correspondence_Delivery_Preference__c);
                    
                    
                }
            }              

        } 
        return mapAccountPref;

    }




}