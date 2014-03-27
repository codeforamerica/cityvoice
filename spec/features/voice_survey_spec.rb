require 'spec_helper'

describe "Voice Survey Interface" do
  before { pending }

  def hash_from_xml(nokogiri_doc)
    Hash.from_xml(nokogiri_doc.to_s)
  end

  describe "Property Survey" do
    before do
      ENV["SURVEY_NAME"] = "property"
      @property_code = "99999"
      Property.find_or_create_by(:property_code => @property_code)
    end

    describe "initial call" do
      before(:each) do
        post 'route_to_survey'
        @body_hash = hash_from_xml(response.body)
      end
      it "plays welcome message" do
        @body_hash["Response"]["Gather"]["Play"][0].should include("welcome.mp3")
        @body_hash["Response"]["Gather"]["Play"][1].should include("code_prompt.mp3")
      end
    end

    describe "property survey" do

      describe "Consent feature" do
        before(:each) do
          post 'route_to_survey', "To" => "+15745842979" #sign
          post 'route_to_survey', "Digits" => @property_code
          @body_hash = hash_from_xml(response.body)
        end
        it "redirects to consent url" do
          @body_hash["Response"]["Redirect"].should eq("consent")
        end
        describe "consent screen" do
          before do
            @caller_phone_number = "+16175551212"
          end
          before (:each) do
            post 'consent'
            @body_hash = hash_from_xml(response.body)
          end
          it "plays consent message" do
            @body_hash["Response"]["Gather"]["Play"].should include("consent.mp3")
          end
          it "sets started session var" do
            session[:consent_started].should be_true
          end
          describe "yes to callback" do
            before(:each) do
              post 'consent', { "Digits" => "1", "From" => @caller_phone_number }
              @body_hash = hash_from_xml(response.body)
            end
            it "creates a caller" do
              Caller.find_by_phone_number(@caller_phone_number).should_not be_nil
            end
            it "saves 'yes' consent" do
              Caller.find_by_phone_number(@caller_phone_number).consented_to_callback.should be_true
            end
            it "redirects to voice survey" do
              @body_hash["Response"]["Redirect"].should eq("voice_survey")
            end
          end
          describe "no to callback" do
            before(:each) do
              post 'consent', { "Digits" => "2", "From" => @caller_phone_number }
              @body_hash = hash_from_xml(response.body)
            end
            it "saves 'no' consent" do
              Caller.find_by_phone_number(@caller_phone_number).consented_to_callback.should be_false
            end
            it "redirects to voice survey" do
              @body_hash["Response"]["Redirect"].should eq("voice_survey")
            end
          end
          describe "bad input to callback" do
            before(:each) do
              post 'consent', { "Digits" => "0", "From" => @caller_phone_number }
              @body_hash = hash_from_xml(response.body)
            end
            it "redirects back to consent" do
              @body_hash["Response"]["Redirect"].should eq("consent")
            end
            it "sets session[:consent_attempts] to 1" do
              session[:consent_attempts].should eq(1)
            end
            describe "second bad input" do
              before(:each) do
                post 'consent', { "Digits" => "8", "From" => @caller_phone_number }
                @body_hash = hash_from_xml(response.body)
              end
              it "plays second error message" do
                @body_hash["Response"]["Play"].should include("error2.mp3")
              end
              it "hangs up" do
                @body_hash["Response"].keys.should include("Hangup")
              end
            end
          end
        end
      end

      describe "error handling on property input" do
        describe "first wrong property code" do
          before do
            post 'route_to_survey', "To" => "+15745842979" #sign
            post 'route_to_survey', "Digits" => "12345"
            @body_hash = hash_from_xml(response.body)
            @play_array = @body_hash["Response"]["Gather"]["Play"]
          end
          it "should be a bad property code" do
            Property.find_by_property_code("12345").should be_nil
          end
          it "plays first error message and reasks for property code" do
            @play_array[0].should include("error1.mp3")
            @play_array[1].should include("code_prompt.mp3")
          end
          it "should ask for 5 digits" do
            @body_hash["Response"]["Gather"]["numDigits"].should eq("5")
          end

          describe "second wrong property code" do
            before do
              post 'route_to_survey', "Digits" => "12346"
              @body_hash = hash_from_xml(response.body)
            end
            it "should be a bad property code" do
              Property.find_by_property_code("12346").should be_nil
            end
            it "should play second error message and hang up" do
              @body_hash["Response"]["Play"].should include("error2.mp3")
              @body_hash["Response"].keys.should include("Hangup")
            end
          end
        end
      end

      describe "Asking caller about listening to feedback" do
        before(:each) do
          post 'listen_to_messages_prompt'
          @body_hash = hash_from_xml(response.body)
        end
        it "prompts correctly" do
          @body_hash["Response"]["Gather"]["Play"].should include("listen_to_messages_prompt")
        end
        describe "caller wants to listen" do
          before(:each) do
            post 'listen_to_messages_prompt', { "Digits" => "1" }
            @body_hash = hash_from_xml(response.body)
          end
          it "redirects to check_for_messages" do
            @body_hash["Response"]["Redirect"].should eq("check_for_messages")
          end
        end
        describe "caller does NOT want to listen" do
          before(:each) do
            post 'listen_to_messages_prompt', { "Digits" => "2" }
            @body_hash = hash_from_xml(response.body)
          end
          it "redirects to voice_survey" do
            @body_hash["Response"]["Redirect"].should eq("voice_survey")
          end
        end
        describe "caller gives bad input" do
          # Pending
        end
      end

      describe "playback of existing messages" do
        describe "subject without feedback" do
          before do
            @subj_without_vmessages = Subject.create(:name => "Subject without Voice Messages")
            stub(:session => { :property_id => @subj_without_vmessages.id } )
            post 'check_for_messages'
            @hash_response = hash_from_xml(response.body)["Response"]
          end
          it "plays no_voice_feedback_yet message" do
            @hash_response["Play"].should include("no_feedback_yet.mp3")
          end
          it "redirects to voice_survey" do
            @hash_response["Redirect"].should eq("voice_survey")
          end
        end
        describe "subject WITH feedback" do
          before do
            @code_for_subject = "22222"
            @subj_with_vmessages = Subject.create(:name => "Subject with Voice Messages2", :property_code => @code_for_subject)
            FeedbackInput.create(property_id: @subj_with_vmessages.id, voice_file_url: "myurl1")
            FeedbackInput.create(property_id: @subj_with_vmessages.id, voice_file_url: "myurl2")
            FeedbackInput.create(property_id: @subj_with_vmessages.id, numerical_response: "1")
            post 'route_to_survey'
            post 'route_to_survey', "Digits" => @code_for_subject
            post 'check_for_messages'
            @hash_response = hash_from_xml(response.body)["Response"]
          end
