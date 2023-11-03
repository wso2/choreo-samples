# Using EDIFACT with Choreo

## Introduction
Electronic Data Interchange (EDI) revolutionizes business communication by enabling the standardized exchange of structured data between enterprises. EDIFACT (Electronic Data Interchange for Administration, Commerce, and Transport) stands out as a widely adopted international EDI standard developed by the United Nations. In B2B integration scenarios, companies often use different data formats, such as EDIFACT, JSON, XML, etc. This necessitates a seamless bridge to facilitate smooth communication between trading partners.

Ballerina emerges as the solution to handle EDIFACT data effortlessly. With its EDIFACT modules, Ballerina allows parsing EDI messages without manual schema creation, making data transformation and mapping effortless.

## What's in this directory 
This directory contains Ballerina implementation of the `Integration Service` for the below described scenario.

## Prerequisites
- Ballerina version `2201.7.0` or higher

## Business Scenario
![EDIFACT Business Scenario](diagrams/EDIFACT%20sample%20scenario.png)

**Foo Corp:** 
`Foo Corp` represents a company that utilizes the EDIFACT format for its B2B communication. They will interact with Bar Industries by sending EDI messages (ORDERS) via HTTP requests.

**Bar Industries:**
`Bar Industries` is another business entity that operates with a backend system designed to accept JSON input and respond with JSON output (`JSON Backend`). For the purpose of this tutorial, this backend is already deployed to a public URL, so implementing it is beyond the scope of our current focus. Instead of that, Bar Industries exposes their JSON backend via an `Integration service`.

## Integration Flow
1. `Foo Corp` sends an HTTP POST request containing an EDIFACT message (ORDERS) to the Integration service.
2. The `Integration service` parses the incoming EDIFACT message, transforming it into a JSON object that the `JSON backend` can process, and calls the `JSON backend` with the JSON data obtained from the EDIFACT message.
3. The `JSON backend`processes the data and responds with a JSON output.
4. The `Integration service` maps the response from the `JSON backend` back into an EDIFACT response (ORDRSP) and responds to `Foo Corp` with the EDIFACT response (ORDRSP).

## Building and Running
1. Clone this repository.

   ```bash
   git clone https://github.com/wso2/choreo-examples.git
   cd integrations/ballerina/edifact-order-service
   ```

2. Run the service

   ```bash
   bal run
   ```
## Deploy and Test
You can use [Choreo](https://console.choreo.dev/) to deploy, test and manage this integration service. 
