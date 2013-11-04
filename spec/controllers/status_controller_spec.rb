require 'spec_helper'

describe StatusController do
  let(:response_hash) { JSON.parse response.body }

  before do
    @my_subject = Subject.find_or_create_by(:name => "My little pony")
    Timecop.freeze
    @time_in_seconds_at_request = Time.now.to_i
    get :check
  end

  it "returns a json response" do
    response.status.should eq(200)
  end

  it "lists all the dependencies of the app" do
    response_hash["dependencies"].should eq(%w( twilio sendgrid postgres mapbox s3 data.southbendin.gov ))
  end

  it "has a resources key (empty hash for now" do
    response_hash["resources"].should_not be_nil
  end

  it "returns a status of 'ok'" do
    response_hash["status"].should eq("ok")
  end

  it "returns an 'updated' attribute with the current time" do
    response_hash["updated"].should eq(@time_in_seconds_at_request)
  end

  after do
    Timecop.return
    @my_subject.destroy
  end

end
