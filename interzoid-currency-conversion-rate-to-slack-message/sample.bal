import ballerina/log;
import ballerinax/interzoid.convertcurrency as convertcurrency;
import ballerinax/slack;

// Template configuration parameters
@display {label: "From Currency", description: "From Currency"}
configurable string fromCurrency = ?;
@display {label: "To Currency", description: "To Currency"}
configurable string toCurrency = ?;

// Interzoid configuration parameters
@display {label: "Interzoid API Token", description: "Interzoid API Token"}
configurable convertcurrency:ApiKeysConfig apiKeyConfig = ?;

// Slack configuration parameters
@display {label: "Slack Auth Token", description: "Slack Auth Token"}
configurable string authToken = ?;
@display {label: "Slack Channel Name", description: "Slack Channel Name"}
configurable string channelName = ?;

public function main() returns error? {
    convertcurrency:Client interzoidClient = check new (apiKeyConfig);
    convertcurrency:CurrencyConversionInfo convertedCurrency = check interzoidClient->convertCurrency(fromCurrency, toCurrency, "1");
    string text = string `1 ${fromCurrency} = ${convertedCurrency.Converted ?: " "} ${toCurrency}`;

    slack:Client slackClient = check new ({auth: {token: authToken}});
    string response = check slackClient->postMessage({
        channelName,
        text
    });
    log:printInfo(string `Message sent successfully. Message ID : " ${response}`);
}
