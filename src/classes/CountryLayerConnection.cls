/**
 * Created by Mirela on 8/17/2024.
 */

public with sharing class CountryLayerConnection {

    private String endpoint = CountryLayerAPI__c.getOrgDefaults().Endpoint__c;
    private String key = CountryLayerAPI__c.getOrgDefaults().Key__c;

    public HttpResponse getCountriesFromCountryLayer() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.endpoint + '/v2/all?access_key=' + this.key);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response;
        } else {
            //System debug used only for assignment purposes,should be replaced with logError framework
            System.debug('Failed to retrieve countries: ' + response.getBody());
            return null;
        }
    }
}