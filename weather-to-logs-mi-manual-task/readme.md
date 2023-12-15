# Weather to Logs - WSO2 MI Manual Task

This project demonstrates how to implement a manually triggerable task in WSO2 Micro Integrator. In this sample scenario, it fetches weather forecast data from the OpenWeatherMap API, processes the response, and logs the processed data.

## Deploying and Test in Choreo

1. Create a `Manual Task` component
    - Fork this repository.
    - Login to [Choreo](https://wso2.com/choreo/).
    - Navigate to create a `Manual Task` component.
    - Provide a name and description for the component.
    - Authorize and select the GitHub details.
    - Select the `GitHub Account` and the forked repository for `GitHub Repository`.
    - Select the `Branch` as `main`.
    - Select `WSO2 MI` as `Buildpack`.
    - Select `weather-to-logs-mi-manual-task` as the `WSO2 MI Project Directory`.
    - Click on "Create" to create the component.
2. Build the component
    - Once the component is created, navigate to the `Build` page.
    - Click `Build`, select the latest commit, click `Build`.
3. Deploy the component
   - Once the build is successful, navigate to the `Deploy` page.
   - Click `Configure & Deploy`.
   - Add following environment variables.
        - `API_KEY` - OpenWeatherMap API key
        - `LATITUDE` - Latitude of the location to get weather details for.
        - `LONGITUDE` - Longitude of the location to get weather details for.
   - Click `Deploy`.
4. Trigger and test the task
   - Once the deployed, navigate to `Execute` page.
   - Click `Run Now` to execute.
   - Check logs by clicking on the execution of the executions list.