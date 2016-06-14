/*******************************************************************************
    Name             : ReportFinderUtil 
    Description      : This class is used to find the Report ID based on the Report Name
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit               1/9/2015          Created
Sumeet                 4/28/2015        Modified for code re-factoring & 
                                                         optimization
*******************************************************************************/
public with sharing class ReportFinderUtil {

  public ReportFinderUtil(){}
  
  public String findReportId(String reportName){
    
    Sobject myReport;
    try
    {
        myReport = [select Id,Name From Report Where Name=:reportName];
    }
    catch(Exception ex)
    {
        //Error Occured.
    }
    return myReport.Id;
    
  }
    
}