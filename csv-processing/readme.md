# CSV Processing
## Use case
When the service is invoked with a country name such as the "United States", it returns the number of TV shows corresponding to the country provided using the dataset. This sample can be used to process data items from a CSV file stored in an Amazon S3 bucket.

## Prerequisites
* An AWS account

### Setting up AWS account
1. Create an [AWS account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start)
2. Obtain [Security credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

## Run the sample
Run the Ballerina project created by the service sample by executing `bal run` from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command
```
$ curl http://localhost:8090/tv_shows?country=United%20States
```
Now service will be invoked and returns data extracted from CSV file 
```
{"title":"TV shows from United States", "count":66}
```
