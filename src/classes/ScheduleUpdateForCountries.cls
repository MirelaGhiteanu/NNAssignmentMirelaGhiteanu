/**
 * Created by Mirela on 8/18/2024.
 */
public class ScheduleUpdateForCountries implements Schedulable {
    public void execute(SchedulableContext context) {
        CountryLayerHelper.upsertCountriesFromCountryLayer();
    }
}