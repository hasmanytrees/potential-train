/*****************************************************************************************
    Name             : JsonHandler
    Description      : This class is used as virtual class for zip code search
    Modification Log : 
---------------------------------------------------------------------------
Developer              Date              Description
---------------------------------------------------------------------------
Subhojit                30/10/2014            Created
Subhojit                29/01/2015            Modified for code re-factoring & optimization
******************************************************************************************/

public with Sharing class JsonHandler{


    public class ZipCodeSearchData{

        public List<ZipCodeDetails> zip_codes{get;set;}

    }


    public class ZipCodeDetails{

        public String zip_code{get;set;}
        public String distance{get;set;}
        public String city{get;set;}
        public String state{get;set;}

    }
}