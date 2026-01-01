#!/bin/sh
set -e

# If no APP_BASE_URL is set, try to use the Railway domain
if [ -z "$APP_BASE_URL" ] && [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  export APP_BASE_URL="https://$RAILWAY_PUBLIC_DOMAIN"
fi

# Fallback if still empty (e.g. initial deploy before domain generation)
if [ -z "$APP_BASE_URL" ]; then
  echo "⚠️ WARNING: No APP_BASE_URL or RAILWAY_PUBLIC_DOMAIN detected."
  echo "The UI might not work correctly until a domain is generated in Railway."
  echo "Falling back to http://localhost:7007 for now."
  export APP_BASE_URL="http://localhost:7007"
fi

echo "🚀 Setting Backstage Base URL to: $APP_BASE_URL"

# Find all JS files and replace the placeholder
# Note: We use a specific placeholder baked in during Docker build
echo "🔍 Injecting runtime variables into bundles..."
# We use a simple find + sed that is compatible with POSIX sh and Alpine/Debian sed
find /app/packages /app/app-config.production.yaml -type f -name "*.js" -o -name "*.yaml" | xargs sed -i "s|__BACKSTAGE_BASE_URL__|$APP_BASE_URL|g" || true

# Execute the actual Backstage command
exec node packages/backend --config app-config.yaml --config app-config.production.yaml
