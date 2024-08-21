@isTest
public class LeadTriggerHelperTest {

    @TestSetup
    static void setupTestData() {
        Country__c usa = new Country__c(Name = 'United States', Alpha2Code__c = 'US', Alpha3Code__c = 'USA', Capital_city__c = 'Washington, D.C.', Region__c = 'Americas');
        Country__c canada = new Country__c(Name = 'Canada', Alpha2Code__c = 'CA', Alpha3Code__c = 'CAN', Capital_city__c = 'Ottawa', Region__c = 'Americas');
        Country__c germany = new Country__c(Name = 'Germany', Alpha2Code__c = 'DE', Alpha3Code__c = 'DEU', Capital_city__c = 'Berlin', Region__c = 'Europe');
        insert new List<Country__c> { usa, canada, germany };

        Lead lead1 = new Lead(LastName = 'Smith', Company = 'Company A', Country = 'United States');
        Lead lead2 = new Lead(LastName = 'Johnson', Company = 'Company B', Country = 'Canada');
        Lead lead3 = new Lead(LastName = 'Muller', Company = 'Company C', Country = 'Germany');
        insert new List<Lead> { lead1, lead2, lead3 };
    }

    @isTest
    static void testSetLeadAddressInfo_CountryChanged() {
        List<Lead> newLeads = [SELECT Id, Country FROM Lead WHERE LastName IN ('Smith', 'Johnson')];
        Map<Id, Lead> oldLeadsMap = new Map<Id, Lead>();

        oldLeadsMap.put(newLeads[0].Id, new Lead(Id = newLeads[0].Id, Country = 'Canada')); // Lead1's country changed

        Test.startTest();
        LeadTriggerHelper leadHelper = new LeadTriggerHelper();
        leadHelper.setLeadAddressInfo(newLeads, oldLeadsMap);
        Test.stopTest();

        Lead updatedLead1 = [SELECT CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE Id = :newLeads[0].Id];
        Lead updatedLead2 = [SELECT CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE Id = :newLeads[1].Id];

        System.assertEquals('US', updatedLead1.CountryAlpha2Code__c, 'Lead1 Country Alpha2Code__c should be updated to US');
        System.assertEquals('USA', updatedLead1.CountryAlpha3Code__c, 'Lead1 Country Alpha3Code__c should be updated to USA');
        System.assertEquals('Washington, D.C.', updatedLead1.CapitalCity__c, 'Lead1 CapitalCity__c should be updated to Washington, D.C.');
        System.assertEquals('Americas', updatedLead1.Region__c, 'Lead1 Region__c should be updated to Americas');

        System.assertEquals('CA', updatedLead2.CountryAlpha2Code__c, 'Lead2 Country Alpha2Code__c should remain CA');
        System.assertEquals('CAN', updatedLead2.CountryAlpha3Code__c, 'Lead2 Country Alpha3Code__c should remain CAN');
        System.assertEquals('Ottawa', updatedLead2.CapitalCity__c, 'Lead2 CapitalCity__c should remain Ottawa');
        System.assertEquals('Americas', updatedLead2.Region__c, 'Lead2 Region__c should remain Americas');
    }

    @isTest
    static void testSetLeadAddressInfo_NoChange() {
        List<Lead> newLeads = [SELECT Id, Country, CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE LastName = 'Muller'];
        Lead leadToClearFields = newLeads[0];
        leadToClearFields.CountryAlpha2Code__c = null;
        leadToClearFields.CountryAlpha3Code__c = null;
        leadToClearFields.CapitalCity__c = null;
        leadToClearFields.Region__c = null;
        update leadToClearFields;

        Map<Id, Lead> oldLeadsMap = new Map<Id, Lead>();

        oldLeadsMap.put(newLeads[0].Id, new Lead(Id = newLeads[0].Id, Country = 'Germany'));

        Test.startTest();
        LeadTriggerHelper leadHelper = new LeadTriggerHelper();
        leadHelper.setLeadAddressInfo(newLeads, oldLeadsMap);
        Test.stopTest();

        Lead updatedLead = [SELECT CountryAlpha2Code__c, CountryAlpha3Code__c, CapitalCity__c, Region__c FROM Lead WHERE Id = :newLeads[0].Id];

        System.assertEquals(null, updatedLead.CountryAlpha2Code__c, 'Country Alpha2Code__c should not be set');
        System.assertEquals(null, updatedLead.CountryAlpha3Code__c, 'Country Alpha3Code__c should not be set');
        System.assertEquals(null, updatedLead.CapitalCity__c, 'CapitalCity__c should not be set');
        System.assertEquals(null, updatedLead.Region__c, 'Region__c should not be set');
    }
}
