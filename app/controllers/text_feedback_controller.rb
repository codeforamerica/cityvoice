class TextFeedbackController < ApplicationController

  @@code_hash = { "A" => "Demolish", "B" => "Rehab", "C" => "Other" }
  @@app_url = "www.FeedbackApp.com"

  def reply 
    #binding.pry
    text_body = params["Body"]
    reply_text = "Thanks! You have selected #{text_body[5]} - #{@@code_hash[text_body[5]]} for property #{text_body[0..3]}. You can see responses and learn more at #{@@app_url}."
    render :inline => TextReply.new(reply_text).body
  end

end
