require 'spec_helper'

describe 'Landing page' do
  it 'shows the title of the page' do
    visit root_path
    page.should have_content 'To learn more about'
  end
end
