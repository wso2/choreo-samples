# Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
#
# WSO2 LLC. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.

# Use an official Node.js runtime as the base image
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to the container
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the entire Angular app source code to the container
COPY . .

# Build the Angular application for production
RUN npm run build 

# Use a lightweight Nginx image as the final image
FROM nginx:alpine

# Copy the built Angular app from the previous stage to the Nginx web server directory
COPY --from=build /app/dist/angular-spa /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/

# Expose port 80 for serving the web application
EXPOSE 80

# Start the Nginx web server when the container runs
CMD ["nginx", "-g", "daemon off;"]
