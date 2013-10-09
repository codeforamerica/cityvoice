require 'spec_helper'

describe StatusController do
  let(:response_hash) { JSON.parse response.body }
  before do
    @my_subject = Subject.find_or_create_by(:name => "My little pony")
    get :check
  end
  it "returns a json response" do
    response.status.should eq(200)
  end
  it "lists all the dependencies of the app" do
    response_hash["dependencies"].should eq(%w( twilio sendgrid postgres mapbox s3 data.southbendin.gov ))
  end
  it "returns a status of 'ok'" do
    response_hash["status"].should eq("ok")
  end
  after do
    @my_subject.destroy
  end
end
