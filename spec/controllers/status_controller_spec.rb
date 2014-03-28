require 'spec_helper'

describe StatusController do
  let(:response_hash) { JSON.parse response.body }

  before do
    stub_request(:post, "http://www.southbendvoices.com/route_to_survey").
         to_return(:status => 201, :body => "here's welcome.mp3")
    @my_subject = FactoryGirl.create(:subject)
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
  end

end
