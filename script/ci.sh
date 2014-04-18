#!/usr/bin/env bash

cp config/database.yml.example config/database.yml

bundle exec rake
bundle exec teaspoon
