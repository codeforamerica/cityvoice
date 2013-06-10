class TextFeedbackController < ApplicationController

  @@code_hash = { "D" => "Demolish", "R" => "Rehab", "O" => "Other" }
  @@app_url = "1000in1000.com"

  def handle_feedback 
    @feedback = FeedbackSms.new(params)
    if session[:expect_comment]
      reply_text = "Thanks for your comment! City staff will review your feedback. Please tell your neighbors about this program."
    elsif @feedback.valid?
      reply_text = "Thanks! We recorded your response '#{@@code_hash[@feedback.text[4]]}' for #{@feedback.address}. Reply with your comments and visit #{@@app_url}/#{@feedback.text[0..3]} to learn more." 
      session[:expect_comment] = true
    elsif !session[:failed_once?]
      reply_text = "Sorry, we didn't understand your response. Please text back one of the exact choices on the sign, like '1234O' or '1234R'."
      session[:failed_once?] = true
    else
      reply_text = "We're very sorry, but we still don't understand your response. Please visit 1000in1000.com or call 123-456-7890 to submit your feedback."
    end
    render :inline => TextReply.new(reply_text).body
  end

end
