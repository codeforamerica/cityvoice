require 'spec_helper'

describe 'Exporting' do
  let(:export_data_path) { Rails.root.join('spec', 'support', 'fixtures', 'valid_export.csv') }
  let(:export_data) { File.read(export_data_path) }

  let(:location) { FactoryGirl.create(:location, name: 'El Farolito') }
  let(:call) { FactoryGirl.create(:call, id: 456, location: location) }

  let!(:numerical_question) {
    FactoryGirl.create(:question,
                       :numerical_response,
                       { question_text: 'Do you like tacos?' })
  }
  let!(:numerical_answer) {
    FactoryGirl.create(:answer,
                       :numerical_response,
                       question: numerical_question,
                       numerical_response: 1,
                       call: call)
  }

  let!(:voice_question) {
    FactoryGirl.create(:question,
                       :voice_file,
                       question_text: 'What about chimichangas?')
  }
  let!(:voice_answer) {
    FactoryGirl.create(:answer,
                       :voice_file,
                       question: voice_question,
                       voice_file_url: 'rant.mp3',
                       call: call)
  }

  it 'mentions the call id' do
    visit '/export.csv'
    expect(page).to have_content(export_data)
  end
end
