class VoiceFeedbackController < ApplicationController

  @@app_url = "1000in1000.com"

  def splash_message 
    response_xml = Twilio::TwiML::Response.new do |r| 
      r.Say "Welcome to Auto Midnight, brought to you by Hot Snakes and Swami Records."
      r.Say "Please enter a property code, and then press the pound sign."
      r.Gather :action => "respond_to_property_code", :timeout => 10, :numdigits => 4
    end.text
    render :inline => response_xml
  end

  def respond_to_property_code
    session[:property_code] = params["Digits"]
    # Below will be replaced with property lookup
    @property_name = "1234 Fake Street"
    response_xml = Twilio::TwiML::Response.new do |r| 
      r.Say "You have entered the property at #{@property_name}."
      r.Say "What would you like to happen at this property?"
      r.Say "Press 1 for repair, 2 for remove, 3 for other. Then hit the pound sign."
      r.Gather :action => "solicit_comment", :timeout => 5, :numdigits => 1
    end.text
    render :inline => response_xml
  end

  def solicit_comment
    session[:outcome_code] = params["Digits"]
    # Abstract below out, and use in above controller method as well
    @outcome_hash = { "1" => "repair", "2" => "remove", "3" => "other" }
    # Replace with actual input cod
    @outcome_selected = @outcome_hash[params["Digits"]]
    response_xml = Twilio::TwiML::Response.new do |r| 
      r.Say "You chose #{@outcome_selected}. Please leave a voice message with your comments about this choice. You will have a one minute limit."
      # Modify below to pass to appropriate Feedback creator
      r.Record :transcribeCallback => '/voice_transcriptions', :timeout => 5
    end.text
    render :inline => response_xml
  end

=begin
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
=end

end
