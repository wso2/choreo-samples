import ballerina/log;
import ballerina/time;
import ballerinax/spotify;
import wso2/choreo.sendsms;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://accounts.spotify.com/api/token";
};

configurable OAuth2RefreshTokenGrantConfig spotifyAuthConfig = ?;

configurable string toMobile = ?;

configurable string favoriteArtist = ?;

spotify:ConnectionConfig spotifyClientConfig = {auth: {
    clientId: spotifyAuthConfig.clientId,
    clientSecret: spotifyAuthConfig.clientSecret,
    refreshToken: spotifyAuthConfig.refreshToken,
    refreshUrl: spotifyAuthConfig.refreshUrl
}};

public function main() returns error? {
    spotify:Client spotifyClient = check new (spotifyClientConfig);
    sendsms:Client smsClient = check new ();
    string todayDate = string:substring(time:utcToString(time:utcNow()), 0, 10);
    spotify:NewReleasesObject newReleases = check spotifyClient->getNewReleses();
    spotify:SimplifiedAlbumObject[]? albums = newReleases.albums.items;
    if albums is spotify:SimplifiedAlbumObject[] {
        foreach spotify:SimplifiedAlbumObject album in albums {
            string releasedDate = <string>album?.release_date;
            string url = <string>(<spotify:ExternalUrlObject>album?.external_urls)?.spotify;
            spotify:SimplifiedArtistObject[] artists = album.artists;
            if releasedDate.equalsIgnoreCaseAscii(todayDate) {
                foreach spotify:SimplifiedArtistObject artist in artists {
                    string artistName = <string>artist?.name;
                    if artistName.equalsIgnoreCaseAscii(favoriteArtist.trim()) {
                        string message = "Find "+ favoriteArtist.trim() +"'s new releases at spotify : " + url;
                        _ = check smsClient->sendSms(toMobile, message);
                        log:printInfo("SMS sent successfully! Message : " + message);
                    }
                }
            }
        }
    }
}
