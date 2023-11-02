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
import ballerina/mime;
import ballerina/oauth2;

# Represents selected reward.
#
# + userId - id of the user 
# + selectedRewardDealId - id of the selected reward deal  
# + acceptedTnC - indicated weather the user accepted the terms and conditions
public type RewardSelection record {
    string userId;
    string selectedRewardDealId;
    boolean acceptedTnC;
};

# Represents a user.
#
# + userId - id of the user
# + firstName - first name of the user
# + lastName - last name of the user
# + email - email of the user
public type User record {
    string userId;
    string firstName;
    string lastName;
    string email;
};

# Represents a reward.
#
# + rewardId - id of the reward 
# + userId - id of the user 
# + firstName - first name of the user
# + lastName - last name of the user 
# + email - email of the user
public type Reward record {
    string rewardId;
    string userId;
    string firstName;
    string lastName;
    string email;
};

# Represents card details
#
# + userId - id of the user 
# + cardNumber - card number of the user
# + rewardPoints - reward points of the user
# + currentBalance - current balance of the user
# + dueAmount - due amount of the user
# + lastStatementBalance - last statement balance of the user 
# + availableCredit - available credit of the user
public type CardDetails record {
    string userId;
    int cardNumber;
    int rewardPoints;
    float currentBalance;
    float dueAmount;
    float lastStatementBalance;
    float availableCredit;
};

# Represents a reward offer.
#
# + id - id of the reward offer 
# + name - name of the reward offer
# + value - value of the reward offer
# + totalPoints - total points of the reward offer
# + description - description of the reward offer
# + logoUrl - logo url of the reward offer
public type RewardOffer record {
    string id;
    string name;
    float value;
    int totalPoints;
    string description;
    string logoUrl;
};

# Represents a reward confirmation.
#
# + userId - id of the user
# + rewardId - reward id
# + rewardConfirmationNumber - reward confirmation number
public type RewardConfirmation record {|
    string userId;
    string rewardId;
    string rewardConfirmationNumber;
|};

# Represents a reward confirmation with QR code.
#
# + userId - id of the user
# + rewardId - reward id
# + qrCode - qr code
public type RewardConfirmationWithQR record {|
    string userId;
    string rewardId;
    string qrCode;
|};

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string tokenUrl = ?;
configurable string loyaltyApiUrl = ?;
configurable string vendorManagementApiUrl = ?;

oauth2:ClientOAuth2Provider provider = new ({
    tokenUrl: tokenUrl,
    clientId: clientId,
    clientSecret: clientSecret
});

# The client to connect to the Loyalty Management API
@display {
    label: "Loyalty Management API",
    id: "loyalty-management-api"
}
http:Client loyaltyAPIEndpoint = check new (loyaltyApiUrl, {
    auth: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret
    }
});

# The client to connect to the Vendor Management API
@display {
    label: "Vendor Management API",
    id: "vendor-management-api"
}
http:Client vendorManagementClientEp = check new (vendorManagementApiUrl, {
    auth: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret
    }
});

# A service representing a network-accessible API
# bound to port `9090`.
@display {
    label: "Rewards Management API (Ballerina Implementation)",
    id: "rewards-management-api-ballerina"
}
service / on new http:Listener(9090) {

    resource function post select\-reward(RewardSelection selection, http:Headers headers) returns string|error {

        log:printInfo("reward selected: ", selection = selection);
        string jwtHeader = check headers.getHeader("x-jwt-assertion");
        User user = check validateAndDecodeUserInfo(jwtHeader);
        Reward reward = transform(user, selection);

        http:Response|http:Error response = vendorManagementClientEp->post("/rewards", reward);
        if response is http:Error {
            log:printError("error while sending reward selection to vender ", 'error = response);
            return response;
        }

        log:printInfo("reward selection sent to vendor ", statusCode = response.statusCode);
        return "success";
    }

    resource function get card\-details/[string userId]() returns CardDetails|error? {
        // TODO: Implement the logic to retrieve user credit card details
        CardDetails cardDetails = {
            userId: userId,
            cardNumber: 1234567890123456,
            rewardPoints: 3760,
            currentBalance: 1250.39,
            dueAmount: 1000,
            lastStatementBalance: 1692.88,
            availableCredit: 14500
        };
        return cardDetails;
    }

    resource function get rewards(http:Request request) returns RewardOffer[]|error {
        log:printInfo("get all rewards available");
        RewardOffer[]|http:Error rewardsOffers = loyaltyAPIEndpoint->/rewards();
        if rewardsOffers is http:Error {
            log:printError("error retrieving rewards: ", 'error = rewardsOffers);
            return rewardsOffers;
        }
        return rewardsOffers;
    }

    resource function get rewards/[string rewardId]() returns RewardOffer|error {
        log:printInfo("get reward by id", rewardId = rewardId);

        RewardOffer|http:Error rewardOffer = loyaltyAPIEndpoint->/rewards/[rewardId]();
        if rewardOffer is http:Error {
            log:printError("error retrieving reward: ", 'error = rewardOffer);
            return rewardOffer;
        }
        return rewardOffer;
    }

    resource function get qr\-code(string userId, string rewardId) returns http:Response|error {
        log:printInfo("generate QR code for: ", userId = userId, rewardId = rewardId);

        http:Response|http:ClientError response = loyaltyAPIEndpoint->/qr\-code(userId = userId, rewardId = rewardId);
        if response is http:Response && response.statusCode == http:STATUS_OK {
            byte[] binaryPayload = check response.getBinaryPayload();
            http:Response newResponse = new;
            newResponse.setBinaryPayload(binaryPayload, mime:IMAGE_PNG);
            return newResponse;
        } else {
            return response;
        }
    }

    resource function get reward\-confirmations(string userId) returns RewardConfirmationWithQR[]|error {
        log:printInfo("get all reward confirmations for: ", userId = userId);

        RewardConfirmationWithQR[]|http:Error rewardConfirmations =
            loyaltyAPIEndpoint->/reward\-confirmations(userId = userId);
        if rewardConfirmations is http:Error {
            log:printError("error retrieving reward confirmations : ", 'error = rewardConfirmations);
            return rewardConfirmations;
        }
        return rewardConfirmations;
    }
}

function transform(User user, RewardSelection rewardSelection) returns Reward => {
    rewardId: rewardSelection.selectedRewardDealId,
    userId: rewardSelection.userId,
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email
};
