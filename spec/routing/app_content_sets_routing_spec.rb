require "spec_helper"

describe AppContentSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/app_content_sets").should route_to("app_content_sets#index")
    end

    it "routes to #new" do
      get("/app_content_sets/new").should route_to("app_content_sets#new")
    end

    it "routes to #show" do
      get("/app_content_sets/1").should route_to("app_content_sets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/app_content_sets/1/edit").should route_to("app_content_sets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/app_content_sets").should route_to("app_content_sets#create")
    end

    it "routes to #update" do
      put("/app_content_sets/1").should route_to("app_content_sets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/app_content_sets/1").should route_to("app_content_sets#destroy", :id => "1")
    end

  end
end
