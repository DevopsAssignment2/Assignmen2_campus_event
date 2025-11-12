# ------------------------------------------------------------
#  Stage 1: Build the project
# ------------------------------------------------------------
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project source code
COPY . .

# Build the project (Parcel will output to /dist)
RUN npm run build

# ------------------------------------------------------------
#  Stage 2: Serve the built project
# ------------------------------------------------------------
FROM nginx:alpine

# Copy built files from the builder stage to nginx public directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the host
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
