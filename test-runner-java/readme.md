Use template (Test Runner Java) to write and execute automated tests against applications hosted in Choreo or any 3rd party services.

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results and logs can be viewed from the Choreo console.

## Prerequisites

- Java (JDK) installed in your local machine.

## Run the template

Build the java test suite using `mvn clean install` command. Build artefacts will be located in `target/` directory.

Run the java test suite using `java -jar target/test-runner-1.0-SNAPSHOT-jar-with-dependencies.jar` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
java -jar target/test-runner-1.0-SNAPSHOT-jar-with-dependencies.jar

API call successful
Status code is 200
Title matches expected value
```
