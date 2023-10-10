import ballerina/http;
import ballerina/log;
import ballerina/regex;
import ballerina/time;
import ballerinax/quickbooks.online as quickbooks;
import ballerinax/ronin;

// Ronin configuration parameters
configurable http:CredentialsConfig roninAuthConfig = ?;
configurable string roninServiceUrl = ?;

// Quickbooks configuration parameters
configurable http:BearerTokenConfig quickbooksAuthConfig = ?;
configurable string quickbooksServiceUrl = ?;
configurable string quickbooksRealmId = ?;

ronin:Client roninClient = check new ({auth: roninAuthConfig}, roninServiceUrl);
quickbooks:Client quickbooksClient = check new ({auth: quickbooksAuthConfig}, quickbooksServiceUrl);

public function main() returns error? {
    string yesterdayMidnight = regex:split(time:utcToString(time:utcNow()), "T")[0].concat("T00:00:00Z");
    ronin:Invoices response = check roninClient->listInvoices(updatedSince = yesterdayMidnight);

    // Obtain Ronin invoices
    ronin:Invoice[] invoices = response?.invoices ?: [];
    if invoices.length() == 0 {
        log:printError("Ronin invoices are empty!");
        return;
    }

    // Obtain the Quickbooks customer array list
    string query = "select * from Customer";
    json queryResponse = check quickbooksClient->queryEntity(quickbooksRealmId, query);
    json[] customerArray = check getQuickbooksCustomerArray(queryResponse);

    foreach ronin:Invoice invoice in invoices {
        // Obtain the Ronin customer ID related to the invoice
        int? client_id = invoice?.client_id;
        if client_id is () {
            log:printInfo(string `Client ID is empty for Ronin invoice ID ${invoice?.id ?: "Nil"}!`);
            continue;
        }

        // Obtain the Ronin customer name for the given customer ID
        ronin:ClientObject clientObject = check roninClient->getClient(client_id.toString());
        string customerName = clientObject?.name ?: "";

        // Obtain the Quickbooks customer ID from the Ronin customer name
        string|error customerId = getQuickbooksCustomerId(customerArray, customerName);
        if customerId is error {
            log:printError(string `${customerId.message()} for Ronin invoice ID ${invoice?.id ?: "Nil"}!`);
            continue;
        }

        // Obtain the Ronin invoice items
        ronin:InvoiceItem[] invoice_items = invoice?.invoice_items ?: [];
        if invoice_items.length() == 0 {
            log:printError(string `Invoice items are empty for Ronin invoice ID ${invoice?.id ?: "Nil"}!`);
            continue;
        }

        json[] lineItems = [];
        foreach ronin:InvoiceItem item in invoice_items {
            int qty = item?.quantity ?: 0;
            decimal quantityInDecimal = check decimal:fromString(qty.toString());
            string price = item?.price ?: "0.0";
            decimal priceInDecimal = check decimal:fromString(price);

            lineItems.push({
                "DetailType": "SalesItemLineDetail",
                "Amount": quantityInDecimal * priceInDecimal,
                "Description": item?.title ?: "",
                "SalesItemLineDetail": {
                    "Qty": qty,
                    "UnitPrice": price
                }
            });
        }
        if lineItems.length() == 0 {
            log:printError(string `Quickbooks line items are empty for Ronin invoice ID ${invoice?.id ?: "Nil"}!`);
            continue;
        }

        quickbooks:InvoiceCreateObject invoiceCreateObject = {
            Line: lineItems,
            CustomerRef: {
                value: customerId
            }
        };
        quickbooks:InvoiceResponse|error invoiceResponse = quickbooksClient->createOrUpdateInvoice(quickbooksRealmId, 
            invoiceCreateObject);
        if invoiceResponse is error {
            log:printError(invoiceResponse.message());
            continue;
        }
        log:printInfo(string `Quickbooks invoice created successfully for Ronin invoice ID ${invoice?.id ?: "Nil"}!`);

    }
}

isolated function getQuickbooksCustomerArray(json queryResponse) returns json[]|error {
    map<json> queryResponseMap = check queryResponse.cloneWithType();
    json queryResponseObject = queryResponseMap.hasKey("QueryResponse") ? queryResponseMap.get("QueryResponse") : ();
    if queryResponseObject is () {
        return error("QueryResponse object is unavailable in Quickbooks query response!");
    }

    map<json> queryResponseObjectMap = check queryResponseObject.cloneWithType();
    json customers = queryResponseObjectMap.hasKey("Customer") ? queryResponseObjectMap.get("Customer") : ();
    if customers is () {
        return error("Customer object is unavailable in Quickbooks query response!");
    }

    json[] customerArray = check customers.cloneWithType();
    if customerArray.length() == 0 {
        return error("Quickbooks customer array is empty!");
    }
    return customerArray;
}

isolated function getQuickbooksCustomerId(json[] customerArray, string customerName) returns string|error {
    string? customerId = ();
    foreach json customer in customerArray {
        if customer.DisplayName == customerName {
            customerId = check customer.Id;
            break;
        }
    }
    if customerId is () {
        return error(string `Customer ${customerName} unavailable in Quickbooks`);
    }
    return customerId;
}
