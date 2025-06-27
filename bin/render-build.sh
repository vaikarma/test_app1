#!/usr/bin/env bash
set -o errexit

# Install Ruby dependencies
bundle install

# Install JS dependencies using npm
npm install

# Precompile Vite assets
bundle exec vite build

# Run database migrations
bundle exec rake db:migrate
