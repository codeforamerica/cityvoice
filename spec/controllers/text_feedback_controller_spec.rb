require 'spec_helper'

describe TextFeedbackController do
  describe "database saving" do
    it "saves well-formed input to the DB" do
      post :handle_feedback, Body: "1234A", From: "+12345678989"
      FeedbackItem.find_by_phone_number("12345678989").should_not be_nil
    end
  end
end

