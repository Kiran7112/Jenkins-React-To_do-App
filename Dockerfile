# Step 1: Build the React app
FROM node:18 AS build

# Set working directory inside the container to the project directory
WORKDIR /app

# Copy package.json and package-lock.json files first (to optimize layer caching)
COPY Notes_app/package.json Notes_app/package-lock.json ./

# Install dependencies

RUN apt-get update && apt-get install -y npm
RUN npm install
# Copy the rest of the application files
COPY Notes_app/ ./

# Run the build command
RUN npm run build

# Step 2: Serve the app using Nginx
FROM nginx:alpine

# Copy the build folder from the build stage into Nginx's html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for the app
EXPOSE 80

# Start Nginx to serve the static files
CMD ["nginx", "-g", "daemon off;"]

