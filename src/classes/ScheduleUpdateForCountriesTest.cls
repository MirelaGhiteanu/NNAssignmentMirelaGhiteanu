/**
 * Created by Mirela on 8/21/2024.
 */
@IsTest
public with sharing class ScheduleUpdateForCountriesTest {
    @IsTest
    static void testSchedule() {
        String CRON_EXP = '0 0 * * * ? 2024';

        Test.setMock(HttpCalloutMock.class, new CountryLayerMock());
        Test.startTest();
        Id jobId = System.schedule('CountryLayerScheduleTest', CRON_EXP, new ScheduleUpdateForCountries());
        Test.stopTest();

        CronTrigger ct = [
                SELECT Id,
                        CronExpression,
                        TimesTriggered,
                        NextFireTime
                FROM CronTrigger
                WHERE Id = :jobId
        ];

        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
    }
}