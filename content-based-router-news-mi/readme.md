# Content-Based Router

The "Content-Based Router" sample shows how to use API integration to route requests to different endpoints based on
their payload. The example is specific to a news API and allows users to send requests with either "sports" or "news" as
the news type in the payload. The integration then directs the request to the appropriate endpoint and returns the
response to the user. If the news type is invalid, an error message is displayed. To use this sample with Choreo, follow
these steps:

## Create a MI Integration
- Login to [Choreo console](https://console.choreo.dev/)
- Create a service with `WSO2 Micro Integrator` as the build pack.
- Provide a name and description for the component.
- Authorize and select the GitHub details
- Select the `GitHub Account` and the forked repository for `GitHub Repository`
- Select the `Branch` as `main`
- Enter `content-based-router-news-mi` as the `Project Path`
- Click on "Create" to create the component.
- Once the component is created, go to the "Deploy" section and click on the "Deploy Manually" button.

 Once done go to the Choreo Test console and use the Swagger console to try out the API
- Set the following payload to get sports news
```
{
    "type":"sports"
}
```

- Set the following payload to get general news
```
{
    "type":"news"
}
```