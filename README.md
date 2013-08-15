Automidnight
=====


![alt text](http://ecx.images-amazon.com/images/I/515oQdDHwmL.jpg "Automatic midnight")

To get going, you'll need to:

1. Run `bundle exec rake db:migrate`
2. Run `rake db:seed` to get the basic questions in
3. Run `rake reset:voice_files` to add in the data related to voice files
4. Turn on access to the data files on S3, and run `rake property\_data:import` to load in the property data

If you want HTTP basic authentication enabled, you can set the following environment variables:

- LOCK\_CITYVOICE=true
- CITYVOICE\_LOCK\_USERNAME=myusername
- CITYVOICE\_LOCK\_PASSWORD=mypassword

