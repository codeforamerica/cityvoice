#!/usr/bin/env bash

cp config/database.yml.example config/database.yml

bundle exec rake
RAILS_ENV=test bundle exec rake spec:javascripts
