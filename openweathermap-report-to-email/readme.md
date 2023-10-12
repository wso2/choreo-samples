Use template (OpenWeatherMap Report to Email) to send the current weather reports via email.

## Use case
There are scenarios where we need to be alert about current weather data in a specific city. We may want to generate weather reports
and distribute these reports frequently. We can run a task to deliver these reports immediately.

## Prerequisites
* Pull the template from central  
  `bal new -t choreo/openweathermap_report_to_email <newProjectName>`
* An Open Weather Map account
  * Obtain API key (App Id) given by [openweathermap.org](https://openweathermap.org/)
* An email account

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml
```
[<ORG_NAME>.openweathermap_report_to_email]
appId = "<OPEN_WEATHER_MAP_APP_ID>"  
cityName = "<OPEN_WEATHER_MAP_CITY_NAME>"  
recipientAddress = "<RECIPIENT_EMAIL_ADDRESS>"
```
* OPEN_WEATHER_MAP_APP_ID - Go to [My API Keys](https://home.openweathermap.org/api_keys) and generate a new API Key (App Id)
* OPEN_WEATHER_MAP_CITY_NAME - City name
* RECIPIENT_EMAIL_ADDRESS - Recipient email address

## Testing
Run the Ballerina project created by the integration template by executing `bal run` from the root.

You can check the email inbox to verify the email received.
