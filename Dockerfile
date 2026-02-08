# ==============================================================================
# STAGE 1: Build Stage (Optional - for future enhancements)
# ==============================================================================
FROM nginx:alpine AS base

# ==============================================================================
# STAGE 2: Production Stage
# ==============================================================================
FROM nginx:alpine

# Metadata labels (Best Practice)
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="AZ-900 Practice Assessment Portal - DevOps Learning Project"

# Install security updates (Best Practice)
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

# Create non-root user for security (Best Practice)
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Remove default nginx config and content
RUN rm -rf /usr/share/nginx/html/* && \
    rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy application files with proper ownership
COPY --chown=appuser:appgroup . /usr/share/nginx/html

# Set proper permissions
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    chown -R appuser:appgroup /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

# Switch to non-root user
USER appuser

# Expose port 8080 (non-privileged port)
EXPOSE 8080

# Health check (Best Practice)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
