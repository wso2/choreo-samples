import ballerina/log;
import ballerinax/newsapi;
import wso2/choreo.sendemail;

//News API configuration
configurable newsapi:ApiKeysConfig apiKeyConfig = ?;
configurable string emailAddress = ?;

public function main() returns error? {
    string mailBody = "";
    newsapi:Client newsClient = check new (apiKeyConfig, {}, "https://newsapi.org/v2");
    newsapi:WSNewsTopHeadlineResponse topHeadlines = check newsClient->listTopHeadlines(sources="bbc-news", page=1);
    log:printInfo(topHeadlines.toString());
    newsapi:WSNewsArticle[]? articles = topHeadlines?.articles;
    if articles is newsapi:WSNewsArticle[] && articles.length() != 0 {
        mailBody = "BBC top news are,\n";
        foreach var article in articles {
            string? title = article?.title;
            if title is string {
                mailBody = mailBody + "\t" + "* " + title + "\n";
                log:printInfo(mailBody);
            }
        }
        sendemail:Client sendemailEndpoint = check new ();
        string sendEmailResponse = check sendemailEndpoint->sendEmail(emailAddress, "BBC Headlines", mailBody);
        log:printInfo("Email sent successfully!" + sendEmailResponse);
    } else {
        log:printInfo("No news found");
    }
}
