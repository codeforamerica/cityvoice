class TextFeedbackController < ApplicationController

  @@code_hash = { "A" => "Demolish", "B" => "Rehab", "C" => "Other" }
  @@app_url = "1000in1000.com"

  def handle_feedback 
    @feedback = FeedbackSms.new(params)
    reply_text = "Thanks! We recorded your response '#{@@code_hash[@feedback.text[4]]}' for the property at #{@feedback.address}. Visit #{@@app_url}/#{@feedback.text[0..3]} to see what other people had to say."
    render :inline => TextReply.new(reply_text).body
  end

end
