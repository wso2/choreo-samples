import ballerina/crypto;
import ballerina/http;
import ballerina/log;
import ballerinax/redis;
import ballerinax/worldbank;

// Redis configuration parameters
configurable string host = ?;
configurable string password = ?;

redis:ConnectionConfig redisConfig = {
    host: host,
    password: password
};

final redis:Client conn = check new (redisConfig);

service / on new http:Listener(9090) {
    isolated resource function post get(@http:Payload json payload) returns error? {
        json countryCode = check payload.CountryCode;

        // Hashing input payload
        byte[] payloadByteArray = payload.toString().toBytes();
        byte[] hashValue = crypto:hashSha512(payloadByteArray);

        int existresult = check conn->exists([hashValue.toBase16()]);
        // If key exists returns 1 and not returns 0 
        if existresult == 1 {
            string? getResult = check conn->get(hashValue.toBase16());
            log:printInfo("Fetching from Cache");
            if getResult is string {
                log:printInfo("Population details: " + getResult);
            }
            return;
        } else {
            worldbank:Client worldbankClient = check new ();
            string countryCodeString = check countryCode.ensureType();
            worldbank:IndicatorInformation[] populationDetails = check worldbankClient->getPopulationByCountry(countryCodeString);
            log:printInfo("Fetching from World bank API");
            string populationDetailString = populationDetails.toString();
            _ = check conn->pSetEx(hashValue.toBase16(), populationDetailString, 300000);
            log:printInfo("Population details: " + populationDetailString);
        }
    }
}
