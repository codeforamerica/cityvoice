class VoiceFeedbackController < ApplicationController
  include TwilioControllerUtility

  rescue_from TwilioSessionError, with: :handle_session_error

  def route_to_survey
    @call_in_code_digits = Rails.application.config.app_content_set.call_in_code_digits
    caller = Caller.find_or_create_by(phone_number: params['From'])
    if !session[:survey_started]
      session[:survey_started] = true
      render action: 'ask_for_code.xml.builder', layout: false
    else
      location = Location.find_by(id: params['Digits'])
      if location
        call = caller.calls.find_or_create_by(location_id: location.id, source: params['To'])
        session[:location_id] = location.id
        redirect_twilio_to listen_to_messages_prompt_path
      else
        if session[:attempts] == nil
          session[:attempts] = 1
          render action: 'ask_for_code.xml.builder', layout: false
        else
          raise TwilioSessionError.new(:error2)
        end
      end
    end
  end

  def listen_to_messages_prompt
    if !session[:listen_to_messages_started]
      session[:listen_to_messages_started] = true
      render action: 'ask_about_listening.xml.builder', layout: false
    else
      if ["1","2"].include?(params["Digits"])
        if params['Digits'] == '1'
          redirect_twilio_to check_for_messages_path
        else
          redirect_twilio_to consent_path
        end
      elsif session[:listen_attempts] == nil
        session[:listen_attempts] = 1
        render action: 'ask_about_listening.xml.builder', layout: false
      else
        raise TwilioSessionError.new(:error2)
      end
    end
  end

  def check_for_messages
    location = Location.find(session[:location_id])
    @voice_message_count = location.answers.where.not(voice_file_url: nil).count
    if @voice_message_count == 0
      render action: 'no_feedback.xml.builder', layout: false
    else
      redirect_twilio_to message_playback_path
    end
  end

  def message_playback
    location = Location.find(session[:location_id])

    if params["Digits"] == "2" or session[:end_of_messages]
      redirect_twilio_to consent_path
    else
      @voice_messages = location.answers.where.not(voice_file_url: nil).order('created_at ASC')
      if session[:current_message_index] == nil
        session[:current_message_index] = 0
      else
        session[:current_message_index] += 1
      end
      if @voice_messages[session[:current_message_index]]
        render action: 'message_playback.xml.builder', layout: false
      else # No voice messages left
        session[:end_of_messages] = true
        render action: 'last_message.xml.builder', layout: false
      end
    end
  end

  def consent
    caller = Caller.find_or_create_by(phone_number: params['From'])
    location = Location.find(session[:location_id])
    call = caller.calls.find_or_create_by(location_id: location.id, source: params['To'])

    if !session[:consent_started]
      session[:consent_started] = true
      render action: 'ask_for_consent.xml.builder', layout: false
    else
      if %w[1 2].include?(params["Digits"])
        session[:consent_attempts] = nil
        call.update_attribute(:consented_to_callback, params['Digits'] == '1')
        redirect_twilio_to voice_survey_path
      elsif session[:consent_attempts] == nil
        session[:consent_attempts] = 1
        render action: 'ask_for_consent.xml.builder', layout: false
      else
        raise TwilioSessionError.new(:error2)
      end
    end
  end

  def voice_survey
    caller = Caller.find_or_create_by(phone_number: params['From'])
    location = Location.find(session[:location_id])
    call = caller.calls.find_or_create_by(location: location, source: params['To'])

    # Set the index if none exists
    if session[:current_question_id] == nil
      @current_question = Survey.questions_for.first
      session[:current_question_id] = @current_question.id
    else
      # Process data for existing question
      @current_question = Question.find(session[:current_question_id])
      if @current_question.feedback_type == "numerical_response"
        if params["Digits"] == "#"
          return render action: 'ask_current_question.xml.builder', layout: false
        end
        if ["1","2"].include?(params["Digits"]) == false
          if session[:wrong_digit_entered] == nil
            session[:wrong_digit_entered] = true
            return render action: 'ask_current_question.xml.builder', layout: false
          else
            raise TwilioSessionError.new(:error2)
          end
        end
        call.answers.create!(question: @current_question, numerical_response: params["Digits"])
      elsif @current_question.feedback_type == "voice_file"
        call.answers.create!(question: @current_question, voice_file_url: params["RecordingUrl"])
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

    render action: 'ask_current_question.xml.builder', layout: false
  end
end
