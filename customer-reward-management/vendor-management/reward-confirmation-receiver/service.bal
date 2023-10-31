// Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.
//

import ballerina/http;
import ballerina/log;

public type RewardConfirmationEvent record {|
    string userId;
    string rewardId;
    string rewardConfirmationNumber;
|};

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string tokenUrl = ?;
configurable string dataSourceApiEndpoint = ?;

# The client to connect to the data source API
@display {
    label: "Data Source",
    id: "data-source-api"
}
http:Client dataSourceClient = check new (dataSourceApiEndpoint, {
    auth: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret
    }
});

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function post confirm(@http:Payload RewardConfirmationEvent payload) returns error? {
        log:printInfo("reward confirmation received", rewardConfirmation = payload);

        log:printInfo("saving the reward confirmation number to the user profile", userId = payload.userId);
        http:Response|http:Error response = dataSourceClient->post("/reward-confirmation", payload);
        if response is http:Error {
            string msg = "failed to save the reward confirmation number to the user profile";
            log:printError(msg, userId = payload.userId);
            return error(msg);
        }
        log:printInfo("reward confirmation number successfully saved to the user profile", userId = payload.userId,
            statusCode = response.statusCode);
    }
}