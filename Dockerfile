# Step 1: Build the application
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./
RUN npm install

# Copy the rest of your custom source code and build it
COPY . .
RUN npm run build

# Step 2: Serve the static files using Nginx
FROM nginx:alpine

# 1. Copy the index.html to the root directory
COPY --from=build /app/dist/index.html /usr/share/nginx/html/

# 2. Copy the full nested build directory structure into Nginx
COPY --from=build /app/dist /usr/share/nginx/html/Anim8Cursor

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

