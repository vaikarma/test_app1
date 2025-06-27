#!/bin/bash
set -e

mkdir -p tmp/pids
rm -f tmp/pids/server.pid

exec "$@"
