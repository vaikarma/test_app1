#!/usr/bin/env bash
set -o errexit

# Install Ruby gems
bundle install

# Install Node.js dependencies
npm install

# Build Vite assets
bundle exec vite build

# Run database migrations
bundle exec rake db:migrate

# Start the Rails server (default)
bundle exec rails server -b 0.0.0.0 -p 3000
