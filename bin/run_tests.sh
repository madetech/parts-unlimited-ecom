#!/usr/bin/env ash

set -e

while ! psql $DB_URL -c 'SELECT 1'; do
    echo 'Waiting for db'; sleep 3;
done

bundle exec guard
