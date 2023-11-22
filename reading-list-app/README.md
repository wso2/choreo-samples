# Choreo Reading List Example

Welcome to the Choreo Reading List Example! This application is designed to help you get familiar with the Choreo platform and its features.

## Overview

This application is a multi-user reading list manager. It allows multiple users to maintain their own reading lists independently. Each user can add, remove, and view books in their personal reading list. It's built using the Choreo platform, showcasing its capabilities in building and deploying multi-user web applications.

## Directory Overview

The repository is structured into distinct sections:

- **Frontend with managed auth**: React web frontend with auth handled through Choreo itself.
- **Frontend**: React web frontend with auth handled through Asgardeo (Similar to using any third party IDP).
- **Backend** - backend microservice that handles the application logic

> NOTE: Frontend and Frontend with managed auth showcase implementing the same frontend using a third party IDP for auth or using the Choreo built in auth implementation.

### Getting Started

To engage with these examples:

1. **Fork the Repository**: Begin by forking this repository to your GitHub account.
2. **Clone Your Forked Repository**:
   ```
   git clone [URL of your forked repository]
   ```
3. Log into [Choreo](https://console.choreo.dev/)
4. Create a mono repo project with React build preset for frontend components and Ballerina for backend component

### Contribution & Feedback

We greatly value community insights:

- **Contribute**: Got a new example or an enhancement? We'd love to incorporate it.
- **Feedback**: Encounter issues or have suggestions? Please raise them under this repository's [issues section](https://github.com/wso2/choreo-examples/issues).
