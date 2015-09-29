#!/usr/bin/env bash

set -e
cp config/database.yml.example config/database.yml

bundle exec rake
bundle exec teaspoon
