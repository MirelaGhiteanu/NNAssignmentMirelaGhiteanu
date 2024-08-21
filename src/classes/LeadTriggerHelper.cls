/**
 * Created by Mirela on 8/21/2024.
 */

public with sharing class LeadTriggerHelper {
    public LeadTriggerHelper() {
    }

    public void setLeadAddressInfo(List<Lead> newList, Map<Id, SObject> oldMap){
        Set<String> leadCountries = new Set<String>();
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : newList) {
            String oldCountry = oldMap != null && oldMap.containsKey(lead.Id) ? ((Lead)oldMap.get(lead.Id)).Country : null;
            if (oldCountry == null || lead.Country != oldCountry) {
                leadsToUpdate.add(lead);
                leadCountries.add(lead.Country);
            }
        }
        if(!leadsToUpdate.isEmpty()) {
            Map<String, Country__c> countryMap = fetchCountryInformation(leadCountries);
            updateLeadCountryInfo(leadsToUpdate, countryMap);
        }
    }

    public static Map<String, Country__c> fetchCountryInformation(Set<String> leadCountries) {
        Map<String, Country__c> countryMap = new Map<String, Country__c>();

        if (!leadCountries.isEmpty()) {
            for (Country__c country : [
                    SELECT Name, Alpha2Code__c, Alpha3Code__c, Capital_city__c, Region__c, RegionalBlocs__c
                    FROM Country__c
                    WHERE Name IN :leadCountries
            ]) {
                countryMap.put(country.Name, country);
            }
        }
        return countryMap;
    }

    public static void updateLeadCountryInfo(List<Lead> newLeads, Map<String, Country__c> countryMap) {
        for (Lead lead : newLeads) {
            if (lead.Country != null && countryMap.containsKey(lead.Country)) {
                Country__c countryInfo = countryMap.get(lead.Country);

                lead.CountryAlpha2Code__c = countryInfo.Alpha2Code__c;
                lead.CountryAlpha3Code__c = countryInfo.Alpha3Code__c;
                lead.CapitalCity__c = countryInfo.Capital_city__c;
                lead.Region__c = countryInfo.Region__c;
            }
        }
    }
}