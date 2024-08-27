/**
 * Created by Mirela on 8/21/2024.
 */

public with sharing class CountryLayerHelper {

    @Future(Callout=true)
    public static void upsertCountriesFromCountryLayer() {
        CountryLayerConnection countryLayerConnection = new CountryLayerConnection();
        HttpResponse response = countryLayerConnection.getCountriesFromCountryLayer();
        if(response != null) {
            Object deserializedResponse = JSON.deserializeUntyped(response.getBody());
            List<Country__c> countriesToUpsert = parseCountryData(deserializedResponse);
            List<Database.UpsertResult> upsertResults = Database.upsert(countriesToUpsert, Country__c.fields.CallingCode__c, false);

            for (Database.UpsertResult upsertResult : upsertResults) {
                if (!upsertResult.isSuccess()) {
                    //System debug used only for assignment purposes,should be replaced with logError framework
                    System.debug('Upsert Error: ' + upsertResult.getErrors().toString());
                }
            }
        }
    }

    private static List<Country__c> parseCountryData(Object response) {
        List<Object> countries = (List<Object>) response;
        List<Country__c> countryList = new List<Country__c>();

        for (Object countryObj : countries) {
            Map<String, Object> countryMap = (Map<String, Object>) countryObj;
            List<Object> callingCodesList = (List<Object>) countryMap.get('callingCodes');
            Country__c country = new Country__c(
                    Name = (String) countryMap.get('name'),
                    Alpha2Code__c = (String) countryMap.get('alpha2Code'),
                    Alpha3Code__c = (String) countryMap.get('alpha3Code'),
                    Capital_city__c = (String) countryMap.get('capital'),
                    Region__c = (String) countryMap.get('region'),
                    CallingCode__c = (String)callingCodesList[0]
            );
            countryList.add(country);
        }
        return countryList;
    }

}