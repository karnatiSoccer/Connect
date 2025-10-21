# === Stage 1: Build the React Frontend ===
# Use a Node.js image to build our React app
FROM node:18-alpine AS build-stage

# Assume your frontend is in a 'frontend' folder
WORKDIR /app/frontend

# Copy only package.json files first to leverage Docker cache
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy the rest of the frontend source code
COPY frontend/ ./
RUN npm run build

# === Stage 2: Build the Production Backend ===
# Use a fresh, lightweight Node.js image for the final app
FROM node:18-alpine AS production-stage

# Assume your backend is in a 'backend' folder
WORKDIR /app/backend

# Copy backend package.json files
COPY backend/package.json backend/package-lock.json ./
# Only install production dependencies
RUN npm install --omit=dev  

# Copy the backend source code
COPY backend/ ./

# --- This is the key part ---
# Copy the built React app from Stage 1 into the backend's 'public' folder
# (Adjust this path if your Express app serves static files from a different folder)
COPY --from=build-stage /app/frontend/build ./public
# Or whatever port your backend server runs on
EXPOSE 8000  

# The command to start your app
CMD ["node", "server.js"]