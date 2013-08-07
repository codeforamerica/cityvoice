Automidnight
=====


![alt text](http://ecx.images-amazon.com/images/I/515oQdDHwmL.jpg "Automatic midnight")

To get going, you'll need to:

1. Run bundle exec rake db:migrate
2. Run rake db:seed to get the basic questions in
3. Download the property data, store it in /tmp, and run bundle exec rake property\_data:import

If you want simple authentication, you'll want to set the following environment variables:

- LOCK\_CITYVOICE=true
- CITYVOICE\_LOCK\_USERNAME=myusername
- CITYVOICE\_LOCK\_PASSWORD=mypassword

