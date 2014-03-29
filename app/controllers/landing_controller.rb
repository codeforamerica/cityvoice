class LandingController < ApplicationController
  def location_search
    @most_recent_messages = Answer.includes(:location)
                                  .where.not(voice_file_url: nil)
                                  .order('created_at DESC')
                                  .limit(3)
  end
end
