# Use an official Node.js runtime as a parent image for building and running the app
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Expose port 8080 for the application
EXPOSE 8080

# Run the Vue dev server
CMD ["npm", "run", "serve"]
