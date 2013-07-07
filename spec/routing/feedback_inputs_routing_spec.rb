require "spec_helper"

describe FeedbackInputsController do
  describe "routing" do

    it "routes to #index" do
      get("/feedback_inputs").should route_to("feedback_inputs#index")
    end

    it "routes to #new" do
      get("/feedback_inputs/new").should route_to("feedback_inputs#new")
    end

    it "routes to #show" do
      get("/feedback_inputs/1").should route_to("feedback_inputs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/feedback_inputs/1/edit").should route_to("feedback_inputs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/feedback_inputs").should route_to("feedback_inputs#create")
    end

    it "routes to #update" do
      put("/feedback_inputs/1").should route_to("feedback_inputs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/feedback_inputs/1").should route_to("feedback_inputs#destroy", :id => "1")
    end

  end
end
