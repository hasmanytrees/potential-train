/*******************************************************************************
    Name             : MultiselectController 
    Description      : This class is the visual force controller for page 
                       MultiSelect page used on CalenderView page               
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit              30/10/2014         Created
Subhojit              29/01/2015         Modified for code re-factoring &
                                         optimization
*******************************************************************************/
public with sharing class MultiselectController {
    // SelectOption lists for public consumption
    public SelectOption[] lstLeftOptions { get; set; }
    public SelectOption[] lstRightOptions { get; set; }
    
    // Parse &-separated values and labels from value and 
    // put them in option
    private void setOptions(SelectOption[] lstOptions, String sValue) {
        if( lstOptions <> NULL ){
            lstOptions.clear();
            String[] lstParts = sValue.split('&');
            for (Integer iIndex=0; iIndex<lstParts.size()/2; iIndex++) {
                lstOptions.add(new SelectOption
                (EncodingUtil.urlDecode(lstParts[iIndex*2], 'UTF-8'), 
                  EncodingUtil.urlDecode(lstParts[(iIndex*2)+1], 'UTF-8')));
            }
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(lstLeftOptions, value);
        }
    }
    
    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(lstRightOptions, value);
        }
    }
}