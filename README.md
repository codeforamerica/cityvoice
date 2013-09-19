Automidnight
=====


![alt text](http://ecx.images-amazon.com/images/I/515oQdDHwmL.jpg "Automatic midnight")

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
```

In production, you may want to set up Google Analytics (hard-coded ID for now, so need to tinker) with the environment variable used as a flag:

- GOOGLE_ANALYTICS_ON=true

If you want HTTP basic authentication enabled, you can set the following environment variables:

- LOCK\_CITYVOICE=true
- CITYVOICE\_LOCK\_USERNAME=myusername
- CITYVOICE\_LOCK\_PASSWORD=mypassword

