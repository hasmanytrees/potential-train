/*******************************************************************************
    Name             : AddEditInfluencerController
    Description      : This class is vf controller for AddEditInfluencer 
    which is used to add new Influencer and designate their percentage             
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring 
                                              & optimization
Apurva                  05/10/2015            Changes made for INC0067772
Shanu                   23/10/2015            Changes made for COR0001493   
*******************************************************************************/
public with Sharing class AddEditInfluencerController
{

    public Integer iIndexValue = 0;    
    Public string sNoRecordsInInfuencerTableErrorMessage{get;set;}    
    public list<InfluencerWrapper> lstInfluencerWrapper{get;set;}
    public list<InfluencerWrapper> lstInfluencerWrapperFinal{get;set;}    
    public Influencer__c oInfluencerRecord {get;set;}    
    public Influencer__c oInfluencerNewRecord {get;set;}    
    public list<Influencer__c> lstAllsourceCode_influencer{get;set;}    
    public list<Influencer__c> lstEditInfluencer{get;set;}    
    public list<Influencer__c> lstAddNewInfluencer{get;set;}    
    public map<id,id> mapInfluencer = new map<id,id>();    
    public map<integer,Influencer__c> mapInfluencerEdit{get;set;}    
    public id parentEventLocationId;    
    public id newInfluencerRecId;    
    public string sErrorMsg ;    
    public string sAllErrorMsg;    
    public integer iCount = 0;    
    public Integer iRowToRemove {get;set;}    
    public boolean bInfluencerTableEditRecordsRender{get;set;}    
    public boolean bIsAddNewInfluencerClicked{get;set;}    
    public integer iEditLstIndex{get;set;}
    private list<Influencer__c> lstInfluencerDelete=
    new  list<Influencer__c>();
    public boolean bIsSaved{get;set;}
    private Map<Id,Influencer__c > mapInfluencerRecord;
    
    /**
    * Method name  : Constructor
    * Description  : Used for Initializing the boolean variables and 
    getting the page parameters and calling the initialization method
    *                
    * Return Type  : void
    * Parameter    : void
    **/  
    
    //Constructor to fetch parent event Location id, 
    //and setting rendering variables
    public AddEditInfluencerController()
    {
        parentEventLocationId = 
        ApexPages.currentPage().getParameters().get('eventLocationId');    
        lstInfluencerWrapper = new list<InfluencerWrapper>(); 
         bIsSaved=false;
        bInfluencerTableEditRecordsRender = false;
        
        bIsAddNewInfluencerClicked = true;   
        
        mapInfluencerEdit = new map<integer,Influencer__c>();  
        init();  
    }
    
    /**
    * Method name  : Init
    * Description  : Used for retrieving all Influencers 
    for the corresponding Event Location 
      and adding it to a map otherwise present a user friendly message
    *                
    * Return Type  : void
    * Parameter    : void
    **/
    
    public void init(){
       
        lstInfluencerWrapper=new list<InfluencerWrapper >(); 
        lstInfluencerWrapperFinal=new list<InfluencerWrapper>(); 
        mapInfluencerRecord=new Map<Id,Influencer__c >();
        iIndexValue = 0;
        
        lstAllsourceCode_Influencer = [Select Influencer__c,Id,
        Name,of_Influence__c, Credit__c, 
        Partner_Type__c, Presentation_Start_Time__c, Travel_Start_date__c,
        Influencer__r.Type,Travel_End_Date__c, Source_Code__c,
        Influencer__r.SUP_Id__c, Influencer_Id__c  
        from Influencer__c where 
        campaign__r.id =: parentEventLocationId order by createdDate asc];    
        
        for(Influencer__c i1: lstAllsourceCode_influencer)
        {   
            lstInfluencerWrapperFinal.add(
            new InfluencerWrapper(i1, iIndexValue++)); 
            mapInfluencerRecord.put(i1.Id,i1);                    
        }   
        
        if(lstAllsourceCode_influencer.size() == 0 )
        {    
            //There are no influencers related to this event. 
            //Please add new influence by clicking on the 
            //Add New Influencer button.
            sNoRecordsInInfuencerTableErrorMessage= 
            System.Label.NoInfluencerFound;            
        }      
    }
    
    /**
    * Method name  : GoBacktoEventLocation
    * Description  : Used for moving back to the concerned Event Location
    *                
    * Return Type  : pagereference
    * Parameter    : void
    **/        
    //Takes the controller back to Event Location detail page. 
    public pagereference goBacktoEventLocation()
    {        
        pageReference Page = new PageReference('/'+parentEventLocationId);

        Page.setRedirect(false);

        return Page;
    }
    
    /**
    * Method name  : deleteInfluencer
    * Description  : Used for removing Influencer if the same has been deleted 
                     by the User both from Map and from Influencer records
    *                
    * Return Type  : pagereference
    * Parameter    : void
    **/
    //Deletes Existing influencer record when user clicks on Delete link, 
    //from the influencer lst, for an influencer record.
    public pagereference deleteInfluencer()
    {
        list<InfluencerWrapper> lstInfluencerWrapperVar=
        new list<InfluencerWrapper>();
        lstInfluencerWrapperVar.addAll(lstInfluencerWrapper);
        lstInfluencerWrapper=new list<InfluencerWrapper>();
        
        
        for(InfluencerWrapper influencerWrapperVar: lstInfluencerWrapperVar){
            
            if(influencerWrapperVar.iIndex!=iRowToRemove )
            lstInfluencerWrapper.add(influencerWrapperVar);
            else{
                if(mapInfluencerRecord.get(
                influencerWrapperVar.oInfluencerReference.Id)!=null){
                    lstInfluencerDelete.add(
                    influencerWrapperVar.oInfluencerReference);
                    mapInfluencerRecord.remove(
                    influencerWrapperVar.oInfluencerReference.Id);   
                }
            } 
        } 
        lstInfluencerWrapperVar=new list<InfluencerWrapper>(); 
        
        lstInfluencerWrapperVar.addAll(lstInfluencerWrapper);
        lstInfluencerWrapper=new list<InfluencerWrapper>();
        for(InfluencerWrapper influencerWrapperVar: lstInfluencerWrapperVar){
            lstInfluencerWrapper.add(
            new InfluencerWrapper(
            influencerWrapperVar.oInfluencerReference,iIndexValue++));
        }   
        
      
        
        return null;
    }
    
    /**
    * Method name  : saveInfluencerTable
    * Description  : Used for creating the primary Influencer Table 
                     for display to the User
    *                
    * Return Type  : pagereference
    * Parameter    : void
    **/
    //Saves all the records in Influencer table 
    //Shanu- Oct 2015 Changes made for COR0001493
    public pagereference saveInfluencerTable()    
    { 
        map<id,id> mapSaveInfluencer = new map<id,id>();        
        iCount = 0;
        Integer iSelected = 0;
       
        bIsAddNewInfluencerClicked = false;
        lstEditInfluencer =new list<Influencer__c>();
     
        //lstInfluencerWrapper      
        for(InfluencerWrapper influencerWrapperVar: lstInfluencerWrapper){
        
            if(influencerWrapperVar.oInfluencerReference.Influencer__c == null)
            {
                //Please add Influencer to proceed
                sErrorMsg = System.Label.AddInfluencer;
                ApexPages.Message myMsg = 
                new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            if(influencerWrapperVar.oInfluencerReference.Influencer__c!=null)
            lstEditInfluencer.add(influencerWrapperVar.oInfluencerReference);
        }        
       
        iCount = 0;
        if(lstEditInfluencer.size() != 0)
        {
            for(Influencer__c c: lstEditInfluencer)
            {           
                if(c.Credit__c==true)
                {
                    iSelected++;
                    if(iSelected > 1)
                    {
                        sErrorMsg = System.Label.InfluencerMarkedCredit; 
                        ApexPages.Message myMsg = 
                        new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
                        ApexPages.addMessage(myMsg);
                        return null;                        
                    }
                    mapSaveInfluencer.put(c.Influencer__c,c.id);
                }
                else
                mapSaveInfluencer.put(c.Influencer__c,c.id);
             }
             
              //Ensure that the user selects atleast 1 influencer as Credit.
             if(iSelected==0)
             {
                 sErrorMsg = System.Label.NoInfluencerMarkedCredit; 
                 ApexPages.Message myMsg = 
                 new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
                 ApexPages.addMessage(myMsg);
                 return null;
             }
        }        
       
        if(mapSaveInfluencer.keyset().size() <> lstEditInfluencer.size() )
        {
            //The Influencer you added already exist, 
            //Please select another influencer.
            sErrorMsg = System.Label.InfluencerAlreadyExist;
            ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
            ApexPages.addMessage(myMsg);
            return null; 
        }
        //Apurva - Added check for INC0067772
        // scenario where all records are deleted
        if(mapSaveInfluencer.size() == 0){ 
            try
            {
                if(lstInfluencerDelete.size()>0)
                    delete lstInfluencerDelete;
                lstInfluencerDelete=new  list<Influencer__c>();
                bIsSaved=true;
            }
            catch(Exception ex)
            {
                //Creating a new Error Log record whenever 
                //any exception is encountered while performing DML Operation
                Utility.insertErrorLogApplication(
                ex.getMessage()+'\n'+ex.getStackTraceString(),
                'Influencer__c',String.valueOf(lstInfluencerDelete),
                'AddEditInfluencerController','saveInfluencerTable',
                'Application',
                UserInfo.getUserId(), String.valueOf(lstInfluencerDelete),null);
            
                return null;
            }
        }
        //Shanu- Oct 2015 Commented for COR0001493
        /*else if(iCount > 100)
        {
            //Total sum of % of Influence should not be greater than 100. 
            //Please adjust % of Influence accordingly for each record.
            sErrorMsg =System.Label.InfluenceGreaterThan100 ;
            sAllErrorMsg += sErrorMsg+'<br />';
            ApexPages.Message myMsg =
            new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
            ApexPages.addMessage(myMsg);
            return null;         
        }
        else if(iCount < 100)
        {
            //Total sum of % of Influence should not be less than 100. 
            //Please adjust % of Influence accordingly for each record.
            sErrorMsg = System.Label.InfluenceLessThan100;
            sAllErrorMsg += sErrorMsg+'<br />';
            ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
            ApexPages.addMessage(myMsg);
            return null; 
        }*/
        else      
        {  
            try
            {
                upsert lstEditInfluencer;
               
                if(lstInfluencerDelete.size()>0)
                    delete lstInfluencerDelete;
                lstInfluencerDelete=new  list<Influencer__c>();
                bIsSaved=true;
                
            }
            catch(Exception ex)
            {
                //Creating a new Error Log record whenever 
                //any exception is encountered while performing DML Operation
                Utility.insertErrorLogApplication(
                ex.getMessage()+'\n'+ex.getStackTraceString(),
                'Influencer__c',String.valueOf(mapSaveInfluencer.keyset()),
                'AddEditInfluencerController','saveInfluencerTable',
                'Application',
                UserInfo.getUserId(), String.valueOf(lstEditInfluencer),null);
            
                return null;
            }
            
        }
        iCount = 0;
        bInfluencerTableEditRecordsRender = false;
        init();
        return null;
    }
    
    /**
    * Method name  : cancelInfluencerTable
    * Description  : Used for cancelling the Influencer Edit Table 
                     and go to the display Influencer List Page
    *                
    * Return Type  : pagereference
    * Parameter    : void
    **/
    //hides/Cancels influencer records Edit and add window.
    public pagereference cancelInfluencerTable()
    {
        /*
        Shanu- Oct 2015- Commented for COR0001493
        iCount = 0;
        if(lstEditInfluencer.size() != 0)
        {
            for(Influencer__c c: lstEditInfluencer)
            {           
                iCount = iCount + integer.valueOf(c.of_Influence__c);
                               
            }
        } 
        if(iCount < 100)
        {
            //Total sum of % of Influence should not be less than 100. 
            //Please adjust % of Influence accordingly for each record.
            sErrorMsg = System.Label.InfluenceLessThan100;
            sAllErrorMsg += sErrorMsg+'<br />';
            ApexPages.Message myMsg = 
            new ApexPages.Message(ApexPages.Severity.ERROR, sErrorMsg );           
            ApexPages.addMessage(myMsg);
            return null; 
        }
        else
        {*/
        bInfluencerTableEditRecordsRender = false;
        return null;
        //}
    }  
    
    /**
    * Method name  : addEditInfluencer
    * Description  : Used in the button which is used 
                     for displaying Influencer List 
                     and to Edit or Add Influencers
    *                
    * Return Type  : pagereference
    * Parameter    : void
    **/    
    //opens up all influencer records 
    //under an Event Location in Editable table form
    public pagereference addEditInfluencer()
    {    
        bInfluencerTableEditRecordsRender = true;
        init();
        bIsAddNewInfluencerClicked = true; 
        lstInfluencerWrapper= getEditAvailableInfluencer();
        return null;
    } 
    
    /**
    * Method name  : addNewInfluencer
    * Description  : Used in the button which provides placeholder 
                     for adding more than one Influencer in the same edit mode
    *                
    * Return Type  : void
    * Parameter    : void
    **/    
    //adds empty row under Editable influncer table 
    //for adding new influencer record
    public void addNewInfluencer()
    {   
        list<InfluencerWrapper> lstInfluencerWrapperVar=
        new list<InfluencerWrapper>();
        Influencer__c oInfluencerNewRecordVar = new Influencer__c(); 
        oInfluencerNewRecordVar.Influencer__c=null;
        oInfluencerNewRecordVar.of_Influence__c = 0;
        oInfluencerNewRecordVar.Campaign__c = parentEventLocationId;
        lstInfluencerWrapper.add(
        new InfluencerWrapper(oInfluencerNewRecordVar ,iIndexValue++));  
        bIsAddNewInfluencerClicked = true; 
    }
    
    /**
    * Method name  : getEditAvailableInfluencer
    * Description  : Used for retrieving the final wrapper list 
                     for display to the User in edit mode
    *                
    * Return Type  : List<InfluencerWrapper>
    * Parameter    : void
    **/
    //shows up all Influencer records for particular Event Location, on VF page 
    //for Editable influncer table.
    public List<InfluencerWrapper> getEditAvailableInfluencer()
    {  
        iEditLstIndex = 0;
      
        lstInfluencerWrapper.addAll(lstInfluencerWrapperFinal);
        oInfluencerNewRecord = new Influencer__c(); 
        oInfluencerNewRecord.of_Influence__c = 0;
        oInfluencerNewRecord.Campaign__c = parentEventLocationId;
        lstInfluencerWrapper.add(
        new influencerWrapper(oInfluencerNewRecord,iIndexValue++));
        bIsAddNewInfluencerClicked = false; 
        return lstInfluencerWrapper;                
    }
   public void refreshPage(){
   
     bIsSaved=false;
     bInfluencerTableEditRecordsRender=false;
     init();
   
   
   } 
    /**
    * Wrapper Class Name  : InfluencerWrapper
    * Description  : Used for capturing the Influencer Record and 
                     the Index Value which is used for saving the records 
                     and display the same to User
    *                
    * Return Type  : 
    * Parameter    : 
    **/
    public class InfluencerWrapper
    {
        public Influencer__c oInfluencerReference{get; set;}
        public Integer iIndex{get;set;}
        
        public InfluencerWrapper(Influencer__c oInfluencerVar, Integer iIndex)
        {
            oInfluencerReference = oInfluencerVar;
            this.iIndex = iIndex;
        }
    } 

}