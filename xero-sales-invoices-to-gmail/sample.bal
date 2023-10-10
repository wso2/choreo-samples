import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerinax/googleapis.gmail;
import ballerinax/xero.accounts as xero;

type GmailAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

type JsonMap map<json>;

// Xero configuration parameters
configurable http:BearerTokenConfig xeroAuthConfig = ?;
configurable string xeroTenantId = ?;

// Gmail configuration parameters
configurable GmailAuth2Config gmailOAuthConfig = ?;
configurable string recipient = ?;
configurable string sender = ?;

public function main() returns error? {
    xero:Client xeroClient = check new ({auth: xeroAuthConfig});

    gmail:Client gmailClient = check new ({
        auth: {
            ...gmailOAuthConfig
        }
    });

    // Get the modified date for the invoices - in this case the modified time is week prior to current time
    string modifiedSince = time:utcToString(time:utcAddSeconds(time:utcNow(), -604800.0));
    // Get the invoice list created/updated since last week
    xero:Invoices invoicesList = check xeroClient->getInvoices(xeroTenantId, modifiedSince);
    xero:Invoice[] invoices = invoicesList.Invoices ?: [];
    if invoices.length() > 0 {
        xml htmlContent = convertRecordArrayToHTML(invoices);
        gmail:Message sendMessageResponse = check gmailClient->sendMessage({
            recipient,
            sender,
            subject: "[Xero] Invoices for the last week",
            messageBody: htmlContent.toString(),
            contentType: "text/html"
        });
        log:printInfo("Mail sent successfully! Message ID: ", messageId = sendMessageResponse?.id.toString());
    } else {
        log:printInfo("No sales invoives for this week");
    }
}

function convertRecordArrayToHTML(xero:Invoice[] invoices) returns xml {
    xml header = xml `<tr>${from [string, anydata] ['key, _] in invoices[0].entries() select xml`<th>${'key}</th>`}</tr>`;
    xml data  = from xero:Invoice invoice in invoices select xml`<tr>${from [string, anydata] [_, value] in invoice.entries() select xml`<td>${value.toString()}</td>`}</tr>`;
    return xml `<table>${header}${data}</table>`;
}
