/******************************************************************************
Name             : SBCCommunicationDetailsList
Description      : This is a Wrapper Class used for JSON serializing and deserializing
                and preserving the JSON format to be send to Salesforce CI and ISL                
Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               27/08/2015            Created
Sumeet                 23/09/2015            Modified for code re-factoring 
                                            & optimization
******************************************************************************/

public class SBCCommunicationDetailsList
{

    /**
    * Class name  : SBCCommunicationDetails 
    * Description  :Class includes variables used as JSON tokens
                    for passing and  receiving values from various systems
    **/  
    
    public class SBCCommunicationDetails 
    {
        public Boolean IsFinalLetterArchived;
        public Boolean IsDatePhysicalReceived;
        public Boolean IsOriginalLetterArchived;
        public String Beneficiary_Name;
        public String Beneficiary_GlobalId;
        public String Beneficiary_LocalId;
        public String Beneficiary_CompassId;
        public String Direction;
        //public String GlobalPartner_Id;
        public String GlobalPartner_GlobalPartnerId;
        public Boolean IsFinalLetter;
        public String Font;
        public Integer FontSize;
        public Boolean ItemNotScannedEligible;
        public Boolean ItemNotScannedNotEligible;
        public String OriginalLanguage;
        public String OriginalText;
        //public String Status;
        public String SBCGlobalStatus;
        public boolean IsMarkedForRework;
        public String Supporter_CompassConstituentId;
        public String Supporter_GlobalId;
        //public List<String> Type;
        public List<String> SBCTypes;
        public boolean IsReadBySupporter;
        public String GlobalPartnerSBCId;
        public String CompassionSBCId;
        public String SourceSystem;
        public String DatePhysicalReceived;
        //public String TransactionId;
        public String Internal_Perceptive_TransactionId;
        public String TranslatedText;
        public String TranslationLanguage;
        public String OriginalLetterURL;
        public String FinalLetterURL;
        public String Exception_Insert ;
        public String EnglishTranslatedText;
        public String Supporter_CommunicationDeliveryPreference;
        public Boolean Supporter_MandatoryReviewRequired;
        public String Template;
        public String SponsorStationaryTemplate;
        public String PrintType;
        public String ICP_Id;
       
        public Integer NumberOfPages;
        public String Beneficiary_Gender;
        public String Beneficiary_Age;
        public String ReasonForRework;
        public Boolean GlobalPartner_OptInForLanguageTranslation;
        public String Supporter_Gender;
        public String ReworkComments;
        public String RelationshipType;
        public String TranslatedBy;        
        public String Internal_Supporter_PersonalEmail;
        public String Internal_Supporter_MailingStreet1;
        public String Internal_Supporter_InCareOfMailingAddress;
        public String Internal_Supporter_MailingCity;
        public String Internal_Supporter_MailingCountryDivision;
        public String Internal_Supporter_MailingPostalCode;
        public String Internal_Supporter_MailingCountry;
        public String Supporter_PreferredName;
        public String Internal_Supporter_CommunicationMethod;
        //Apurva- Added Batch Id and Sequence Id
        public String Internal_Perceptive_SequenceNumber;
        public String Internal_Perceptive_BatchId;
    }
    
    /**
    * Class name  : SBCCommunicationUpdateDetailsUpdateFromCI
    * Description  :Class includes variables used as JSON tokens
                    for invocations specifically from Salesforce CI
    **/ 
    
