class TextFeedbackController < ApplicationController

  @@app_url = "1000in1000.com"

  def handle_feedback 
    @feedback = FeedbackSms.new(params)
    if @feedback.valid?
      reply_text = "Thanks! We recorded your response '#{@feedback.choice_selected}' for property #{@feedback.address}. You can also text comments to this number. Learn more: #{@@app_url}/#{@feedback.property_number}" 
      session[:expect_comment] = true
      session[:current_prop_num] = @feedback.property_number
      session[:failed_once?] = false
    elsif session[:expect_comment]
      reply_text = "Thanks for your comments! Your feedback will be reviewed by city staff. Please tell your neighbors about this program. Visit #{@@app_url}/#{session[:current_prop_num]}"
    elsif session[:failed_once?]
      reply_text = "We're very sorry, but we still don't understand your response. Please visit 1000in1000.com or call 123-456-7890 to submit your feedback."
    else
      reply_text = "Sorry, we didn't understand your response. Please text back one of the exact choices on the sign, like '1234O' or '1234R'."
      session[:failed_once?] = true
    end
    render :inline => TextReply.new(reply_text).body
  end

end
