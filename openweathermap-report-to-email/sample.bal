import ballerina/log;
import ballerinax/openweathermap;
import wso2/choreo.sendemail as email;

@display {label: "OpenWeatherMap AppId"}
configurable string appId = ?;
@display {label: "City Name"}
configurable string cityName = ?;
@display {label: "Recipient's Email"}
configurable string recipientAddress = ?;

public function main() returns error? {
    openweathermap:Client openWeatherMapClient = check new openweathermap:Client({appid: appId});
    openweathermap:CurrentWeatherData result = check openWeatherMapClient->getCurretWeatherData(cityName);

    openweathermap:Main? mainData = result?.main;
    string weatherInfo = string `Current Weather data : ${"\n\n"}Coordinates : ${"\n"}Longtitudes = ${getFieldValue(
        result?.coord?.lon)}, Latitudes = ${getFieldValue(result?.coord?.lat)}${"\n"}Weather : ${"\n"}Temperature = ${
        getFieldValue(mainData?.temp)}${"\n"}Pressure = ${getFieldValue(mainData?.pressure)}${"\n"}Humidity = ${
        getFieldValue(mainData?.humidity)}${"\n"}Minimum Temperature = ${getFieldValue(mainData?.temp_min)}${"\n"}Maximum Temperature = ${
        getFieldValue(mainData?.temp_max)}${"\n"}Sea Level = ${getFieldValue(mainData?.sea_level)}${"\n"}Ground Level = ${
        getFieldValue(mainData?.grnd_level)}${"\n"}Wind Speed = ${getFieldValue(result?.wind?.speed)}`;

    email:Client emailClient = check new ();
    string sendEmailResponse = check emailClient->sendEmail(recipientAddress, "Weather Report", weatherInfo);
    log:printInfo(string `Email sent successfully! ${"\n"} Message Id: ${sendEmailResponse}`);
}

isolated function getFieldValue(int|decimal? fieldData) returns int|decimal|string {
    return fieldData ?: "Not available";
}
