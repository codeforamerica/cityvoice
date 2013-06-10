class TextFeedbackController < ApplicationController

  @@code_hash = { "D" => "Demolish", "R" => "Rehab", "O" => "Other" }
  @@app_url = "1000in1000.com"

  def handle_feedback 
    @feedback = FeedbackSms.new(params)
    if @feedback.valid?
      reply_text = "Thanks! We recorded your response '#{@@code_hash[@feedback.text[4]]}' for #{@feedback.address}. Visit #{@@app_url}/#{@feedback.text[0..3]} to see what other people had to say."
    else
      reply_text = "Sorry, we didn't understand your response. Please text back one of the exact choices on the sign, like '1234O' or '1234R'."
    end
    render :inline => TextReply.new(reply_text).body
  end

end
