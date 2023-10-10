import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerinax/microsoft.onedrive;
import ballerinax/microsoft.outlook.mail;
import ballerinax/shopify.admin as shopify;

type MicrosoftOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl;
};

// Shopify configuration parameters
configurable string shopifyServiceUrl = ?;
configurable shopify:ApiKeysConfig shopifyAuthConfig = ?;

// Microsoft Outlook configuration parameters
configurable MicrosoftOAuth2Config microsoftOutlookOAuthConfig = ?;

// Microsoft Onedrive configuration parameters
configurable MicrosoftOAuth2Config microsoftOneDriveOAuthConfig = ?;
configurable string flyerFilePath = ?;

public function main() returns error? {
    shopify:Client shopifyClient = check new (shopifyAuthConfig, shopifyServiceUrl);

    mail:Client outlookClient = check new ({
        auth: {
            clientId: microsoftOutlookOAuthConfig.clientId,
            clientSecret: microsoftOutlookOAuthConfig.clientSecret,
            refreshToken: microsoftOutlookOAuthConfig.refreshToken,
            refreshUrl: microsoftOutlookOAuthConfig.refreshUrl
        }
    });

    onedrive:Client onedriveClient = check new ({
        auth: {
            clientId: microsoftOneDriveOAuthConfig.clientId,
            clientSecret: microsoftOneDriveOAuthConfig.clientSecret,
            refreshToken: microsoftOneDriveOAuthConfig.refreshToken,
            refreshUrl: microsoftOneDriveOAuthConfig.refreshUrl
        }
    });

    string dateOriginTime = time:utcToString(time:utcAddSeconds(time:utcNow(), -300.0));
    string currentTime = time:utcToString(time:utcNow());

    shopify:CustomerList customerList = check shopifyClient->getCustomers(createdAtMin = dateOriginTime, createdAtMax = currentTime);
    shopify:Customer[] customers = customerList?.customers ?: [];
    mail:Recipient[] recepients = [];
    foreach shopify:Customer customer in customers {
        recepients.push({
            emailAddress: {
                address: customer?.email ?: "",
                name: customer?.first_name ?: ""
            }
        });
    }

    onedrive:File fileContents = check onedriveClient->downloadFileByPath(flyerFilePath);
    byte[] byteContent = fileContents.content ?: [];

    if customers.length() > 0 {
        mail:FileAttachment attachment = {
            contentBytes: byteContent.toBase64(),
            contentType: "image/png",
            name: "flyer.png"
        };
        mail:MessageContent messageContent = {
            message: {
                subject: "Welcome to Our Store",
                importance: "normal",
                body: {
                    "contentType": "HTML",
                    "content": string `<p> Hi There, <br/>
                        <h2> Welcome to Our Store </h2> <br/>
                        <strong> What happens next? <strong> <br/>
                        Keep an eye on your inbox as we’ll be sending you the best tips for [product/service]. <br/>
                        Want to get more out of Our Store? <br/> visit our store at Shopify </p>` 
                },
                toRecipients: recepients,
                attachments: [attachment]
            },
            saveToSentItems: true
        };
        http:Response response = check outlookClient->sendMessage(messageContent);
        if response.statusCode == http:STATUS_ACCEPTED {
            log:printInfo(string `Welcome emails sent successfully!`);
        } else {
            return error("Failed to send the email from Outlook", statusCode = response.statusCode);
        }
    }
}
