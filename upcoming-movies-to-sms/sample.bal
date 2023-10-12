import ballerina/log;
import ballerina/time;
import ballerinax/themoviedb;
import wso2/choreo.sendsms;

//The Movie Database (TMDB) configuration
configurable themoviedb:ApiKeysConfig TMDBApiKeyConfig = ?;

configurable string toMobile = ?;

public function main() returns error? {
    themoviedb:Client themoviedbClient = check new themoviedb:Client(TMDBApiKeyConfig);
    string todayDate = string:substring(time:utcToString(time:utcNow()), 0, 10);
    string smsMessage = "";
    themoviedb:InlineResponse2001 upcomingMovies = check themoviedbClient->getUpcomingMovies();
    themoviedb:MovieListObject[]? movieLists = upcomingMovies.results;
    if movieLists is themoviedb:MovieListObject[] {
        string[] movieNamesReleasedToday = [];
        foreach var movieList in movieLists {
            if movieList?.release_date == todayDate {
                movieNamesReleasedToday.push(movieList.title.toString());
            }
        }
        sendsms:Client smsClient = check new ();
        if movieNamesReleasedToday.length() != 0 {
            smsMessage = "Following movies will be released today (" + todayDate + "),\n";
            foreach var movieName in movieNamesReleasedToday {
                smsMessage = smsMessage + "* " + movieName + "\n";
            }
            string sendSmsResponse = check smsClient->sendSms(toMobile, smsMessage);
            log:printInfo("Sms sent successfully! Message status: " + sendSmsResponse);
        }  else {
            log:printInfo("No movies will be released today");
        }
    } else {
        log:printInfo("No movies found");
    }
}
