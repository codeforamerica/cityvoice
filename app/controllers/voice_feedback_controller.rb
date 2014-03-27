class VoiceFeedbackController < ApplicationController

  def route_to_survey
    @call_in_code_digits = Rails.application.config.app_content_set.call_in_code_digits
    if !session[:survey_started]
      session[:survey_started] = true
      session[:call_source] = call_source_from_twilio_phone_number(params["To"])
      response_xml = ask_for_code(first_time: true)
    else
      target_subject = Subject.find_by(id: params["Digits"])
      if target_subject
        session[:property_id] = target_subject.id
        response_xml = Twilio::TwiML::Response.new do |r|
          r.Redirect "listen_to_messages_prompt"
        end.text
      else
        if session[:attempts] == nil
          session[:attempts] = 1
          response_xml = ask_for_code(first_time: false)
        else
          response_xml = Twilio::TwiML::Response.new do |r|
            r.Play VoiceFile.find_by_short_name("error2").url
            r.Hangup
          end.text
        end
      end
    end
    puts response_xml
    render :inline => response_xml
  end

  def listen_to_messages_prompt
    if !session[:listen_to_messages_started]
      session[:listen_to_messages_started] = true
      response_xml = ask_about_listening
    else
      if ["1","2"].include?(params["Digits"])
        response_xml = Twilio::TwiML::Response.new do |r|
          if params["Digits"] == "1"
            r.Redirect "check_for_messages"
          else
            r.Redirect "consent"
          end
        end.text
      elsif session[:listen_attempts] == nil
        session[:listen_attempts] = 1
        response_xml = ask_about_listening(first_time: false)
      else
        response_xml = Twilio::TwiML::Response.new do |r|
          r.Play VoiceFile.find_by_short_name("error2").url
          r.Hangup
        end.text
      end
    end
    render :inline => response_xml
  end

  def check_for_messages
    @voice_message_count = FeedbackInput.where('property_id = ? and voice_file_url != ?', session[:property_id], "null").count
    if @voice_message_count == 0
      response_xml = Twilio::TwiML::Response.new do |r|
        r.Play VoiceFile.find_by_short_name("no_feedback_yet").url
        r.Redirect "consent"
      end.text
    else
      # Voice messages exist
      response_xml = Twilio::TwiML::Response.new do |r|
        r.Redirect "message_playback"
      end.text
    end
    render :inline => response_xml
  end

  def message_playback
    if params["Digits"] == "2" or session[:end_of_messages]
      response_xml = Twilio::TwiML::Response.new do |r|
        r.Redirect "consent"
      end.text
    else
      @voice_messages = FeedbackInput.where('property_id = ? and voice_file_url != ?', session[:property_id], "null").order('created_at ASC')
      if session[:current_message_index] == nil
        session[:current_message_index] = 0
      else
        session[:current_message_index] += 1
      end
      if @voice_messages[session[:current_message_index]]
        response_xml = Twilio::TwiML::Response.new do |r|
          r.Gather :timeout => 8, :numDigits => 1, :finishOnKey => '' do |g|
            # MP3 addition below necessary for redacted messages, though not Twilio messages
            r.Play @voice_messages[session[:current_message_index]].voice_file_url + ".mp3"
            r.Play VoiceFile.find_by_short_name("listen_to_another").url
          end
        end.text
      else # No voice messages left
        session[:end_of_messages] = true
        response_xml = Twilio::TwiML::Response.new do |r|
          r.Gather :timeout => 15, :numDigits => 1, :finishOnKey => '' do |g|
            r.Play VoiceFile.find_by_short_name("last_message_reached").url
          end
        end.text
      end
    end
    render :inline => response_xml
  end

  def consent
    if !session[:consent_started]
      session[:consent_started] = true
      response_xml = ask_for_consent
    else
      if ["1","2"].include?(params["Digits"])
        session[:consent_attempts] = nil
        @caller = Caller.find_or_create_by(:phone_number => params["From"])
        if params["Digits"] == "1"
          @caller.update_attribute(:consented_to_callback, true)
        else
          @caller.update_attribute(:consented_to_callback, false)
        end
        response_xml = Twilio::TwiML::Response.new do |r|
          r.Redirect "voice_survey"
        end.text
      elsif session[:consent_attempts] == nil
        session[:consent_attempts] = 1
        response_xml = ask_for_consent(first_time: false)
      else
        response_xml = Twilio::TwiML::Response.new do |r|
          r.Play VoiceFile.find_by_short_name("error2").url
          r.Hangup
        end.text
      end
    end
    render :inline => response_xml
  end

  def voice_survey
    puts params
    # Set the index if none exists
    if session[:current_question_id] == nil
      p "session[:survey] => #{session[:survey]}"
      p "Survey.questions_for it => #{Survey.questions_for}"
      @current_question = Survey.questions_for.first
      session[:current_question_id] = @current_question.id
    else
      # Process data for existing question
      @current_question = Question.find(session[:current_question_id])
      if @current_question.feedback_type == "numerical_response"
        if params["Digits"] == "#"
          return render :inline => twiml_for_reasking_current_question
        end
        if ["1","2"].include?(params["Digits"]) == false
          if session[:wrong_digit_entered] == nil
            session[:wrong_digit_entered] = true
            return render :inline => twiml_for_reasking_current_question
          else
            error_and_hangup_xml = Twilio::TwiML::Response.new do |r|
              r.Play VoiceFile.find_by_short_name("error2").url
              r.Hangup
            end.text
            return render :inline => error_and_hangup_xml
          end
        end
        FeedbackInput.create!(question_id: @current_question.id, neighborhood_id: session[:neighborhood_id], :property_id => session[:property_id], numerical_response: params["Digits"], phone_number: params["From"][1..-1].to_i, call_source: session[:call_source])
      elsif @current_question.feedback_type == "voice_file"
        FeedbackInput.create!(question_id: @current_question.id, neighborhood_id: session[:neighborhood_id], :property_id => session[:property_id], voice_file_url: params["RecordingUrl"], phone_number: params["From"][1..-1].to_i, call_source: session[:call_source])
      end
      # Then iterate counter
      current_index = Survey.questions_for.index { |q| q.short_name == @current_question.short_name }
      @current_question = Survey.questions_for[current_index+1]
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
          r.Gather :timeout => 10, :numDigits => 1, :finishOnKey => '' do |g|
            r.Play @current_question.voice_file.url
          end
        else
          # Handle the voice recording here
          r.Play @current_question.voice_file.url
          r.Record :maxLength => 60
        end
      end
    end.text
    puts @response_xml
    render :inline => @response_xml
  end

  def twiml_for_reasking_current_question
    @response_xml = Twilio::TwiML::Response.new do |r|
      if @hang_up
        #r.Say "Thank you very much for your feedback. Good bye."
        r.Play VoiceFile.find_by_short_name("thanks").url
        r.Hangup
      else
        if @current_question.feedback_type == "numerical_response"
          r.Gather :timeout => 10, :numDigits => 1, :finishOnKey => '' do |g|
            r.Play VoiceFile.find_by_short_name("error1").url if session[:wrong_digit_entered]
            r.Play @current_question.voice_file.url
          end
        else
          # Handle the voice recording here
          r.Play @current_question.voice_file.url
          r.Record :maxLength => 60
        end
      end
    end.text
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

  def ask_for_code(first_time: true)
    Twilio::TwiML::Response.new do |r|
      r.Gather :timeout => 15, :numDigits => @call_in_code_digits, :finishOnKey => '' do |g|
        if first_time
          g.Play VoiceFile.find_by_short_name("welcome").url
        else
          g.Play VoiceFile.find_by_short_name("error1").url
        end
        g.Play VoiceFile.find_by_short_name("code_prompt").url
      end
      r.Redirect "route_to_survey"
    end.text
  end

  def ask_about_listening(first_time: true)
    Twilio::TwiML::Response.new do |r|
      r.Gather :timeout => 15, :numDigits => 1, :finishOnKey => '' do |g|
        g.Play VoiceFile.find_by_short_name("error1").url unless first_time
        g.Play VoiceFile.find_by_short_name("listen_to_messages_prompt").url
      end
      r.Redirect "listen_to_messages_prompt"
    end.text
  end

  def ask_for_consent(first_time: true)
    Twilio::TwiML::Response.new do |r|
      r.Gather :timeout => 15, :numDigits => 1, :finishOnKey => '' do |g|
        g.Play VoiceFile.find_by_short_name("error1").url unless first_time
        g.Play VoiceFile.find_by_short_name("consent").url
      end
      r.Redirect "consent"
    end.text
  end

end
