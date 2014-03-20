## Getting started

`git clone` the repo to your computer.

If you are using RVM, when you `cd` into the repo, you will see a message to install the latest version of Ruby 2.0.0; it will tell you the version name. Run the command it gives you, which will look like:

`rvm install VERSIONNAMEGOESHERE`

Then, install Ruby gem dependencies:

`bundle install`

#### Database setup

Postgres is the "known-to-run" database for CityVoice (see "Note on database options" below.) If you're on a Mac, we suggest running [Postgres.app](http://postgresapp.com/).

By default, the `database.yml` in this repo will look for your Postgres credentials in the `POSTGRES_USERNAME` and `POSTGRES_PASSWORD` environment variables and expect a normal localhost connection.

Feel free to edit [database.yml](config/database.yml) for your own local database setup if if differs from this opinionated default

Create the database tables:

`bundle exec rake db:create`

Run the database migrations:

`bundle exec rake db:migrate`


#### Load app content

The singleton `AppContentSet` model stores basic content and configuration for your CityVoice instance (for example, the various text on the landing page.) To get the app running, load some default placeholder content by running:

`bundle exec rake populate_app_content:default`

To configure your own content, write your own Rake task modeled after those in [lib/tasks/populate_app_content.rake](lib/tasks/populate_app_content.rake) or configure it via the Rails console using the `AppContentSet.configure_content` method.


#### Adding subjects for a survey

Now let's load in some example "subjects" (the geographic entities we're running a survey about.) An example Rake task with code to load subjects is in [lib/tasks/manage_deploy_data.rb](lib/tasks/manage_deploy_data.rb) in the "example" namespace at the bottom.

Load the data by running:

`bundle exec rake manage_deploy_data:example:subjects`

If you want to load your own subjects, for now a good way is to write a Rake task modeled on that example. Be sure that your `property_code` attributes are the same number of digits as what you have configured in `AppContentSet.call_in_code_digits` (3 is the the default digits set by the [populate_app_content:default](lib/tasks/populate_app_content.rake).)


#### Adding voice files and a survey

Now we're going to load survey data specifically for the South Bend vacant and abandoned property application. (See www.southbendvoices.com for this survey in production.) In our Code for America fellowship work, survey configuration for our two deployments was done via Rake tasks contained in [lib/tasks/manage_deploy_data.rake](lib/tasks/manage_deploy_data.rake).

Load the abandoned property voice file URLs into the database with:

`bundle exec rake manage_deploy_data:abandoned_properties:voice_files`

Then load the the survey questions:

`bundle exec rake manage_deploy_data:abandoned_properties:questions`

To get a sense for how you might load your own survey data in, you can compare the `abandoned_property`-namespaced tasks in that file with the `iwtw` tasks at the bottom. (`iwtw` was a second deploy with a single voice question we did in South Bend. Note that this was only possible with the current code base because it didn't require any different "structured questions" [i.e., button-pressing questions] -- only a voice message question.)

Lastly, in this current codebase we need to set the `SURVEY_NAME` environment variable to tell the app which survey we're using (look at [the survey model](app/models/survey.rb) to get a sense for what's happening here.) In this case we do it by setting `SURVEY_NAME` to `property`:

`export SURVEY_NAME=property`


#### Adding a Mapbox key for maps

Create a new [Mapbox](www.mapbox.com) map for your app, and set the Mapbox map ID to be used in the `MAPBOX_MAP_ID` environment variable. The map ID will look something like `myaccountname.h8hskena`.

Now, run the app locally with the standard Rails jazz:

`rails s`

and open your browser to [http://localhost:3000](http://localhost:3000).



### Deploying to Heroku

These are instructions for deploying to the [Heroku](www.heroku.com) PaaS. The process will be somewhat similar for another PaaS or a deployment environment running with a similar stack (e.g., Postgres.)

These instructions load example subjects, use default configuration, and uses the South Bend vacant and abandoned survey. See the above section for notes on how you might approach configuring CityVoice for your own purposes.

`git clone` the repository, then:

Create a new Heroku app:

`heroku create yourappnamegoeshere`

Turn on experimental env variable feature:

`heroku labs:enable user-env-compile`

Add the Postgresql add-on:

`heroku addons:add heroku-postgresql`

Promote the new Postgres instance to be the main database:

```
heroku config # Look for your postgres URL's environment variable in output, e.g., HEROKU_POSTGRESQL_RED_URL
heroku pg:promote HEROKU_POSTGRESQL_RED_URL # Remember that your "color" here may be different
```

Push the app (right now we'll use the experimental `revamp-for-local-setup` branch; in the futue this will be `master`):

`git push heroku revamp-for-local-setup`

Set up the database:

```bash
heroku run rake db:create
heroku run rake db:migrate
```

Load example subjects: 

`heroku run rake manage_deploy_data:example:subjects`

Set up the survey from the South Bend vacant and abandoned deploy:

```
heroku run rake manage_deploy_data:abandoned_properties:voice_files
heroku run rake manage_deploy_data:abandoned_properties:questions
heroku config:set SURVEY_NAME=property
```

Set your Mapbox map ID:

`heroku config:set MAPBOX_MAP_ID=username.mapid # change to yours`

Set a secret key by running:

`rake secret`

and then set it on Heroku by taking the output it gave and running:

`heroku config:set SECRET_TOKEN=the_token_you_generated_goes_here_no_really_put_it_here_dont_leave_it_like_this`



#### Setting up Twilio

CityVoice uses the awesome [Twilio](www.twilio.com) telephony API. To hook up your app to Twilio, go to their site, create an account, and buy a phone number. To configure your number on Twilio's site, go to 'Numbers' -> 'Twilio Numbers' and click on the phone number you want to hook up.

On this page, look at the the 'Voice' section, go to the 'Request URL' box, and put in your deployed application's URL followed by `/route_to_survey` (for example: http://my-cityvoice-app-on-heroku.herokuapp.com/route_to_survey )

Then select `POST` from the dropdown immediate to the right of where you put the URL.


#### Email notifications

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

We used the Heroku Sendgrid add-on in production, and so by default the app will expect you to have a `SENDGRID_USERNAME` and `SENDGRID_PASSWORD` environment variables, but these will be set up if you add the add-on as follows:

`heroku addons:add sendgrid:starter`

(You can also choose a bigger plan than the 'starter' tier; see [here](https://addons.heroku.com/sendgrid) for more options.)


#### Other production options

In production, you may want to set up Google Analytics (hard-coded ID for now, so need to tinker) with the environment variable used as a flag:

- GOOGLE_ANALYTICS_ON=true

If you want HTTP basic authentication enabled, you can set the following environment variables:

- LOCK\_CITYVOICE=true
- CITYVOICE\_LOCK\_USERNAME=myusername
- CITYVOICE\_LOCK\_PASSWORD=mypassword


### Note on database options

CityVoice is known to run with the Postgres database. For that reason, the [database.yml](config/database.yml) configuration file and setup instructions contained in this repo uses Postgres.

If you would like to use another database supported by Rails' ActiveRecord (e.g., SQLite, MySQL) you should feel free to create your own `database.yml`, but be forewarned that you might experience problems. Please [add a GitHub Issue](https://github.com/codeforamerica/cityvoice/issues) for any issues you encounter with other databases.