=begin
          it "sets session var" do
            session[:property_id].should eq(@subj_with_vmessages.id)
          end
          it "counts 2 voice files" do
            @voice_message_count.should eq(2)
          end
=end
          it "redirects to message_playback" do
            @hash_response["Redirect"].should eq("message_playback")
          end
        end
      end

      describe "message_playback" do
        before do
          @code_for_playback_subject = "33333"
          @subj_with_vmessages_to_play = Subject.create(:name => "Subject with Voice Messages3", :property_code => @code_for_playback_subject)
          FeedbackInput.create(property_id: @subj_with_vmessages_to_play.id, voice_file_url: "myurl1")
          FeedbackInput.create(property_id: @subj_with_vmessages_to_play.id, voice_file_url: "myurl2")
          FeedbackInput.create(property_id: @subj_with_vmessages_to_play.id, numerical_response: "1")
          post 'route_to_survey'
          post 'route_to_survey', "Digits" => @code_for_playback_subject
          post 'check_for_messages'
          post 'message_playback'
          @hash_response = hash_from_xml(response.body)["Response"]
        end
        describe "first vmessage" do
          it "play the first voice message" do
            @hash_response["Gather"]["Play"][0].should eq("myurl1")
          end
          it "plays the prompt to listen to another message" do
            @hash_response["Gather"]["Play"][1].should include("listen_to_another.mp3")
          end
          it "gathers input for next step" do
            @hash_response["Gather"]["numDigits"].should eq("1")
          end
          it "plays the second voice message" do
            post 'message_playback', "Digits" => "1"
            @hash_response["Gather"]["Play"][0].should eq("myurl2")
            @hash_response["Gather"]["numDigits"].should eq("1")
          end
          it "plays the prompt about no more messages" do
            #@hash_response["Gather"]["Play"][1].should include("listen_to_another.mp3")
          end
          it "gathers input for next step" do
          end
        end
=begin
        describe "listening to second message" do
          before do
            @code_for_playback_subject = "33333"
            @subj_with_vmessages_to_play = Subject.create(:name => "Subject with Voice Messages3", :property_code => @code_for_playback_subject)
            FeedbackInput.create(property_id: @subj_with_vmessages_to_play.id, voice_file_url: "myurl1")
            FeedbackInput.create(property_id: @subj_with_vmessages_to_play.id, voice_file_url: "myurl2")
            FeedbackInput.create(property_id: @subj_with_vmessages_to_play.id, numerical_response: "1")
            post 'route_to_survey'
            post 'route_to_survey', "Digits" => @code_for_playback_subject
            post 'check_for_messages'
            post 'message_playback'
            @hash_response = hash_from_xml(response.body)["Response"]
            post 'message_playback', "Digits" => "1"
          end
            it "plays the second voice message" do
              @hash_response["Gather"]["Play"][0].should eq("myurl2")
            end
            it "plays the prompt about no more messages" do
              #@hash_response["Gather"]["Play"][1].should include("listen_to_another.mp3")
            end
            it "gathers input for next step" do
              @hash_response["Gather"]["numDigits"].should eq("1")
            end
        end
