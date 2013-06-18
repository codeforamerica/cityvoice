require "spec_helper"

describe VoiceTranscriptionsController do
  describe "routing" do

    it "routes to #index" do
      get("/voice_transcriptions").should route_to("voice_transcriptions#index")
    end

    it "routes to #new" do
      get("/voice_transcriptions/new").should route_to("voice_transcriptions#new")
    end

    it "routes to #show" do
      get("/voice_transcriptions/1").should route_to("voice_transcriptions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/voice_transcriptions/1/edit").should route_to("voice_transcriptions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/voice_transcriptions").should route_to("voice_transcriptions#create")
    end

    it "routes to #update" do
      put("/voice_transcriptions/1").should route_to("voice_transcriptions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/voice_transcriptions/1").should route_to("voice_transcriptions#destroy", :id => "1")
    end

  end
end
