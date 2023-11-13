import ballerina/http;
import ballerina/log;
import ballerina/email;
import ballerina/regex;
import ballerina/io;

configurable string emailHost = "smtp.email.com";
configurable string emailUsername = "admin";
configurable string emailPassword = "admin";
const string bookingConfirmedEmailTemplate = "/home/ballerina/resources/email-templates/booking_confirmation.html";
const string vaccinationAlertEmailTemplate = "/home/ballerina/resources/email-templates/vaccination_alert.html";

map<string> emailTemplates = {};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # Send an email
    # + emailContent - email content
    # + return - 200 OK response or error
    resource function post messages(@http:Payload EmailContent emailContent) returns http:Ok|error? {
        error? result = sendEmail(emailContent);
        if (result is error) {
            return error("Error while sending the email, " + result.toString());
        }
        return http:OK;
    }

}

function sendEmail(EmailContent emailContent) returns error? {

    if emailHost == "smtp.email.com" {
        log:printWarn("Email not configured. Hence not sending the email for the alert, [Alert Type]:" + emailContent.emailType +
        ", [Receipient]:" + emailContent.receipient);
    }

    do {
        email:SmtpClient smtpClient = check new (emailHost, emailUsername, emailPassword);
        string emailSubject = emailContent.emailSubject;

        string|error? content = getEmailContent(emailContent.emailType, emailContent.properties);

        if (content is error) {
            return content;
        }

        email:Message email = {
            to: emailContent.receipient,
            subject: emailSubject,
            htmlBody: content
        };

        check smtpClient->sendMessage(email);
        log:printInfo("Email sent for the alert, [Alert Type]:" + emailContent.emailType +
        ", [Receipient]:" + emailContent.receipient);
    }
    on fail var e {
        log:printError("Error while sending the email for the alert, [Alert Type]:" + emailContent.emailType +
        ", [Receipient]:" + emailContent.receipient + ", [Error]:" + e.toString());
        return e;
    }

}

function getEmailContent(string emailType, Property[] properties) returns string|error? {

    string emailTemplateFilePath = "";
    match emailType {
        BOOKING_CONFIRMED => {
            emailTemplateFilePath = bookingConfirmedEmailTemplate;
        }
        VACCINATION_ALERT => {
            emailTemplateFilePath = vaccinationAlertEmailTemplate;
        }
        _ => {
            return error("Unsupported email type found");
        }
    }
    string|error emailTemplate = getEmailTemplate(emailType, emailTemplateFilePath);

    if (emailTemplate is error) {
        return emailTemplate;
    }
    string htmlBody = replaceTemplateValues(emailTemplate, properties);
    return htmlBody;

}

function getEmailTemplate(string emailType, string emailTemplateFilePath) returns string|error {

    if emailTemplates.hasKey(emailType) {
        return <string>emailTemplates[emailType];
    }

    string|io:Error emailTemplate = io:fileReadString(emailTemplateFilePath);

    if (emailTemplate is io:Error) {
        log:printError("Error while loading the [Email Template]:" + emailType + ", " + emailTemplate.toString());
        log:printError("Please mount the file to the container. Mount location: " + emailTemplateFilePath);
        emailTemplate = "";
    } else {
        log:printInfo("[Email Template]:" + emailType + " loaded successfully.");
    }

    emailTemplates[emailType] = check emailTemplate;
    return emailTemplate;
}

function replaceTemplateValues(string emailTemplate, Property[] properties) returns string {

    string htmlBody = emailTemplate;
    foreach var property in properties {
        htmlBody = regex:replaceAll(htmlBody, "\\{" + property.name + "\\}", property.value);
    }

    return htmlBody;
}
