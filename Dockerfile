# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.4
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips sqlite3 nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ----------------------------------
# Build stage
# ----------------------------------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle "${BUNDLE_PATH}/ruby/"*/cache "${BUNDLE_PATH}/ruby/"*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN npm run build
RUN bundle exec bootsnap precompile app/ lib/
RUN bundle exec rails assets:precompile

# ----------------------------------
# Final stage
# ----------------------------------
FROM base

COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# Create non-root user and fix permissions
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p tmp/pids && \
    chown -R rails:rails /rails/db /rails/log /rails/tmp /rails/storage

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

USER 1000:1000


ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
