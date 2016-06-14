public class createMockResponses
{
     
    public static String createCommitmentMockResponse()
    {
        //String sCommitemtnMockResponse = '{ "CommitmentDetails":[ { "CommitDetail":[ { "CommitmentStatus":"Inactive", "CommitmentId":"7-2725", "StartDate":"1978-08-01", "StopDate":"1989-06-28", "CommitmentType":"Sponsorship", "Supporter":"7-106218", "Beneficiary":"30013" }, { "CommitmentStatus":"Inactive", "CommitmentId":"7-2726", "StartDate":"1989-07-26", "StopDate":"2002-02-27", "CommitmentType":"Sponsorship", "Supporter":"7-106218", "Beneficiary":"214326" }, { "CommitmentStatus":"Inactive", "CommitmentId":"7-1249010", "StartDate":"2002-04-17", "StopDate":"2008-01-08", "CommitmentType":"Sponsorship", "Supporter":"7-106218", "Beneficiary":"758444" }, { "CommitmentStatus":"Active", "CommitmentId":"7-2374942", "StartDate":"2008-01-24", "StopDate":null, "CommitmentType":"Correspondent", "Supporter":"7-106218", "Beneficiary":"1267677" }, { "CommitmentStatus":"Active", "CommitmentId":"7-3431063", "StartDate":"2012-06-11", "StopDate":null, "CommitmentType":"Sponsorship", "Supporter":"7-106218", "Beneficiary":"1267677" } ] } ] }';
        String sCommitemtnMockResponse = '{"CommitmentDetails":[{"CommitDetail":{"CommitmentStatus":"Inactive","CommitmentId":"7-4340049","StartDate":"2015-02-27","StopDate":"2015-09-30","CommitmentType":"Sponsorship","Supporter":"7-3642710","Beneficiary":"2438215"}}]}';
        return sCommitemtnMockResponse;
    }
}