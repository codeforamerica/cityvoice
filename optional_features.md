# Setting up optional CityVoice features

Below are instructions for setting up optional features of CityVoice. These instructions assume you've deployed using Heroku as detailed in the [Deploying on Heroku](README.md#deploying-on-heroku) documentation.

## Email notifications

Add the free Sendgrid Heroku addon:

    $ heroku addons:add sendgrid:starter

Add the Heroku scheduled jobs addon:

    $ heroku addons:add scheduler:standard

An example for setting this up on Heroku with a custom domain of `myappdomain.com`:

    $ heroku config:set APP_URL=http://www.myappdomain.com

Then, open the Heroku scheduled jobs console:

    $ heroku addons:open scheduler

Once in the web interface, set up a new scheduled job with the `rake notifications:task` to be run at whatever interval you want.

## Custom map tiles

By default, CityVoice uses Mapquest's free map tiles. Alternately, you can use [Mapbox](https://mapbox.com) to design your own custom map tiles.

You can do this by creating a map on Mapbox and setting the map ID in the `MAPBOX_MAP_ID` environment variable. For example:

	$ heroku config:set MAPBOX_MAP_ID=mymapidgoeshere

## Google Analytics

In production, you may want to set up Google Analytics with the environment variable used as a flag:

    $ heroku config:set GOOGLE_ANALYTICS_ID=foo123


## Password protection

If you want collect telephone feedback but keep the web interface provide, you can password-protect the web site by setting the following environment variables:

    $ heroku config:set LOCK_CITYVOICE=true
    $ heroku config:set CITYVOICE_LOCK_USERNAME=xxxxxxxxxx
    $ heroku config:set CITYVOICE_LOCK_PASSWORD=`rake secret`

If you forget the username or password, you can always find them again with the Heroku utility:

    $ heroku config
          CITYVOICE_LOCK_USERNAME=very-clever-name
          CITYVOICE_LOCK_PASSWORD=8974ijhdf98sydfkjshdfher0sdufkjshdfkj

