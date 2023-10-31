# Pipedrive New Activities to Trello Tasks
## Use case
At the execution of this sample, the details of all the new activities of type `task` in Pipedrive, scheduled 
within the particular day will be added to the relevant Trello list as tasks in Trello cards. 

## Prerequisites
* Pipedrive account
* Trello account

### Setting up Pipedrive account
* Visit [Pipedrive](https://www.pipedrive.com) and create a Pipedrive account.
* Obtain tokens by following [this guide](https://pipedrive.readme.io/docs/core-api-concepts-authentication)

### Setting up Trello account
* Visit [Trello](https://trello.com) and create a Trello account.
* Obtain tokens by following [this guide](https://developer.atlassian.com/cloud/trello/guides/rest-api/api-introduction/#authentication-and-authorization)

## Configuration
Create a file called `Config.toml` at the root of the project.

### Config.toml 

```
[<ORG_NAME>.pipedrive_new_activities_to_trello_tasks]
idList= "<TRELLO_LIST_ID>"

[<ORG_NAME>.pipedrive_new_activities_to_trello_tasks.pipedriveApiKeysConfig]
apiToken = "<PIPEDRIVE_API_TOKEN>"

[<ORG_NAME>.pipedrive_new_activities_to_trello_tasks.trelloApiKeysConfig]
key = "<TRELLO_API_KEY>"
token = "<TRELLO_API_TOKEN>"
```

### Template Configuration
1. Obtain the `idList`. The `idList` is the ID of the Trello list. For more information, see [How to get Trello list ID](https://community.atlassian.com/t5/Trello-questions/How-to-get-Trello-Board-ID/qaq-p/1347525).
2. Once you obtained all configurations, Create `Config.toml` in root directory.
3. Replace the necessary fields in the `Config.toml` file with your data.

## Testing
Run the Ballerina project created by the integration sample by executing `bal run` from the root.

The the details of all the new activities of type `task` in Pipedrive, scheduled within the particular day will be added to the relevant Trello list as tasks in Trello cards. 
