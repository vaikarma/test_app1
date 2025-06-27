#!/usr/bin/env bash
# exit on error
set -o errexit

# Run database migrations
bundle exec rake db:migrate

# Start the Rails server
bundle exec rails server -b 0.0.0.0 -p $PORT