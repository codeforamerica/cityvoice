require 'spec_helper'

describe 'Voice Answers page' do
  let!(:breadland) { create(:location, name: 'Breadland') }
  let!(:toast_question) { create(:question, question_text: 'How was your toast?') }
  let!(:prank_call) { create(:call, source: '+15551234455', location: breadland) }
  let!(:voice_answer) { create(:answer, :voice_file, call: prank_call, question: toast_question) }

  describe 'voice answers' do
    before do
      visit '/voice_answers'
    end

    it 'shows the location of a voice answer' do
      page.should have_content 'Breadland'
    end

    it 'shows the question text' do
      page.should have_content 'How was your toast?'
    end
  end

  describe 'numerical answers' do
    let!(:soupville) { create(:location, name: 'Soupville') }
    let!(:great_call) { create(:call, location: soupville) }
    let!(:numerical_answer) { create(:answer, :numerical_response, call: great_call) }

    it 'only shows voice answers' do
      visit '/voice_answers'
      page.should_not have_content 'Soupville'
      page.should have_content 'Breadland'
    end
  end
end
