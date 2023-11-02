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
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

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

# Represents a user.
#
# + userId - id of the user
# + firstName - first name of the user
# + lastName - last name of the user
# + email - email of the user
public type User record {|
    string userId;
    string firstName;
    string lastName;
    string email;
|};

# Represents a reward offer.
#
# + id - id of the reward
# + name - name of the reward
# + value - value of the reward
# + totalPoints - total points of the reward 
# + description - description of the reward
# + logoUrl - logo url of the reward
public type RewardOffer record {|
    string id;
    string name;
    float value;
    int totalPoints;
    string description;
    string logoUrl;
|};

# Represents a user reward.
#
# + userId - id of the user 
# + selectedRewardDealId - selected reward deal id
# + timestamp - timestamp the reward was selected
# + acceptedTnC - whether the user accepted the terms and conditions
public type UserReward record {|
    string userId;
    string selectedRewardDealId;
    string timestamp;
    boolean acceptedTnC;
|};

# Represents a reward confirmation DAO.
#
# + user_id - id of the user
# + reward_id - reward id
# + reward_confirmation_number - reward confirmation number
public type RewardConfirmationDAO record {|
    string user_id;
    string reward_id;
    string reward_confirmation_number;
|};

# Represents a user DAO.
#
# + user_id - id of the user 
# + first_name - first name of the user
# + last_name - last name of the user
# + email - email of the user
public type UserDAO record {|
    string user_id;
    string first_name;
    string last_name;
    string email;
|};

# Represents a reward offer DAO.
#
# + id - id of the reward
# + name - name of the reward
# + value - value of the reward
# + total_points - total points of the reward
# + description - description of the reward
# + logo_url - logo url of the reward
public type RewardOfferDAO record {|
    string id;
    string name;
    float value;
    int total_points;
    string description;
    string logo_url;
|};

# Represents a user reward DAO.
#
# + user_id - id of the user 
# + selected_reward_deal_id - selected reward deal id
# + timestamp - timestamp the reward was selected
# + accepted_tnc - whether the user accepted the terms and conditions
public type UserRewardDAO record {|
    string user_id;
    string selected_reward_deal_id;
    string timestamp;
    boolean accepted_tnc;
|};

configurable string dbhost = ?;
configurable string dbuser = ?;
configurable string dbpwd = ?;
configurable string dbname = ?;

final mysql:Client mysqlEndpoint = check new (host = dbhost, user = dbuser, password = dbpwd, database = dbname);

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function post reward\-confirmation(@http:Payload RewardConfirmation payload) returns string|error {
        log:printInfo("reward confirmation: ", rewardConfirmation = payload);
        sql:ParameterizedQuery insertQuery = `
            INSERT INTO reward_confirmation (reward_id, user_id, reward_confirmation_number) 
            VALUES (${payload.rewardId}, ${payload.userId}, ${payload.rewardConfirmationNumber})`;
        sql:ExecutionResult result = check mysqlEndpoint->execute(insertQuery);
        if result.affectedRowCount > 0 {
            string msg = "successfully saved the reward confirmation";
            log:printInfo(msg);
            return msg;
        } else {
            string msg = "failed to save the reward confirmation";
            log:printError(msg);
            return error(msg);
        }
    }

    resource function get reward\-confirmation(string userId, string rewardId) returns RewardConfirmation|error {
        RewardConfirmation rewardConfirmation;
        log:printInfo("get reward confirmation for: ", userId = userId, rewardId = rewardId);
        sql:ParameterizedQuery selectQuery = `
            SELECT reward_id, user_id, reward_confirmation_number FROM reward_confirmation
            WHERE user_id = ${userId} AND reward_id = ${rewardId}
        `;
        RewardConfirmationDAO result = check mysqlEndpoint->queryRow(selectQuery);
        rewardConfirmation = {
            userId: result.user_id,
            rewardId: result.reward_id,
            rewardConfirmationNumber: result.reward_confirmation_number
        };
        string msg = "successfully retrieved the reward confirmation";
        log:printInfo(msg, rewardConfirmation = rewardConfirmation);
        return rewardConfirmation;
    }

    resource function get reward\-confirmations(string userId) returns RewardConfirmation[]|error {
        RewardConfirmation[] rewardConfirmations = [];
        sql:ParameterizedQuery selectQuery = `
            SELECT reward_id, user_id, reward_confirmation_number FROM reward_confirmation
            WHERE user_id = ${userId}
            ORDER BY id DESC
            LIMIT 5
        `;
        stream<RewardConfirmationDAO, error?> resultStream = mysqlEndpoint->query(selectQuery);
        check from RewardConfirmationDAO rewardConfirmation in resultStream
            do {
                rewardConfirmations.push({
                    userId: rewardConfirmation.user_id,
                    rewardId: rewardConfirmation.reward_id,
                    rewardConfirmationNumber: rewardConfirmation.reward_confirmation_number
                });
            };
        check resultStream.close();
        string msg = "successfully retrieved the reward confirmations";
        log:printInfo(msg);
        return rewardConfirmations;
    }

    resource function get users() returns User[]|error {
        User[] users = [];
        sql:ParameterizedQuery selectQuery = `SELECT user_id, first_name, last_name, email FROM user`;
        stream<UserDAO, error?> resultStream = mysqlEndpoint->query(selectQuery);
        check from UserDAO user in resultStream
            do {
                users.push({
                    userId: user.user_id,
                    firstName: user.first_name,
                    lastName: user.last_name,
                    email: user.email
                });
            };
        check resultStream.close();
        string msg = "successfully retrieved the users";
        log:printInfo(msg);
        return users;
    }

    resource function get reward\-offers() returns RewardOffer[]|error {
        RewardOffer[] rewardOffers = [];
        sql:ParameterizedQuery selectQuery = `
            SELECT id, name, value, total_points, description, logo_url FROM reward_offer
        `;
        stream<RewardOfferDAO, error?> resultStream = mysqlEndpoint->query(selectQuery);
        check from RewardOfferDAO rewardOffer in resultStream
            do {
                rewardOffers.push({
                    id: rewardOffer.id,
                    name: rewardOffer.name,
                    value: rewardOffer.value,
                    totalPoints: rewardOffer.total_points,
                    description: rewardOffer.description,
                    logoUrl: rewardOffer.logo_url
                });
            };
        check resultStream.close();
        string msg = "successfully retrieved the reward offers";
        log:printInfo(msg);
        return rewardOffers;
    }

    resource function get user\-rewards() returns UserReward[]|error {
        UserReward[] userRewards = [];
        sql:ParameterizedQuery selectQuery = `
            SELECT user_id, selected_reward_deal_id, timestamp, accepted_tnc FROM user_reward
        `;
        stream<UserRewardDAO, error?> resultStream = mysqlEndpoint->query(selectQuery);
        check from UserRewardDAO userReward in resultStream
            do {
                userRewards.push({
                    userId: userReward.user_id,
                    selectedRewardDealId: userReward.selected_reward_deal_id,
                    timestamp: userReward.timestamp,
                    acceptedTnC: userReward.accepted_tnc
                });
            };
        check resultStream.close();
        string msg = "successfully retrieved the user rewards";
        log:printInfo(msg);
        return userRewards;
    }
}
