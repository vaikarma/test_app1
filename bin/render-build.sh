#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Install Node.js dependencies
npm install

# Build frontend assets
npm run build

# Precompile Rails assets
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Run database migrations
bundle exec rake db:migrate