    public class SBCCommunicationUpdateDetailsUpdateFromCI 
    {
        public String Beneficiary_GlobalId;
        public String Beneficiary_LocalId;
        public String Direction;
        public String FinalLetterURL;
        //public String Status;
        public String SBCGlobalStatus;
        public String Supporter_CompassConstituentId;
        public String Supporter_GlobalId;
        //public List<String> Type;
        public List<String> SBCTypes;
        public boolean IsReadBySupporter;
        public String GlobalPartnerSBCId;
        public String CompassionSBCId;
        public String SourceSystem;
        //public String TransactionId;
        public String Internal_Perceptive_TransactionId;
        public String ReworkComments;
        public String ReasonForRework;
        public String RelationshipType; 
        //Apurva- Added Batch Id and Sequence Id
        public String Internal_Perceptive_SequenceNumber;
        public String Internal_Perceptive_BatchId;
        
        
        public SBCCommunicationUpdateDetailsUpdateFromCI (SBCCommunicationDetails  oSBCWrpVar)
        {
            Beneficiary_GlobalId = oSBCWrpVar.Beneficiary_GlobalId ;
            Beneficiary_LocalId = oSBCWrpVar.Beneficiary_LocalId ;
            Direction = oSBCWrpVar.Direction ;
            FinalLetterURL = oSBCWrpVar.FinalLetterURL ;
            //Status = oSBCWrpVar.Status ;
            SBCGlobalStatus = oSBCWrpVar.SBCGlobalStatus ;  
            Supporter_CompassConstituentId = oSBCWrpVar.Supporter_CompassConstituentId ;
            Supporter_GlobalId = oSBCWrpVar.Supporter_GlobalId ;
            SBCTypes = oSBCWrpVar.SBCTypes;
            IsReadBySupporter = oSBCWrpVar.IsReadBySupporter ;
            GlobalPartnerSBCId = oSBCWrpVar.GlobalPartnerSBCId ;
            CompassionSBCId = oSBCWrpVar.CompassionSBCId ;
            SourceSystem = oSBCWrpVar.SourceSystem ;
            Internal_Perceptive_TransactionId = oSBCWrpVar.Internal_Perceptive_TransactionId ;
            ReworkComments = oSBCWrpVar.ReworkComments ;
            ReasonForRework = oSBCWrpVar.ReasonForRework ;
            RelationshipType = oSBCWrpVar.RelationshipType ;
            //Apurva- Added Batch Id and Sequence Id
            Internal_Perceptive_SequenceNumber = oSBCWrpVar.Internal_Perceptive_SequenceNumber ;
            Internal_Perceptive_BatchId = oSBCWrpVar.Internal_Perceptive_BatchId;
        }       
        
    }
    
    
    /**
    * Class name  : SBCCommunicationDetailsISL
    * Description  :Class includes variables used as JSON tokens
                    for invocations specifically from ISL
    **/
    
    public class SBCCommunicationDetailsISL
    {
        public String CommunicationDirection;
        public Boolean IsFinalLetter;
        public String Font;
        public String ReadyForISLDate;
        public String CreatedDate;
        public Integer FontSize;
        public Boolean ItemNotScannedEligible;
        public Boolean ItemNotScannedNotEligible;

        public SBCCommunicationDetailsISL(SBCCommunicationDetails  oSBCWrpVar)
        {
            IsFinalLetter=oSBCWrpVar.IsFinalLetter;
            Font=oSBCWrpVar.Font;
            FontSize=oSBCWrpVar.FontSize;
            ItemNotScannedEligible=oSBCWrpVar.ItemNotScannedEligible;
            ItemNotScannedNotEligible=oSBCWrpVar.ItemNotScannedNotEligible;
        }

    }
    
    /**
    * Class name  : SBCCommunicationDetailsFin
    * Description  :Class includes final JSON in list format
    **/
    
    public class SBCCommunicationDetailsFin
    {
        public List<SBCCommunicationDetails> SBCCommunicationDetails;

        public  SBCCommunicationDetailsFin(List<SBCCommunicationDetails> SBCCommunicationDetails)
        {
            this.SBCCommunicationDetails=SBCCommunicationDetails;
        }
    }
    
    /**
    * Class name  : SBCCommunicationDetailsUpdateCI
    * Description  :Class includes final JSON for update calls
                    from Salesforce CI
    **/
    
    public class SBCCommunicationDetailsUpdateCI
    {     
        public List<SBCCommunicationUpdateDetailsUpdateFromCI > CommunicationUpdates;

        public  SBCCommunicationDetailsUpdateCI(List<SBCCommunicationUpdateDetailsUpdateFromCI > SBCCommunicationDetails)
        {
            this.CommunicationUpdates=SBCCommunicationDetails;
        }
    }
    
    /**
    * Class name  : SBCCommunicationDetails_ISL
    * Description  :Class includes final JSON in list format for ISL
    **/
    
    public class SBCCommunicationDetails_ISL
    {
        public List<SBCCommunicationDetailsISL> SBCCommunicationDetailsISL;        

    }
}