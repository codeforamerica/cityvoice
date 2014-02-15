CityVoice
=====

### About

CityVoice is a place-based call-in system to collect community feedback on geographic entities (like vacant properties) using the simple, accessible medium of the telephone.

### Status

CityVoice's current code base is *early stage software* and so has a lot of implementation-specific logic hard-coded in. If you're interested in using CityVoice, you're best served by contacting the team at [CityVoiceApp.com](http://www.cityvoiceapp.com) or pinging the lead back-end dev Dave ([@allafarce](http://www.twitter.com/allafarce) on Twitter).

This documentation will be improved to make the project more accessible as the code base is refactored.

### Dependencies

The main dependencies for the app are Twilio (a voice phone number) and Mapbox.

### Setup (Internal Documentation)

To set up the Monroe Park pilot, you'll want to set a MONROE\_PILOT environment variable on your server to true.

For example, on Heroku:
```
heroku config:set MONROE_PILOT=true
```

To get going, you'll need to run the following rake tasks in this order:

```
rake db:migrate
rake reset:voice_files
rake reset:questions
rake property_data:import
rake property_data:add_monroe_phone_codes
```

Also, for now, we set the name of the survey in the environment. Example:
`SURVEY_NAME=iwtw`

Lastly, you will need to link your instance of the app to a Mapbox map via setting an environment variable called MAPBOX_MAP_ID. For example:

`MAPBOX_MAP_ID=myaccountname.h8hskena`


### Email notifications

The first step for email notifications is to set the APP_URL environment variable to your root application URL. It should include http:// but exclude the trailing forward slash.

An example for setting this up on Heroku with a custom domain of `myappdomain.com`:

```
heroku config:set APP_URL=http://www.myappdomain.com
```

Email notifications are sent via the `rake notifications:send` task, which should be scheduled as a regularly-run job.

On Heroku, this is most easily done using the scheduler add-on:
```
heroku addons:add scheduler:standard
heroku addons:open scheduler
```

Once in the web interface, set up a new scheduled job with the `rake notifications:task` to be run at whatever interval you want.

### Heroku Deployment

To deploy on Heroku, you'll need to do the following:
```
# Turn on experimental env variable feature
heroku labs:enable user-env-compile
# Add the Postgresql add-on 
heroku addons:add heroku-postgresql
# Find the URL for the database by running the config command and set a DATABASE_URL variable
heroku config # Look for your postgres URL in the output!
heroku config:set DATABASE_URL=yourpostgresURLgoeshere
# Asset pipeline complains without its secret token.
heroku config:set SECRET_TOKEN=<alphanumeric secret string>
```

In production, you may want to set up Google Analytics (hard-coded ID for now, so need to tinker) with the environment variable used as a flag:

- GOOGLE_ANALYTICS_ON=true

If you want HTTP basic authentication enabled, you can set the following environment variables:

- LOCK\_CITYVOICE=true
- CITYVOICE\_LOCK\_USERNAME=myusername
- CITYVOICE\_LOCK\_PASSWORD=mypassword

