@isTest
public class CountryLayerConnectionTest {

    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"name": "United States", "alpha2Code": "US", "alpha3Code": "USA", "capital": "Washington, D.C.", "region": "Americas"}]');
            res.setStatusCode(200);

            return res;
        }
    }

    private class MockHttpFailureResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": "Invalid API Key"}');
            res.setStatusCode(401);

            return res;
        }
    }

    @isTest
    static void testGetCountriesFromCountryLayer_Success() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        CountryLayerConnection connection = new CountryLayerConnection();
        HttpResponse response = connection.getCountriesFromCountryLayer();
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(200, response.getStatusCode(), 'Status code should be 200');
        String expectedBody = '[{"name": "United States", "alpha2Code": "US", "alpha3Code": "USA", "capital": "Washington, D.C.", "region": "Americas"}]';
        System.assertEquals(expectedBody, response.getBody(), 'Response body should match the expected JSON');
    }

    @isTest
    static void testGetCountriesFromCountryLayer_Failure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpFailureResponse());
        CountryLayerConnection connection = new CountryLayerConnection();
        HttpResponse response = connection.getCountriesFromCountryLayer();
        System.assertEquals(null, response, 'Response should be null for a failed callout');
    }
}
