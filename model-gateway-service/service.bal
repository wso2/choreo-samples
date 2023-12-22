// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/lang.regexp;
import ballerina/log;
import ballerinax/azure.openai.chat;
import ballerinax/azure.openai.embeddings;
import ballerinax/azure.openai.text;

configurable string azureOpenAIToken = ?;
configurable string azureOpenAIServiceUrl = ?;
configurable string azureOpenAIApiVersion = ?;

final text:Client textClient = check new (
    config = {auth: {apiKey: azureOpenAIToken}},
    serviceUrl = azureOpenAIServiceUrl
);

final chat:Client chatClient = check new (
    config = {auth: {apiKey: azureOpenAIToken}},
    serviceUrl = azureOpenAIServiceUrl
);

final embeddings:Client embeddingsClient = check new (
    config = {auth: {apiKey: azureOpenAIToken}},
    serviceUrl = azureOpenAIServiceUrl
);

const string PII_DETECTION_ERROR_MESSAGE = "PII detected in the request payload";

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function post [string deploymentId]/completions(@http:Payload text:Deploymentid_completions_body request) returns text:Inline_response_200|http:BadRequest|error {

        string|string[]? prompt = request?.prompt;

        // Check if the prompt(s) contain(s) PII
        if (prompt is string && containsPii(prompt)) || (prompt is string[] && containsPii(" ".'join(...prompt))) {
            log:printWarn(PII_DETECTION_ERROR_MESSAGE);
            // Return a 400 Bad Request response if PII is detected
            return {
                body: PII_DETECTION_ERROR_MESSAGE
            };
        }

        // Forward the request to the Azure OpenAI completions endpoint
        text:Inline_response_200 response = check textClient->/deployments/[deploymentId]/completions.post(
            azureOpenAIApiVersion,
            request
        );

        return response;
    }

    resource function post [string deploymentId]/chat/completions(@http:Payload chat:CreateChatCompletionRequest request) returns chat:CreateChatCompletionResponse|http:BadRequest|error {

        // Check if the chat messages contains PII
        foreach chat:ChatCompletionRequestMessage message in request.messages {
            string? messageContent = message.content;
            if messageContent is string && containsPii(messageContent) {
                log:printWarn(PII_DETECTION_ERROR_MESSAGE);
                // Return a 400 Bad Request response if PII is detected
                return {
                    body: PII_DETECTION_ERROR_MESSAGE
                };
            }
        }

        // Forward the request to the Azure OpenAI chat completions endpoint
        chat:CreateChatCompletionResponse response = check chatClient->/deployments/[deploymentId]/chat/completions.post(
            azureOpenAIApiVersion,
            request
        );

        return response;
    }

    resource function post [string deploymentId]/embeddings(@http:Payload embeddings:Deploymentid_embeddings_body request) returns embeddings:Inline_response_200|http:BadRequest|error {

        string|string[]? input = request?.input;

        // Check if the input(s) contains PII
        if (input is string && containsPii(input)) || (input is string[] && containsPii(" ".'join(...input))) {
            log:printWarn(PII_DETECTION_ERROR_MESSAGE);
            // Return a 400 Bad Request response if PII is detected
            return {
                body: PII_DETECTION_ERROR_MESSAGE
            };
        }

        // Forward the request to the Azure OpenAI embeddings endpoint
        embeddings:Inline_response_200 response = check embeddingsClient->/deployments/[deploymentId]/embeddings.post(
            azureOpenAIApiVersion,
            request
        );

        return response;
    }
}

function containsPii(string text) returns boolean {
    // Define regular expressions for common PII types
    string:RegExp emailPattern = re `[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}`;
    string:RegExp phoneNumberPattern = re `\d{3}[-\s]?\d{3}[-\s]?\d{4}|\d{10}`;
    string:RegExp ssnPattern = re `\d{3}[-.\s]?\d{2}[-.\s]?\d{4}`;
    string:RegExp ipv4Pattern = re `\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}`;
    string:RegExp ipv6Pattern = re `([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}`;
    string:RegExp creditCardPattern = re `(\d{4}[-.\s]?){3}\d{4}|\d{16}`;

    if re `${emailPattern}|${phoneNumberPattern}|${ssnPattern}|${ipv4Pattern}|${ipv6Pattern}|${creditCardPattern}`.find(text) is regexp:Span {
        return true;
    }

    return false;
}
