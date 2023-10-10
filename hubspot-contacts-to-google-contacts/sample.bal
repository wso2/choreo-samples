import ballerina/log;
import ballerinax/googleapis.people as gPeople;
import ballerinax/hubspot.crm.contact as hubspotContact;

configurable string gPeopleClientId = ?;
configurable string gPeopleClientSecret = ?;
configurable string gPeopleRefreshToken = ?;

configurable string hubspotAccessToken = ?;

final gPeople:FieldMask[] personFields = [gPeople:NAME, gPeople:EMAIL_ADDRESS];
public function main() returns error? {
    gPeople:Client gPeopleClient = check new ({
        auth: {
            clientId: gPeopleClientId,
            clientSecret: gPeopleClientSecret,
            refreshToken: gPeopleRefreshToken,
            refreshUrl: gPeople:REFRESH_URL
        }
    });
    hubspotContact:Client hubspotClient = check new ({auth: {token: hubspotAccessToken}});
    hubspotContact:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging hubspotResponse = check hubspotClient->getPage();

    foreach hubspotContact:SimplePublicObjectWithAssociations hubspotContact in hubspotResponse.results {
        map<anydata> contactProperties = hubspotContact.properties;
        gPeople:EmailAddress emailAddress = {};
        gPeople:Name name = {};
        gPeople:Person googleContact = {};
    
        anydata emailInHubspot = contactProperties["email"];
        if emailInHubspot is string {
            emailAddress.value = emailInHubspot;
            googleContact.emailAddresses = [emailAddress];
        }

        anydata firstnameInHubspot = contactProperties["firstname"];
        if firstnameInHubspot is string {
            name.givenName = firstnameInHubspot;
        }

        anydata lastnameInHubspot = contactProperties["lastname"];
        if lastnameInHubspot is string {
            name.familyName = lastnameInHubspot;
        }

        if name?.givenName is string || name?.familyName is string {
            googleContact.names = [name];
        }
        
        gPeople:PersonResponse|error createdContact = gPeopleClient->createContact(googleContact, personFields);
        if createdContact is error {
            log:printError(string `Failed to add contact ${hubspotContact.id} to Google Contacts!`, createdContact);
            continue;
        }
        log:printInfo(string `Contact ${hubspotContact.id} added to Google Contacts successfully!`);
    }
}
