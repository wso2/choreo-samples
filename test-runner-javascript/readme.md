Use template (Test Runner Javascript) to write and execute automated tests against applications hosted in Choreo or any 3rd party services.

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results and logs can be viewed from the Choreo console.

## Prerequisites

- Javascript installed in your local machine.

## Run the template

Run the go test suite using `npm run start` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
npm run start

> test-runner@1.0.0 start
> npx mocha index.js



  API Tests
    ✔ Test 1: Ensure the API response matches the expected values (358ms)


  1 passing (360ms)
```