=end
      end

      before(:each) do
        post 'route_to_survey', "To" => "+15745842979" #sign
        post 'route_to_survey', "Digits" => @property_code
      end

      it "has the correct session survey" do
        session[:survey].should eq("property")
      end

      it "sets :property_id in session" do
        session[:property_id].should eq(Property.find_by_property_code(@property_code).id)
      end

      it "prompts with correct first question" do
        post 'voice_survey'
        @body_hash = hash_from_xml(response.body)
        @body_hash["Response"]["Gather"]["Play"].should include("property_outcome.mp3")
      end

      describe "bad input on numerical property question" do
        before(:each) do
          post 'voice_survey'
          @prop_outcome_question_id = session[:current_question_id]
          @first_body_hash = hash_from_xml(response.body)
        end
        it "reasks question if pound submitted" do
          post 'voice_survey', { "Digits" => "#" }
          @second_body_hash = hash_from_xml(response.body)
          session[:current_question_id].should eq(@prop_outcome_question_id)
          @first_body_hash.should eq(@second_body_hash)
        end

        describe "first wrong digit on question" do
          before(:each) do
            post 'voice_survey', { "Digits" => "0" }
            @body_hash = hash_from_xml(response.body)
          end
          it "gives error1 message if one bad input" do
            @play_array = @body_hash["Response"]["Gather"]["Play"]
            @play_array[0].should include("error1.mp3")
            @play_array[1].should include(Question.find(session[:current_question_id]).voice_file.url)
          end
          it "sets wrong_digit_entered in session" do
            session[:wrong_digit_entered].should_not be_nil
          end

          describe "second wrong digit on question" do
            it "plays error2 message and hangs up" do
              post 'voice_survey', { "Digits" => "8" }
              @body_hash = hash_from_xml(response.body)
              @body_hash["Response"]["Play"].should include("error2.mp3")
              @body_hash["Response"].keys.should include("Hangup")
            end
          end

        end
      end

      it "saves input for property_outcome question" do
        post 'voice_survey'
        @prop_outcome_question_id = session[:current_question_id]
        post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
        @input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @prop_outcome_question_id).first
        @input.numerical_response.should eq(1)
        @input.call_source.should eq("sign")
        FeedbackInput.where(:phone_number => "16175551212", :question_id => @prop_outcome_question_id, :property_id => session[:property_id]).count.should eq(1)
      end
      it "prompts with property voice question" do
        post 'voice_survey'
        post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
        @body_hash = hash_from_xml(response.body)
        @voice_file_name = VoiceFile.find_by_short_name(Question.find(session[:current_question_id]).short_name).url
        @body_hash["Response"]["Play"].should include(@voice_file_name)
      end
      it "saves property voice question correctly" do
        post 'voice_survey'
        post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
        @pcomment_question_id = session[:current_question_id]
        post 'voice_survey', { "RecordingUrl" => "https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3", "From" => "+16175551212" }
        @saved_input = FeedbackInput.where(:phone_number => "16175551212", :question_id => @pcomment_question_id, :neighborhood_id => session[:neighborhood_id]).first
        @saved_input.voice_file_url.should eq("https://s3-us-west-1.amazonaws.com/south-bend-secrets/121gigawatts.mp3")
        FeedbackInput.where(:phone_number => "16175551212", :question_id => @pcomment_question_id, :neighborhood_id => session[:neighborhood_id]).count.should eq(1)
      end
    end

    describe "medium parsing" do
      it "sets for flyers" do
        post 'route_to_survey', { "To" => "+15745842971" }
        session[:call_source].should eq("flyer")
      end
      it "sets for sign" do
        post 'route_to_survey', { "To" => "+15745842979" }
        session[:call_source].should eq("sign")
      end
      it "sets for web" do
        post 'route_to_survey', { "To" => "+15745842969" }
        session[:call_source].should eq("web")
      end
      it "sets for web" do
        post 'route_to_survey', { "To" => "+12223334444" }
        session[:call_source].should eq("error: from +12223334444")
      end

    end

  end


  # TODO put this test somewhere else
  # DG TODO Refactor this to not use property
=begin
  describe "notifications system" do
    it "updates most_recent_activity on property" do
      pending
      p = Property.where(:property_code => @property_code)[0]
      post 'route_to_survey', "To" => "+15745842979" #sign
      post 'route_to_survey', "Digits" => @property_code
      post 'voice_survey'
      post 'voice_survey', { "Digits" => "1", "From" => "+16175551212" }
      p = Property.where(:property_code => @property_code)[0]
      p.recently_active?.should eq(true)
    end
  end
=end
end

