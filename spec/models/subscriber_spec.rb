# == Schema Information
#
# Table name: subscribers
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Subscriber do
  it { should have_many(:location_subscriptions) }

  it { should allow_mass_assignment_of(:email) }

  it { should allow_value('user@example.com', 'us.er@example.com', 'user+plus@example.com').for(:email) }
  it { should_not allow_value('wat').for(:email) }

  it 'validates the uniqueness of the email' do
    create(:subscriber, email: 'tacos@example.com')

    expect {
      create(:subscriber, email: 'tacos@example.com')
    }.to raise_error
  end
end
