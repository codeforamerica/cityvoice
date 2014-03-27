require 'spec_helper'

describe 'Listening to messages' do
  let(:create_date) { Time.now }
  let(:property) { create(:property, :with_info_set, name: '1313 Mockingbird Lane') }
  let!(:feedback_input) { create(:feedback_input, :with_voice_file, property: property, created_at: create_date) }

  context 'on the landing page' do
    before do
      visit '/'
    end

    it 'shows location of the subject' do
      expect(page).to have_content('1313 Mockingbird Lane')
    end

    it 'shows the date the call was made' do
      expect(page).to have_content(create_date.strftime('%Y-%m-%d'))
    end

    it 'displays audio player' do
      expect(page).to have_selector('audio')
    end

    it 'has the feedback input audio file' do
      expect(page).to have_selector(%|source[src='#{feedback_input.voice_file_url}.mp3']|)
    end
  end

  context 'on a subject page' do
    before do
      visit subject_path('1313-Mockingbird-Lane')
    end

    it 'shows the date the call was made' do
      expect(page).to have_content(create_date.strftime('%Y-%m-%d'))
    end

    it 'shows the masked number from which the call was made' do
      expect(page).to have_content('XXX-XXX-1212')
    end

    it 'displays audio player' do
      expect(page).to have_selector('audio')
    end

    it 'has the feedback input audio file' do
      expect(page).to have_selector(%|source[src='#{feedback_input.voice_file_url}.mp3']|)
    end

    context 'when the user has not consented to publicly display their number' do
      let!(:feedback_input) { create(:feedback_input, :with_voice_file, phone_number: nil, property: property, created_at: create_date) }

      it 'does not display a number' do
        expect(page).not_to have_content('XXX-XXX-')
      end
    end
  end
end
