@IsTest
public class ScheduleUpdateForCountriesTest {

    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"name": "United States", "alpha2Code": "US", "alpha3Code": "USA", "capital": "Washington, D.C.", "region": "Americas", "callingCodes": ["1"]}]');
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testExecuteMethod() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        String CRON_EXP = '0 0 * * * ? 2024';

        Test.startTest();
        Id jobId = System.schedule('ScheduleUpdateForCountriesTest', CRON_EXP, new ScheduleUpdateForCountries());
        Test.stopTest();

        CronTrigger ct = [
                SELECT Id,
                        CronExpression
                FROM CronTrigger
                WHERE Id = :jobId
        ];
        System.assertEquals(CRON_EXP, ct.CronExpression);
    }
}
