# Dependencies explanation
# Twilio - core part of app interaction and storage for voice messages left by users
# Postgres - normal Heroku add-on
# Mapbox - on CFA account currently
#   Look into how to check status on this
# S3 - stores voice files played back by voice app
# data.southbendin.gov - SB's Socrata portal, from which we pull private data

class StatusController < ApplicationController

  def check
    response_hash = Hash.new
    #{ :status => "ok", :updated => "", :dependencies => "", :resources => "" }
    response_hash[:dependencies] = [ "twilio", "sendgrid", "postgres", "mapbox", "s3", "data.southbendin.gov" ]
    response_hash[:status] = everything_ok? ? "ok" : "NOT OK"
    response_hash[:updated] = Time.now.to_i
    response_hash[:resources] = {}
    render :inline => response_hash.to_json
  end

  private
  def everything_ok?
    # Check that we have some database presence and core data is available
    database_okay? && twilio_response_okay?
  end

  def database_okay?
    Location.first.present?
  end

  def twilio_response_okay?
    uri = URI('http://www.southbendvoices.com/route_to_survey')
    res = Net::HTTP.post_form(uri, {})
    index_of_welcome_message = res.body.index("welcome.mp3")
    if index_of_welcome_message
      true
    else
      false
    end
  end

end
