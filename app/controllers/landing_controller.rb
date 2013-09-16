class LandingController < ApplicationController
  def location_search
    @content = AppContentSet.first
    @most_recent_messages = FeedbackInput.includes(:property).where.not(:voice_file_url => nil).order("created_at DESC").limit(3)
  end
end
