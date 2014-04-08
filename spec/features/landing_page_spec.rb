require 'spec_helper'

describe 'Landing page' do
  let!(:zomboland) { create(:location, name: 'Zomboland') }

  it 'shows the title of the page' do
    visit root_path
    page.should have_content 'To learn more about'
  end

  it 'loads the map markers from json' do
    visit '/locations.json'
    page.should have_text zomboland.lat
  end
end
