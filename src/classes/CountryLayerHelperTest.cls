@isTest
public class CountryLayerHelperTest {

    private class MockHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();

            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"name": "United States", "alpha2Code": "US", "alpha3Code": "USA", "capital": "Washington, D.C.", "region": "Americas", "callingCodes": ["123456789"]},'
                    + '{"name": "Canada", "alpha2Code": "CA", "alpha3Code": "CAN", "capital": "Ottawa", "region": "Americas", "callingCodes": ["987654321"]}]');
            res.setStatusCode(200);

            return res;
        }
    }

    private class MockHttpFailureResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": "Invalid API Key"}');
            res.setStatusCode(401);

            return res;
        }
    }

    @isTest
    static void testUpsertCountriesFromCountryLayer_Success() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        CountryLayerHelper.upsertCountriesFromCountryLayer();
        Test.stopTest();

        List<Country__c> countries = [SELECT Name, Alpha2Code__c, Alpha3Code__c, Capital_city__c, Region__c, CallingCode__c FROM Country__c];
        System.assertEquals(2, countries.size(), 'There should be two countries upserted');

        Country__c usa = countries[0];
        System.assertEquals('United States', usa.Name);
        System.assertEquals('US', usa.Alpha2Code__c);
        System.assertEquals('USA', usa.Alpha3Code__c);
        System.assertEquals('Washington, D.C.', usa.Capital_city__c);
        System.assertEquals('Americas', usa.Region__c);
        System.assertEquals('123456789', usa.CallingCode__c);

        Country__c canada = countries[1];
        System.assertEquals('Canada', canada.Name);
        System.assertEquals('CA', canada.Alpha2Code__c);
        System.assertEquals('CAN', canada.Alpha3Code__c);
        System.assertEquals('Ottawa', canada.Capital_city__c);
        System.assertEquals('Americas', canada.Region__c);
        System.assertEquals('987654321', canada.CallingCode__c);
    }

    @isTest
    static void testUpsertCountriesFromCountryLayer_Failure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpFailureResponse());

        Test.startTest();
        CountryLayerHelper.upsertCountriesFromCountryLayer();
        Test.stopTest();

        List<Country__c> countries = [SELECT Name FROM Country__c];
        System.assertEquals(0, countries.size(), 'No countries should be upserted due to failed callout');
    }
}
