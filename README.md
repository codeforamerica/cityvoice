CityVoice
=========
CityVoice is a place-based call-in system to collect community feedback on geographic entities (like vacant properties) using the simple, accessible medium of the telephone.


WARNING: Early Stage Software
-----------------------------
CityVoice's current code base is *early stage software* and so has a lot of implementation-specific logic hard-coded in. If you're interested in using CityVoice, you're best served by contacting the team at [CityVoiceApp.com](http://www.cityvoiceapp.com) or pinging the lead back-end dev Dave ([@allafarce](http://www.twitter.com/allafarce) on Twitter).


Required Accounts
-----------------
Accounts on three services are required:

  * [Heroku](https://heroku.com)
  * [Twilio](https://twilio.com), and
  * [Mapbox](https://mapbox.com).

If you want to make a custom domain, like `city-name-voice.org`, you'll need to have access to a DNS provider, like Namecheap.


Deployment
----------
First, create a Heroku app:

    $ heroku create

Add the free Sendgrid Heroku addon:

    $ heroku addons:add sendgrid:starter

Add the Heroku scheduled jobs addon:

    $ heroku addons:add scheduler:standard

Next, push the code to Heroku:

    $ git push heroku master

Load some example data:

    $ heroku run rake manage_deploy_data:example:subjects
    $ heroku run rake manage_deploy_data:abandoned_properties:voice_files
    $ heroku run rake manage_deploy_data:abandoned_properties:questions

Set the survey name, the Mapbox id and the secret token:

    $ heroku config:set SURVEY_NAME=property
    $ heroku config:set MAPBOX_MAP_ID=xxxxxxxx.xxxxx
    $ heroku config:set SECRET_TOKEN=`rake secret`


#### Twilio

CityVoice uses the awesome [Twilio](www.twilio.com) telephony API. To hook up your app to Twilio, go to their site, create an account, and buy a phone number. To configure your number on Twilio's site, go to 'Numbers' -> 'Twilio Numbers' and click on the phone number you want to hook up.

On this page, look at the the 'Voice' section, go to the 'Request URL' box, and put in your deployed application's URL followed by `/route_to_survey` (for example: `http://my-cityvoice-app-on-heroku.herokuapp.com/route_to_survey`)

Then select `POST` from the dropdown immediate to the right of where you put the URL.


#### Email Notifications

An example for setting this up on Heroku with a custom domain of `myappdomain.com`:

    $ heroku config:set APP_URL=http://www.myappdomain.com

Then, open the Heroku scheduled jobs console:

    $ heroku addons:open scheduler

Once in the web interface, set up a new scheduled job with the `rake notifications:task` to be run at whatever interval you want.


#### Google Analytics

In production, you may want to set up Google Analytics (hard-coded ID for now, so need to tinker) with the environment variable used as a flag:

    $ heroku config:set GOOGLE_ANALYTICS_ON=true

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

    $ rake db:create:all db:migrate db:test:prepare

Next, load some sample data:

    $ rake populate_app_content:default
    $ rake manage_deploy_data:example:subjects
    $ rake manage_deploy_data:abandoned_properties:voice_files
    $ rake manage_deploy_data:abandoned_properties:questions

Note that loading abandoned properties means that we will need to set `SURVEY_NAME=property` when starting Rails.

Then, create a [MapBox](https://www.mapbox.com) account and pass its id when starting Rails:

    $ MAPBOX_MAP_ID=xxxxx.xxxxxxxx SURVEY_NAME=property rails s


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
