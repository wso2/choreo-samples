import ballerina/log;
import ballerinax/interzoid.weatherzip;
import ballerinax/slack;

// Template configuration parameters
configurable string zipCode = ?;

// Interzoid configuration parameters
@display {label: "Interzoid API Token", description: "Interzoid API Token"}
configurable weatherzip:ApiKeysConfig apiKeyConfig = ?;

// Slack configuration parameters
@display {label: "Slack Auth Token", description: "Slack Auth Token"}
configurable string authToken = ?;
@display {label: "Slack Channel Name", description: "Slack Channel Name"}
configurable string channelName = ?;

public function main() returns error? {
    weatherzip:Client interzoidClient = check new (apiKeyConfig);
    weatherzip:WeatherData weatherData = check interzoidClient->getweatherzipcode(zipCode);
    string text = string `Weather Data for ${getFieldValue(weatherData.City)}
                    ${"\n"}State : ${getFieldValue(weatherData.State)}
                    ${"\n"}Temperature in Celsius : ${getFieldValue(weatherData.TempC)}
                    ${"\n"}Temperature in Fahrenheit : ${getFieldValue(weatherData.TempF)}
                    ${"\n"}Visibility Miles : ${getFieldValue(weatherData.VisibilityMiles)}
                    ${"\n"}Weather : ${getFieldValue(weatherData.Weather)}
                    ${"\n"}Wind Direction : ${getFieldValue(weatherData.WindDir)}
                    ${"\n"}Wind Speed (in MpH) : ${getFieldValue(weatherData.WindMPH)}
                    ${"\n"}Air Quality : ${getFieldValue(weatherData.AirQuality)}
                    ${"\n"}Air Quality Index : ${getFieldValue(weatherData.AirQualityIndex)}
                    ${"\n"}Air Quality Code : ${getFieldValue(weatherData.AirQualityCode)}
                    ${"\n"}Sunrise : ${getFieldValue(weatherData.Sunrise)}
                    ${"\n"}Sunset : ${getFieldValue(weatherData.Sunset)}`;

    slack:Client slackClient = check new ({auth: {token: authToken}});
    string response = check slackClient->postMessage({
        channelName,
        text
    });
    log:printInfo("Message sent successfully", threadId = response);
}

isolated function getFieldValue(string? fieldData) returns string => fieldData ?: "Not available";
