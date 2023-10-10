import ballerina/http;
import ballerina/log;
import ballerinax/salesforce;
import ballerinax/stripe;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
};

configurable http:BearerTokenConfig stripeAuthConfig = ?;
configurable string salesforceBaseUrl = ?;
configurable OAuth2RefreshTokenGrantConfig salesforceOAuthConfig = ?;

stripe:ConnectionConfig stripeClientConfig = {auth: stripeAuthConfig};

salesforce:ConnectionConfig salesforceClientConfig = {
    baseUrl: salesforceBaseUrl,
    auth: {
        clientId: salesforceOAuthConfig.clientId,
        clientSecret: salesforceOAuthConfig.clientSecret,
        refreshToken: salesforceOAuthConfig.refreshToken,
        refreshUrl: salesforceOAuthConfig.refreshUrl
    }
};

public function main() returns error? {
    salesforce:SoqlResult[] salesforceProductList = [];
    stripe:Client stripeClient = check new (stripeClientConfig);
    salesforce:Client salesforceClient = check new (salesforceClientConfig);

    salesforce:SoqlResult queryResults = check salesforceClient->getQueryResult("SELECT Name, IsActive, Description FROM Product2");
    salesforceProductList.push(queryResults);

    string nextRecordsUrl = queryResults.hasKey("nextRecordsUrl") ? check queryResults.get("nextRecordsUrl") : "";

    while (nextRecordsUrl.trim() != "") {
        salesforce:SoqlResult nextQueryResult = check salesforceClient->getNextQueryResult(nextRecordsUrl);
        nextRecordsUrl = nextQueryResult.hasKey("nextRecordsUrl") ? check nextQueryResult.get("nextRecordsUrl") : "";
        salesforceProductList.push(nextQueryResult);
    }

    foreach salesforce:SoqlResult result in salesforceProductList {
        salesforce:SoqlRecord[] productRecords = result.records;
        foreach record {} item in productRecords {
            stripe:V1ProductsBody stripeProduct = {
                name: check item["Name"].ensureType(),
                description: check item["Description"].ensureType(),
                active: check item["IsActive"].ensureType()
            };
            stripe:Product createdProduct = check stripeClient->createProduct(stripeProduct);
            log:printInfo("Product created successfully", ProductId = check createdProduct.id.ensureType());
        }
    }
}
