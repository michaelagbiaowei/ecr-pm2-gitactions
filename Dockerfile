# Base image
FROM node:18-alpine AS base
WORKDIR /usr/share/app

# Dependencies stage
FROM base AS dependencies
COPY package*.json ./
RUN npm install

# Build stage
FROM base AS build
COPY --from=dependencies /usr/share/app/node_modules ./node_modules
COPY . .
RUN npm run build

# Final stage
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html

# Create a non-root user
RUN addgroup -g 1001 -S appgroup
RUN adduser -S appuser -u 1001

# Change ownership of the Nginx directories
RUN chown -R appuser:appgroup /var/cache/nginx /var/log/nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

# Copy the built assets from the build stage
COPY --from=build /usr/share/app/build ./build
COPY nginx.conf /etc/nginx/nginx.conf

# Switch to non-root user
USER appuser

EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

