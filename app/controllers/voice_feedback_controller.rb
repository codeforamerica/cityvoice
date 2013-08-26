class VoiceFeedbackController < ApplicationController

  #@@app_url = "1000in1000.com"

  def route_to_survey
    if !session[:survey_started]
    #if !params.has_key?("Digits") 
      session[:survey_started] = true
      session[:call_source] = call_source_from_twilio_phone_number(params["To"])
      response_xml = Twilio::TwiML::Response.new do |r| 
        r.Gather :timeout => 15, :numDigits => 5, :finishOnKey => '' do |g|
          g.Play VoiceFile.find_by_short_name("welcome_property").url
        end
        r.Redirect "route_to_survey"
      end.text
    # Eventually replace below with lookup and validation of property code
    else
      if params["Digits"].to_s.length == 5
        session[:property_id] = Property.find_by_property_code(params["Digits"]).id
        session[:survey] = "property"
      else
        # Need to change this: remove neighborhood survey and just ask for valid property code
        #session[:survey] = "neighborhood"
      end
      # Hard code neighborhood ID for now
      session[:neighborhood_id] = 1
      response_xml = Twilio::TwiML::Response.new do |r| 
        r.Redirect "voice_survey"
      end.text
    end
    render :inline => response_xml
  end

  def voice_survey
    # Set the index if none exists
    if session[:current_question_id] == nil
      @current_question = Question.find_by_short_name(Survey.questions_for(session[:survey])[0])
      session[:current_question_id] = @current_question.id
    else
      # Process data for existing question 
      @current_question = Question.find(session[:current_question_id])
      if @current_question.feedback_type == "numerical_response"
        FeedbackInput.create!(question_id: @current_question.id, neighborhood_id: session[:neighborhood_id], :property_id => session[:property_id], numerical_response: params["Digits"], phone_number: params["From"][1..-1].to_i, call_source: session[:call_source])
      elsif @current_question.feedback_type == "voice_file"
        FeedbackInput.create!(question_id: @current_question.id, neighborhood_id: session[:neighborhood_id], :property_id => session[:property_id], voice_file_url: params["RecordingUrl"], phone_number: params["From"][1..-1].to_i, call_source: session[:call_source])
      end
      # Then iterate counter
      current_index = Survey.questions_for(session[:survey]).index(@current_question.short_name)
      @current_question = Question.find_by_short_name(Survey.questions_for(session[:survey])[current_index+1])
      # If there remains a question
      if @current_question
        session[:current_question_id] = @current_question.id
      else
        @hang_up = true
      end
    end

    @response_xml = Twilio::TwiML::Response.new do |r| 
      if @hang_up
        #r.Say "Thank you very much for your feedback. Good bye."
        r.Play VoiceFile.find_by_short_name("thanks").url
        r.Hangup
      else
        if @current_question.feedback_type == "numerical_response"
          r.Gather :timeout => 10, :numDigits => 1 do |g|
            #r.Say @current_question.voice_text 
            r.Play @current_question.voice_file.url
          end
        else
          # Handle the voice recording here
          #r.Say @current_question.voice_text 
          r.Play @current_question.voice_file.url
          r.Record :maxLength => 60
        end
      end
    end.text
    render :inline => @response_xml
  end


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
  private
  def call_source_from_twilio_phone_number(twilio_number)
    case twilio_number
    when "+15745842971"
      return "flyer"
    when "+15745842979"
      return "sign"
    when "+15745842969"
      return "web"
    else
      return "error: from #{twilio_number}"
    end
  end

end
