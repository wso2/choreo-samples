# Use an official Node.js runtime as the base image
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to the container
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the entire Vue.js app source code to the container
COPY . .

# Build the Vue.js application for production
RUN npm run build

# Use a lightweight Nginx image as the final image
FROM nginx:alpine

# Create a new user and group with specific UID and GID for better security
RUN addgroup -g 10014 choreo && \
    adduser --disabled-password --no-create-home --uid 10014 --ingroup choreo choreouser

# Create a writable directory for Nginx temp files
RUN mkdir -p /home/choreouser/nginx_cache/client_temp && \
    chown -R choreouser:choreo /home/choreouser/nginx_cache

# Copy the built Vue.js app from the previous stage to the Nginx web server directory
COPY --from=build /app/dist /usr/share/nginx/html

# Set ownership of the Nginx web server directory to the non-root user
RUN chown -R choreouser:choreo /usr/share/nginx/html

# Copy a custom Nginx configuration file to the container
COPY nginx.conf /etc/nginx/nginx.conf

# Switch to the non-root user for better security
USER 10014

# Expose port 80 for serving the web application
EXPOSE 80

# Start the Nginx web server when the container runs
CMD ["nginx", "-g", "daemon off;"]
