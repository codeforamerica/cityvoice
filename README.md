CityVoice [![Build Status](https://travis-ci.org/codeforamerica/cityvoice.svg?branch=master)](https://travis-ci.org/codeforamerica/cityvoice) [![Code Climate](https://codeclimate.com/github/codeforamerica/cityvoice.png)](https://codeclimate.com/github/codeforamerica/cityvoice)
=========
CityVoice is a place-based call-in system to collect community feedback on geographic entities (like vacant properties) using the simple, accessible medium of the telephone.


Notice
------
CityVoice's current code base is *early stage software*. The project was a rapid-iteration experiment for South Bend, IN during the 2013 CfA fellowship, and still has a lot of South Bend-specific logic hard-coded in. Generalizing for reuse is an ongoing project.

For details on the status of CityVoice, check out the ["State of the CityVoice" document](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/code-base-overview.md#state-of-the-cityvoice), in particular:

- [High-level status summary](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/code-base-overview.md#high-level-summary)
- [Proposed strategy for generalizing for reuse](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/code-base-overview.md#a-proposal-for-generalizationredeployability)

If you're interested in using (or helping out with!) CityVoice, please contact Dave ([@allafarce on Twitter](https://twitter.com/allafarce)) or open an Issue with a description of how you're thinking of using it (this is helpful in informing the code base's generalization.)


Required Accounts
-----------------
Accounts on these services are required:

  * [Heroku](https://heroku.com)
  * [Twilio](https://twilio.com)

If you want to make a custom domain, like `city-name-voice.org`, you'll need to have access to a DNS provider, like Namecheap.


Deployment
----------
First, create a Heroku app:

    $ heroku create

Add the free Sendgrid Heroku addon:

    $ heroku addons:add sendgrid:starter

Add the Heroku scheduled jobs addon:

    $ heroku addons:add scheduler:standard

Set the secret token:

    $ heroku config:set SECRET_TOKEN=`rake secret`

Next, push the code to Heroku:

    $ git push heroku master

Migrate the database:

    $ heroku run rake db:migrate

Load some example data:

    $ heroku run rake import:locations
    $ heroku run rake import:questions


#### Twilio

CityVoice uses the awesome [Twilio](www.twilio.com) telephony API. To hook up your app to Twilio, go to their site, create an account, and buy a phone number. To configure your number on Twilio's site, go to 'Numbers' -> 'Twilio Numbers' and click on the phone number you want to hook up.

On this page, look at the the 'Voice' section, go to the 'Request URL' box, and put in your deployed application's URL followed by `/calls` (for example: `http://my-cityvoice-app-on-heroku.herokuapp.com/calls`)

Then select `POST` from the dropdown immediate to the right of where you put the URL.


#### Email Notifications

An example for setting this up on Heroku with a custom domain of `myappdomain.com`:

    $ heroku config:set APP_URL=http://www.myappdomain.com

Then, open the Heroku scheduled jobs console:

    $ heroku addons:open scheduler

Once in the web interface, set up a new scheduled job with the `rake notifications:task` to be run at whatever interval you want.


#### Google Analytics

In production, you may want to set up Google Analytics with the environment variable used as a flag:

    $ heroku config:set GOOGLE_ANALYTICS_ID=foo123


#### Basic Authentication

If you want HTTP basic authentication enabled, you can set the following environment variables:

    $ heroku config:set LOCK_CITYVOICE=true
    $ heroku config:set CITYVOICE_LOCK_USERNAME=xxxxxxxxxx
    $ heroku config:set CITYVOICE_LOCK_PASSWORD=`rake secret`

If you forget the username or password, you can always find them again with the Heroku utility:

    $ heroku config
      CITYVOICE_LOCK_USERNAME=very-clever-name


Development
-----------

Use Bundler to install dependencies:

    $ bundle install

To get the application set up for local development, first copy database.yml:

    $ cp config/database.yml.example config/database.yml

Then, edit it for your local Postgres installation and run:

    $ rake db:reset db:test:prepare

Next, load some sample data:

    $ rake import:locations
    $ rake import:questions


### Twilio Local Setup

In order to set up Twilio for local development, you'll need a way to connect Twilio to your local machine.  The easiest way for this to happen is to install [ngrok](https://ngrok.com).

Then, run `ngrok 3000` to open a tunnel:

    $ ngrok 3000
    Tunnel Status                 online
    Version                       1.6/1.5
    Forwarding                    http://xxx.ngrok.com -> 127.0.0.1:3000
    Forwarding                    https://xxx.ngrok.com -> 127.0.0.1:3000
    Web Interface                 127.0.0.1:4040

Log into your Twilio application, open up your [phone number](https://www.twilio.com/user/account/phone-numbers/incoming) and change the Voice Request URL to the `https://xxx.ngrok.com` redirection address.


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


License and Copyright
---------------------

Copyright 2013-2014 Code for America, MIT License (see LICENSE.md for details)
