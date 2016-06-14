/****************************************************************************
    Name             : CampaignSlotDashBoardController
    Description      : Page Controller for CampaignSlotDashBoard page           
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014         Created
Subhojit              29/01/2015         Modified for code re-factoring & 
                                         optimization
****************************************************************************/
public with sharing class CampaignSlotDashBoardController
{  
    public List<CampaignWrapper> lstCampaignWrapper{get;set;}
 
    public boolean bShow{get;set;}  
    // This variable shows table or in absent of Data,it shows error Message
    public CampaignSlotDashBoardController(){
        bShow=false;
        List<PieWedgeData> lstPieData=getPieData();
        
        
    }
    /**
    * Method name  : getPieData
    * Description  : This method is a getter method which creates table 
    *                and shows data on page
    * Return Type  : void
    * Parameter    : void
    **/ 
    public List<PieWedgeData> getPieData() 
    {  
        List<PieWedgeData> lstData = new List<PieWedgeData>();
        
        
        Recordtype recordtype=[select Id from Recordtype where 
        DeveloperName='Event_Location' and sObjectType='Campaign'];
        
        List<Campaign> lstEventLoaction=new List<Campaign>();
        Date dtTargerThresold=Date.today()-14;
        lstEventLoaction=[select Id,Status,StartDate,EndDate,OwnerId,
        Slots_Coverage__c, Name from Campaign where
        CreatedDate=THIS_FISCAL_YEAR and 
        recordtypeId=:recordtype.Id and ownerId=:(UserInfo.getUserId()) and 
        StartDate=NEXT_N_DAYS:14 AND Total_Number_Of_Volunteer_Slots__c > 0];
        
        Integer iPerecntageMorethanEighty=0;
        Integer iPerecntageLessthanEighty=0;
        lstCampaignWrapper=new List<campaignWrapper>();
        for(Campaign oCampaignVar: lstEventLoaction){
            //Checking for Event with Slot Coverage more than or less than 80
            if(oCampaignVar.Slots_Coverage__c <80){
                iPerecntageLessthanEighty++;
                lstCampaignWrapper.add(new campaignWrapper(oCampaignVar,false));
                bShow=true;
               
            }
            else{
                iPerecntageMorethanEighty++;
                
                
                lstCampaignWrapper.add(new campaignWrapper(oCampaignVar,true));
                bShow=true;
            }
            
        }
        
        
        lstData.add(new PieWedgeData('0-80%',iPerecntageLessthanEighty )); 
        lstData.add(new PieWedgeData('80-100%',iPerecntageLessthanEighty)); 
        if(bShow==false){
        //No Event Location found withing next 14 Days.
            ApexPages.Message myMsg2 = 
            new ApexPages.Message(ApexPages.Severity.INFO,
            System.Label.NoCampaignFoundMessage);
            ApexPages.addMessage(myMsg2);
            
            
        }     
       
        return lstData;  
    }  
    
    // Wrapper class  for Pie Chart
    public class PieWedgeData 
    {  
        public String sName { get; set; }  
        public Decimal dcData { get; set; }  
        
        public PieWedgeData(String sName, Decimal dcData) 
        {  
            this.sName = sName;  
            this.dcData = dcData;  
        }  
    } 
    // Wrapper class  for Table Chart
    public class campaignWrapper{

        public Campaign oCampaign{get;set;}
        public boolean bIsExcceded{get;set;}
        
        public campaignWrapper(Campaign oCampaign,boolean bIsExcceded){
            
            this.oCampaign=oCampaign;
            this.bIsExcceded=bIsExcceded;
            
        }


    }
    
    
}