/*******************************************************************************
    Name             : VolunteerCoordinatorInlineExtension 
    Description      : This is used as vf controller for page 
                       volunteerCoordinatorInline which gives custom look up to
                       search Volunteer Co Ordinator based on custom logic               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014        Created
Subhojit              29/01/2015        Modified for code re-factoring & 
                                        optimization
*******************************************************************************/
public with sharing class VolunteerCoordinatorInlineExtension {
    public Campaign oEventLocation{get;set;}
    public boolean bFlag{get;set;} 
    public boolean bIsErrorOccured{get;set;}
    public List<User>  lstVolunteerCoordinator{get;set;}
    public List<User>  lstVolunteerCoordinatorManager{get;set;}
    public String sSearchValue{get;set;}
    public String sSelectedVC{get;set;}
    public String sSelectedVCManager{get;set;}
    public List<SelectOption> lstVolunteerCoordinatorPicklist{get;set;}
    public List<SelectOption> lstVolunteerCoordinatorManagerPicklist{get;set;}
    
    public VolunteerCoordinatorInlineExtension(ApexPages.StandardController 
    controller) {
        bFlag=false;
        bIsErrorOccured=false;
        Id campaignId=controller.getID();
        oEventLocation=[select Id,Name,State__c,Venue__r.State__c,
        Volunteer_Coordinator__c,Volunteer_Coordinator__r.Id,
        Volunteer_Coordinator__r.Name,Event_Volunteer_Manager__r.Name,
        Event_Volunteer_Manager__c,Event_Volunteer_Manager__r.Id 
        from Campaign where Id=: campaignId]; //Getting Event Location Details
        sSelectedVC=oEventLocation.Volunteer_Coordinator__c;
        sSelectedVCManager=oEventLocation.Event_Volunteer_Manager__c;
        List<Volunteer_Coordinator_Assignment__c> 
        lstVolunteerCoordinatorDetails=new 
        List<Volunteer_Coordinator_Assignment__c>();
        lstVolunteerCoordinator=new List<User>();
        lstVolunteerCoordinatorManager=new List<User>();
        lstVolunteerCoordinatorPicklist=new List<SelectOption> ();
        lstVolunteerCoordinatorManagerPicklist=new List<SelectOption> ();
        sSearchValue='';
        String sState='';
        if(oEventLocation.Venue__r.State__c!=null)
        sState=oEventLocation.Venue__r.State__c;//Getting Venue State
        if(sState=='')
        sState='All';
        else{
            
            try{
                pw_ccpro__State__c oStateISOCode=new pw_ccpro__State__c();
                oStateISOCode=[select Id,Name,pw_ccpro__FullIsoCode__c,
                pw_ccpro__IsoCode__c from pw_ccpro__State__c 
                where Name=:sState OR  pw_ccpro__IsoCode__c=:sState limit 1];
                //Getting ISO Code for Venue State 
                if(oStateISOCode.pw_ccpro__IsoCode__c!=null)                                                                
                sState=oStateISOCode.pw_ccpro__IsoCode__c;
            }
            catch(Exception ex){
                
                sState='All';
                
            }
        }
        //Querying Custom Setting to get matched VCs
        
        lstVolunteerCoordinatorDetails=[select Id,Name,CoOrdinator__c,States__c,
        Role__c  from Volunteer_Coordinator_Assignment__c where States__c 
        like :('%'+sState+'%')]; 
        //This will execute for VCs available for All location.
        List<Volunteer_Coordinator_Assignment__c> lstVCAll = 
        new List<Volunteer_Coordinator_Assignment__c>();
        
        lstVCAll=[select Id,Name,CoOrdinator__c,States__c,Role__c 
        from Volunteer_Coordinator_Assignment__c where States__c 
        = :(System.label.All) ];
        lstVolunteerCoordinatorDetails.addAll(lstVCAll);
        List<Volunteer_Coordinator_Assignment__c> 
        lstVolunteerCoordinatorDetailsVar =  
        lstVolunteerCoordinatorDetails.clone();  
        lstVolunteerCoordinatorDetails 
        = new List<Volunteer_Coordinator_Assignment__c>();
        
        //Filtering result based on State
 for(Integer iIndex=0;iIndex< lstVolunteerCoordinatorDetailsVar.size();iIndex++){            
    lstVolunteerCoordinatorDetails.add(lstVolunteerCoordinatorDetailsVar[iIndex]);
        }    
        
        
        
        Set<String> setUserName=new Set<String>();
        Set<String> setUserManagerName=new Set<String>();
        
        for(Volunteer_Coordinator_Assignment__c  oVolunteerAssignVar: 
        lstVolunteerCoordinatorDetails){
            
            if((oVolunteerAssignVar.Role__c!=null)&&
            (oVolunteerAssignVar.Role__c.contains('Manager')))
            setUserManagerName.add(oVolunteerAssignVar.CoOrdinator__c );
            
            setUserName.add(oVolunteerAssignVar.CoOrdinator__c );
            
            
        }
        lstVolunteerCoordinator=[select Id,Name from User where Name
        IN :setUserName and isActive = true]; 
        //Getting VCs User record details
        lstVolunteerCoordinatorManager=[select Id,Name from User where Name
        IN :setUserManagerName and isActive = true]; 
        //Getting VC Managers User record details
        
        for(User oUserVar: lstVolunteerCoordinator)
        lstVolunteerCoordinatorPicklist.add(new SelectOption(oUserVar.Id,
        oUserVar.Name));
        for(User oUserVar: lstVolunteerCoordinatorManager)
        lstVolunteerCoordinatorManagerPicklist.add(new SelectOption(oUserVar.Id,
        oUserVar.Name));
    }


    
    /**
    * Method name  : showInput
    * Description  : Use this method to show Volunteer Co Ordinator Look up
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    public void showInput(){

        if(!bFlag)
        bFlag=true;
        else
        bFlag=false;

        

    } 
    /**
    * Method name  : Save
    * Description  : Use this method to save user selected VC
    *                
    * Return Type  : pageReference 
    * Parameter    : void
    **/
    public void save(){
       
        if(sSelectedVC!=null) 
        oEventLocation.Volunteer_Coordinator__c=sSelectedVC;
        if(sSelectedVCManager!=null) 
        oEventLocation.Event_Volunteer_Manager__c=sSelectedVCManager;
        try
        {
            update oEventLocation;
        }
        catch(Exception ex)
        {
           
            bIsErrorOccured=true;
            //Creating a new Error Log record whenever any exception is 
            //encountered while performing DML Operation
            Error_Log__c oErrorLog = new Error_Log__c();
            oErrorLog.Error_Message__c = ex.getMessage()+'\n'+ex
            .getStackTraceString();
            oErrorLog.sObject__c = 'Event Location';
            oErrorLog.Related_Record_Id__c = oEventLocation.id;
            oErrorLog.Error_Module__c = 'VolunteerCoordinatorInlineExtension';
            oErrorLog.Error_Sub_Module__c = 'save';
            oErrorLog.Error_Type__c = 'Application';
            oErrorLog.Logged_In_User__c = UserInfo.getUserId();
            oErrorLog.New_Instance__c = String.valueOf(oEventLocation);
            Utility.insertErrorLog(oErrorLog);
           
        }
        finally
        {  
            if(!bIsErrorOccured)
             showInput();
          
        }
    
    }

}