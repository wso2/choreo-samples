# Today's Movies to SMS Notification
## Use case
When this sample is executed it sends an SMS with the movie detail if the movie release date matches the current date.

## Prerequisites
* The Movie Database (TMDB) account

### Setting up The Movie Database (TMDB) account
To utilize The Movie Database (TMDB) API users have to obtain API key given by [TMDB](https://www.themoviedb.org/)

To obtain an API Key please follow these steps
* Go to [TMDB](https://www.themoviedb.org/) and create an account
* Click the "Settings"
* Click the "API" tab in the left sidebar
* Click "Create" or "click here" on the API page and obtain the API Key (v3 auth)

Then provide the obtained API Key in client configuration.

## Configuration
Create a file called `Config.toml` at the root of the project.

## Config.toml
```
[<ORG_NAME>.upcoming_movies_to_sms]
toMobile = <MOBILE_NUMBER_TO_RECEIVE_SMS>

[<ORG_NAME>.upcoming_movies_to_sms.apiKeyConfig]
apiKey = <API_KEY>
```

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

Once successfully executed, A SMS will be sent to the phone number specified if any movies with release date matches current utc date otherwise it will print the relevant error log.
