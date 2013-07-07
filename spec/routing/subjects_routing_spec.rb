require "spec_helper"

describe SubjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/subjects").should route_to("subjects#index")
    end

    it "routes to #new" do
      get("/subjects/new").should route_to("subjects#new")
    end

    it "routes to #show" do
      get("/subjects/1").should route_to("subjects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/subjects/1/edit").should route_to("subjects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/subjects").should route_to("subjects#create")
    end

    it "routes to #update" do
      put("/subjects/1").should route_to("subjects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/subjects/1").should route_to("subjects#destroy", :id => "1")
    end

  end
end
