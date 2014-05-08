require 'spec_helper'

describe 'Listening to messages' do
  let(:create_date) { Time.zone.now }
  let(:location) { create(:location, name: '1313 Mockingbird Lane') }
  let(:caller) { create(:caller, phone_number: '+14155551212') }
  let(:call) { create(:call, location: location, caller: caller, consented_to_callback: true) }
  let!(:answer) { create(:answer, :voice_file, call: call, created_at: create_date) }
  let(:number_question) { create(:question, :numerical_response) }
  before { create(:answer, numerical_response: '1', question: number_question, call: call, created_at: create_date) }

  context 'on the landing page' do
    before do
      visit '/'
    end

    it 'shows name of the location' do
      expect(page).to have_content('1313 Mockingbird Lane')
    end

    it 'shows the date the call was made' do
      expect(page).to have_content(create_date.to_formatted_s(:year_month_date))
    end

    it 'displays audio player' do
      expect(page).to have_selector('audio')
    end

    it 'has the feedback input audio file' do
      expect(page).to have_selector(%|source[src='#{answer.voice_file_url}.mp3']|)
    end
  end

  context 'on a location page' do
    before do
      visit location_path('1313-Mockingbird-Lane')
    end

    it 'shows the date the call was made' do
      expect(page).to have_content(create_date.to_formatted_s(:year_month_date))
    end

    it 'shows the masked number from which the call was made' do
      expect(page).to have_content('XXX-XX12')
    end

    it 'displays audio player' do
      expect(page).to have_selector('audio')
    end

    it 'has the feedback input audio file' do
      expect(page).to have_selector(%|source[src='#{answer.voice_file_url}.mp3']|)
    end

    context 'when the user has not consented to publicly display their number' do
      let(:call) { create(:call, caller: caller, location: location, consented_to_callback: false) }
      let!(:answer) { create(:answer, :voice_file, call: call, created_at: create_date) }

      it 'does not display a number' do
        expect(page).not_to have_content('XXX-XX12')
      end
    end

    it 'lets the user subscribe to updates' do
      fill_in 'subscription_email', with: 'tacos@example.com'
      click_button 'Subscribe'
      expect(page).to have_content('You just subscribed')
    end
  end

  context 'on the activity page' do
    before do
      visit numerical_answers_path
    end

    it 'shows name of the location' do
      expect(page).to have_content('1313 Mockingbird Lane')
    end

    it 'shows the total number of votes' do
      expect(page).to have_content('1')
    end

    it 'shows the number of repair votes' do
      expect(page).to have_content('Repair 1')
    end

    it 'shows the number of remove votes' do
      expect(page).to have_content('Remove 0')
    end
  end

  context 'on the voice message summary page' do
    before do
      visit voice_answers_path
    end

    it 'shows name of the location' do
      expect(page).to have_content('1313 Mockingbird Lane')
    end

    it 'shows the date the call was made' do
      expect(page).to have_content(create_date.to_formatted_s(:year_month_date))
    end

    it 'displays audio player' do
      expect(page).to have_selector('audio')
    end

    it 'has the feedback input audio file' do
      expect(page).to have_selector(%|source[src='#{answer.voice_file_url}.mp3']|)
    end

    it 'shows the masked number from which the call was made' do
      expect(page).to have_content('XXX-XX12')
    end

    context 'when the user has not consented to publicly display their number' do
      let(:call) { create(:call, caller: caller, location: location, consented_to_callback: false) }
      let!(:answer) { create(:answer, :voice_file, call: call, created_at: create_date) }

      it 'does display a number' do
        expect(page).to have_content('XXX-XX12')
      end
    end
  end
end
