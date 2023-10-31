# Test Runner Postman sample

## Use case

When the test runner component is triggered manually, it will run a job to execute automated tests implemented by the developer. Test results can be viewed from the Choreo console.

## Run the sample in Choreo

### Prerequisites

- A valid Choreo account with available resource quota.

Let's write some tests using Postman collections and run those tests in Choreo.

### Create a test runner component using a Postman buildpack

1. Go to [https://console.choreo.dev/](https://console.choreo.dev/cloud-native-app-developer) and sign in. This opens the project home page.
2. Click **Create** button in the Component Listing section. Choose **Test Runner** component type.
3. Enter a unique name and a description for the test runner component. For this guide, let's enter the following values:

   | Field       | Value                                            |
   | ----------- | ------------------------------------------------ |
   | Name        | Postman Test Runner                              |
   | Description | Test Runner implemented with Postman Collections |

4. Click **Github** tab and provide the required source repository details.

   | Field        | Value          |
   | ------------ | -------------- |
   | Organization | wso2           |
   | Repository   | choreo-samples |
   | Branch       | main           |

5. Choose the **Postman** buildpack from the buildpack tiles.
6. Choose a directory with Postman collections. For this example, let's consider the following values.

   | Field             | Value                   |
   | ----------------- | ----------------------- |
   | Postman Directory | /postman-collection-dir |

7. Click **Create**. Once the component creation is complete, you will see the component overview page.

You have successfully created a Test Runner component using Postman buildpack. Now let's build and run the tests.

### Building the test runner component and executing the tests

1. Go to **Deploy** page from the left main menu.
2. Click **Deploy** to build and deploy the test runner component. If you want to provide additional configuration or secrets, use the **Configure and Deploy** option.
3. Once the deployment is successful, go to **Execute** page from the left main menu.
4. Choose the environment from the environment drop down and click **Run Now** button to trigger a test execution.
5. A new execution will be shown in the execution list and click on the execution list item to view the test results.

## Run the sample in local machine

### Prerequisites

- Newman CLI installed in your local machine.

Run the go test suite using `newman run postman-collection-dir/Book_Listing_API-v1.postman_collection.json` command.

Once successfully executed, test cases will get executed and the logs will be shown.

```
newman run postman-collection-dir/Book_Listing_API-v1.postman_collection.json
newman

Book Listing API v1

→ List Books
  GET https://b3127d1c-180f-4696-9aca-90bc5224d4d8-dev.e1-us-east-azure.choreoapis.dev/kkpj/book-listing-api/book-listing-5c6/v1.0/books [401 Unauthorized, 452B, 1002ms]
  1. Response status code is 200
  2. Response is an array with at least one element
  3. Each book object has the required fields
  4. Check if id is a non-negative integer
  5. Title and Author should be non-empty strings
  6. Response has required fields - id, title, and author
  7. Verify the response array contains the expected number of elements
  8. Each book object has the correct values

→ Add book
  POST https://b3127d1c-180f-4696-9aca-90bc5224d4d8-dev.e1-us-east-azure.choreoapis.dev/kkpj/book-listing-api/book-listing-5c6/v1.0/books/add [401 Unauthorized, 452B, 264ms]
  9. Response status code is 201
 10. Id is a non-negative integer
 11. Title is a non-empty string
 12. Author is a non-empty string
 13. The id should be equal to 3
 14. Title is equal to 'New Book'
 15. Author is equal to 'New Author'

→ Update book
  PUT https://b3127d1c-180f-4696-9aca-90bc5224d4d8-dev.e1-us-east-azure.choreoapis.dev/kkpj/book-listing-api/book-listing-5c6/v1.0/books/update [401 Unauthorized, 454B, 265ms]
 16. Response status code is 200
 17. The 'id' field should be a non-negative integer
 18. The title field should be a non-empty string
 19. Validate author field is a non-empty string
 20. Validate the 'id' field is 1
 21. Validate the 'title' field is 'Updated Book'
 22. Validate 'author' field is 'Updated Author'

→ Delete book
  DELETE https://b3127d1c-180f-4696-9aca-90bc5224d4d8-dev.e1-us-east-azure.choreoapis.dev/kkpj/book-listing-api/book-listing-5c6/v1.0/books/delete?id=2 [401 Unauthorized, 454B, 436ms]
 23. Response status code is 204

┌─────────────────────────┬─────────────────────┬─────────────────────┐
│                         │            executed │              failed │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│              iterations │                   1 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│                requests │                   4 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│            test-scripts │                   8 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│      prerequest-scripts │                   4 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│              assertions │                  23 │                  23 │
├─────────────────────────┴─────────────────────┴─────────────────────┤
│ total run duration: 2s                                              │
├─────────────────────────────────────────────────────────────────────┤
│ total data received: 636B (approx)                                  │
├─────────────────────────────────────────────────────────────────────┤
│ average response time: 491ms [min: 264ms, max: 1002ms, s.d.: 302ms] │
└─────────────────────────────────────────────────────────────────────┘

   #  failure                      detail

 01.  AssertionError               Response status code is 200
                                   expected response to have status code 200 but got 401
                                   at assertion:0 in test-script
                                   inside "List Books"

 02.  AssertionError               Response is an array with at least one element
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:1 in test-script
                                   inside "List Books"

 03.  AssertionError               Each book object has the required fields
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:2 in test-script
                                   inside "List Books"

 04.  AssertionError               Check if id is a non-negative integer
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:3 in test-script
                                   inside "List Books"

 05.  AssertionError               Title and Author should be non-empty strings
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:4 in test-script
                                   inside "List Books"

 06.  AssertionError               Response has required fields - id, title, and author
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:5 in test-script
                                   inside "List Books"

 07.  AssertionError               Verify the response array contains the expected number of elements
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:6 in test-script
                                   inside "List Books"

 08.  AssertionError               Each book object has the correct values
                                   expected { Object (error_message, code, ...) } to be an array
                                   at assertion:7 in test-script
                                   inside "List Books"

 09.  AssertionError               Response status code is 201
                                   expected response to have status code 201 but got 401
                                   at assertion:0 in test-script
                                   inside "Add book"

 10.  AssertionError               Id is a non-negative integer
                                   expected undefined to exist
                                   at assertion:1 in test-script
                                   inside "Add book"

 11.  AssertionError               Title is a non-empty string
                                   expected undefined to exist
                                   at assertion:2 in test-script
                                   inside "Add book"

 12.  AssertionError               Author is a non-empty string
                                   expected undefined to be a string
                                   at assertion:3 in test-script
                                   inside "Add book"

 13.  AssertionError               The id should be equal to 3
                                   expected undefined to equal 3
                                   at assertion:4 in test-script
                                   inside "Add book"

 14.  AssertionError               Title is equal to 'New Book'
                                   expected undefined to equal 'New Book'
                                   at assertion:5 in test-script
                                   inside "Add book"

 15.  AssertionError               Author is equal to 'New Author'
                                   expected undefined to equal 'New Author'
                                   at assertion:6 in test-script
                                   inside "Add book"

 16.  AssertionError               Response status code is 200
                                   expected response to have status code 200 but got 401
                                   at assertion:0 in test-script
                                   inside "Update book"

 17.  AssertionError               The 'id' field should be a non-negative integer
                                   'id' should be a number: expected undefined to be a number
                                   at assertion:1 in test-script
                                   inside "Update book"

 18.  AssertionError               The title field should be a non-empty string
                                   expected undefined to be a string
                                   at assertion:2 in test-script
                                   inside "Update book"

 19.  AssertionError               Validate author field is a non-empty string
                                   expected undefined to be a string
                                   at assertion:3 in test-script
                                   inside "Update book"

 20.  AssertionError               Validate the 'id' field is 1
                                   expected undefined to equal 1
                                   at assertion:4 in test-script
                                   inside "Update book"

 21.  AssertionError               Validate the 'title' field is 'Updated Book'
                                   expected undefined to equal 'Updated Book'
                                   at assertion:5 in test-script
                                   inside "Update book"

 22.  AssertionError               Validate 'author' field is 'Updated Author'
                                   expected undefined to equal 'Updated Author'
                                   at assertion:6 in test-script
                                   inside "Update book"

 23.  AssertionError               Response status code is 204
                                   expected response to have status code 204 but got 401
                                   at assertion:0 in test-script
                                   inside "Delete book"
```
