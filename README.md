CityVoice
=====

### About

CityVoice is a place-based call-in system to collect community feedback on geographic entities (like vacant properties) using the simple, accessible medium of the telephone.

### Status

CityVoice's current code base is *early stage software*. The project was a rapid-iteration experiment for South Bend, IN during the 2013 CfA fellowship, and still has a lot of South Bend-specific logic hard-coded in. Generalizing for reuse is an ongoing project.

For details on the status of CityVoice, check out the ["State of the CityVoice" document](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/code-base-overview.md#state-of-the-cityvoice), in particular:

- [High-level status summary](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/code-base-overview.md#high-level-summary)
- [Proposed strategy for generalizing for reuse](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/code-base-overview.md#a-proposal-for-generalizationredeployability)

If you're interested in using (or helping out with!) CityVoice, please contact Dave ([@allafarce on Twitter](https://twitter.com/allafarce)) or open an Issue with a description of how you're thinking of using it (this is helpful in informing the code base's generalization.)

### Dependencies

The main dependency for this app is use of the Twilio telephony API (you'll need a voice phone number.) The app is also built with Rails, Postgres, and is best documented for use on the Heroku web app hosting platform.

## Deprecation Notice

The below sections are deprecated. If you're interested in playing around with CityVoice in it's current state, it is recommended you use the "revamp-for-local-setup" branch, and look at the ["Getting Started" document](https://github.com/codeforamerica/cityvoice/blob/revamp-for-local-setup/getting_started.md).

### Setup (Internal Documentation) -- deprecated

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


### Email notifications -- deprecated

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

### Heroku Deployment -- deprecated

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

