import ballerina/http;
import wso2/choreo.sendemail;
import ballerina/io;

const string ENDPOINT_URL = "https://api.openweathermap.org/data/2.5";
const int StepCount = 7; // number of steps to be fetch from the API
configurable string apiKey = ?;
configurable float latitude = ?;
configurable float longitude = ?;
configurable string email = ?;
const emailSubject = "Next 24H Weather Forecast";

// Create http client
http:Client httpclient = check new (ENDPOINT_URL);
// Create a new email client
sendemail:Client emailClient = check new ();

public function main() returns error? {

    // Get the weather forecast for the next 24H
    http:Response response = check httpclient->/forecast(lat = latitude, lon = longitude, cnt = StepCount, appid = apiKey);
    io:println("Successfully fetched the weather forecast data.");

    // Get the json payload from the response
    json jsonResponse = check response.getJsonPayload();

    // Convert the json payload to a WeatherRecordList
    WeatherRecordList jsonList = check jsonResponse.cloneWithType();
    io:println("Converted the json payload to a WeatherRecordList.");

    // Send the email
    string _ = check emailClient->sendEmail(email, emailSubject, generateWeatherTable(jsonList));
    io:println("Successfully sent the email.");
}
