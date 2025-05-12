# Stage 1: Build the Angular application
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy application source
COPY . .

# Build the Angular SSR application
RUN npm run build

# Stage 2: Run the Angular SSR application
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy built files from the builder stage
COPY --from=builder /app/dist /app/dist

# Install production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Expose the port the app runs on
EXPOSE 4000

# Start the server
CMD ["npm", "run", "serve"]
