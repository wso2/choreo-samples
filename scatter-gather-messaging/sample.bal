import ballerina/http;
import ballerinax/openweathermap;

//Configurable variable for Open weather API key
configurable string apiKey = ?;

//Record type for user response
type TemperatureValues record {
    map<decimal?|string> temperatureValues;
};

# A service representing a network-accessible API
# bound to port `8090`.
service / on new http:Listener(8090) {

    # A resource for getting temperature for a list of locations
    # + locations - the input string array locations 
    # + return - json with temperature values or error
    resource function get temperature(string[] locations) returns TemperatureValues|error {

        //Open weather API client initialization
        openweathermap:Client openWeatherMapEndpoint = check new ({appid: apiKey});
        map<future<decimal?|error>> responseMap = {};
        map<decimal?|string> temperatureValues = {};

        //Sends a request for each location in parallel
        foreach string location in locations {
            responseMap[location] = start sendRequest(openWeatherMapEndpoint, location);
        }

        //Wait and gather the responses of all sent requests
        foreach string responseKey in responseMap.keys() {
            decimal?|error temperature = wait responseMap.get(responseKey);
            if temperature is error {
                //Get error message from the response
                temperatureValues[responseKey] = temperature.message();
            } else {
                //Get the temperature value from the response
                temperatureValues[responseKey] = temperature;
            }
        }
        return {temperatureValues: temperatureValues};
    }
}

# Sends request to Open Weather API.
#
# + openWeatherMapClient - Open Weather API  
# + location - Locations
# + return - Temperature value or else an error 
function sendRequest(openweathermap:Client openWeatherMapClient, string location) returns decimal?|error {
    openweathermap:CurrentWeatherData openWeatherResponse = check openWeatherMapClient->getCurretWeatherData(location);
    return openWeatherResponse.main?.temp;
}
