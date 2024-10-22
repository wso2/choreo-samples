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

# Use a lightweight web server (nginx unprivileged) as the final parent image
FROM choreoanonymouspullable.azurecr.io/nginxinc/nginx-unprivileged:stable-alpine-slim

# Environment variables to configure user permissions
ENV ENABLE_PERMISSIONS=TRUE
ENV DEBUG_PERMISSIONS=TRUE
ENV USER_NGINX=10014 
ENV GROUP_NGINX=10014

# Set the working directory for NGINX
WORKDIR /usr/share/nginx/html

USER root
RUN rm -rf /usr/share/nginx/html/*

# Create a user with a known UID/GID (10014) within the range 10000-20000 for Choreo
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo"

# Copy the built app from the previous stage to the nginx web server directory
COPY --from=build /app/dist/angular-spa /usr/share/nginx/html

# Ensure proper permissions for the custom user (10014) to serve the files
RUN chown -R ${USER_NGINX}:${GROUP_NGINX} /usr/share/nginx/html

# Use the custom unprivileged user 10014 instead of nginx
USER 10014

# Expose port 8080 for the application
EXPOSE 8080

# Start the nginx web server
CMD ["nginx", "-g", "daemon off;"]
