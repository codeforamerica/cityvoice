class VoiceFeedbackController < ApplicationController
  include TwilioControllerUtility

  rescue_from TwilioSessionError, with: :handle_session_error

  CALL_SOURCES = {
    '+15745842971' => 'flyer',
    '+15745842979' => 'sign',
    '+15745842969' => 'web',
  }

  def route_to_survey
    @call_in_code_digits = Rails.application.config.app_content_set.call_in_code_digits
    if !session[:survey_started]
      session[:survey_started] = true
      session[:call_source] = CALL_SOURCES[params["To"]] || "error: from #{params['To']}"
      render action: 'ask_for_code.xml.builder', layout: false
    else
      target_subject = Subject.find_by(id: params["Digits"])
      if target_subject
        session[:property_id] = target_subject.id
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
    subject = Subject.find(session[:property_id])
    @voice_message_count = subject.feedback_inputs.where.not(voice_file_url: nil).count
    if @voice_message_count == 0
      render action: 'no_feedback.xml.builder', layout: false
    else
      redirect_twilio_to message_playback_path
    end
  end

  def message_playback
    if params["Digits"] == "2" or session[:end_of_messages]
      redirect_twilio_to consent_path
    else
      subject = Subject.find(session[:property_id])
      @voice_messages = subject.feedback_inputs.where.not(voice_file_url: nil).order('created_at ASC')
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
    if !session[:consent_started]
      session[:consent_started] = true
      render action: 'ask_for_consent.xml.builder', layout: false
    else
      if ["1","2"].include?(params["Digits"])
        session[:consent_attempts] = nil
        @caller = Caller.find_or_create_by(:phone_number => params["From"])
        if params["Digits"] == "1"
          @caller.update_attribute(:consented_to_callback, true)
        else
          @caller.update_attribute(:consented_to_callback, false)
        end
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
    # Set the index if none exists
    if session[:current_question_id] == nil
      @current_question = Survey.questions_for.first
      session[:current_question_id] = @current_question.id
    else
      # Process data for existing question
      @current_question = Question.find(session[:current_question_id])
      subject = Subject.find(session[:property_id])
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
        subject.feedback_inputs.create!(question_id: @current_question.id, numerical_response: params["Digits"], phone_number: params["From"][1..-1].to_i, call_source: session[:call_source])
      elsif @current_question.feedback_type == "voice_file"
        subject.feedback_inputs.create!(question_id: @current_question.id, voice_file_url: params["RecordingUrl"], phone_number: params["From"][1..-1].to_i, call_source: session[:call_source])
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
