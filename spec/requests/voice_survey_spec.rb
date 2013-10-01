require 'spec_helper'

describe "Voice Survey Interface" do

  def hash_from_xml(nokogiri_doc)
    Hash.from_xml(nokogiri_doc.to_s)
  end

  describe "Property Survey" do
    before(:all) do
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

      describe "phone number" do
        before(:each) do
          post 'route_to_survey', "To" => "+15745842979" #sign
          post 'route_to_survey', "Digits" => @property_code
          @body_hash = hash_from_xml(response.body)
        end
        it "redirects to consent url" do
          @body_hash["Response"]["Redirect"].should eq("consent")
        end
        describe "consent screen" do
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
              post 'consent', { "Digits" => "1" }
              @body_hash = hash_from_xml(response.body)
            end
            it "redirects to voice survey" do
              @body_hash["Response"]["Redirect"].should eq("voice_survey")
            end
          end
        end
=begin
        it "redirects to voice survey" do
          pending
        end
=end
      end

      describe "error handling on property input" do

        describe "first wrong property code" do
          before(:all) do
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
            before(:all) do
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

