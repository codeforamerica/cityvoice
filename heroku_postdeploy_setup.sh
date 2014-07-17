#!/bin/bash
bundle exec rake db:migrate
bundle exec rake import:locations
bundle exec rake import:questions
