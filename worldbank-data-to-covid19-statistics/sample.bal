import ballerinax/worldbank;
import ballerinax/covid19;
import ballerina/http;

type Stats record {|
    string country;
    decimal totalCasesPerMillion;
|};

service / on new http:Listener(8090) {
    isolated resource function get stats/[string shortCountryName]() returns Stats|error {
        covid19:Client covid19Client = check new ();
        covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry(shortCountryName);
        decimal totalCases = statusByCountry.cases;
        worldbank:Client worldBankClient = check new ();
        worldbank:IndicatorInformation[] populationByCountry = check worldBankClient->getPopulationByCountry(shortCountryName);
        int population = (populationByCountry[0].value ?: 0) / 1000000;
        decimal totalCasesPerMillion = totalCases / <decimal>population;
        Stats payload = {country: shortCountryName, totalCasesPerMillion: totalCasesPerMillion};
        return payload;
    }
}
