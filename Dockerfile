# Stage 1 - Build the backend
FROM node:22-bookworm-slim AS build

# Set Python interpreter for `node-gyp` to use
ENV PYTHON=/usr/bin/python3
ENV NODE_OPTIONS=--max-old-space-size=4096

# Install dependencies for building
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential libc++-dev libsqlite3-dev pkg-config zlib1g-dev libv8-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package.json and yarn.lock to install dependencies
COPY yarn.lock package.json .yarnrc.yml backstage.json ./
COPY .yarn ./.yarn
COPY packages/backend/package.json packages/backend/
COPY packages/app/package.json packages/app/

# Copy the rest of the files
# We copy everything because we need the whole monorepo context for workspaces
COPY . .

# Install dependencies
RUN yarn install --immutable

# Build the packages
# This builds both the frontend (app) and backend
# The backend will be configured to serve the frontend static files
RUN yarn tsc
RUN yarn build:backend

WORKDIR /app

# Stage 2 - Create the final image
FROM node:22-bookworm-slim

# Set Python interpreter for `node-gyp` to use
ENV PYTHON=/usr/bin/python3
ENV NODE_ENV=production

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 libsqlite3-dev openssl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built artifacts from the build stage
COPY --from=build --chown=node:node /app/packages/backend/dist/bundle.tar.gz .
COPY --from=build --chown=node:node /app/app-config.yaml .
COPY --from=build --chown=node:node /app/app-config.production.yaml .
COPY --from=build --chown=node:node /app/entrypoint.sh .

# Ensure the entrypoint script is executable
RUN chmod +x /app/entrypoint.sh

# Extract the bundle
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz && chown -R node:node /app

# Switch to node user
USER node

# Call sh explicitly to avoid permission issues with the +x bit or shebang
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]

