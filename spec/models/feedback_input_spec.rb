# == Schema Information
#
# Table name: feedback_inputs
#
#  id                 :integer          not null, primary key
#  question_id        :integer
#  subject_id         :integer
#  neighborhood_id    :integer
#  property_id        :integer
#  voice_file_url     :string(255)
#  numerical_response :integer
#  phone_number       :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  call_source        :string(255)
#

require 'spec_helper'

describe FeedbackInput do
  it { should belong_to(:subject) }
  it { should belong_to(:property) }
  it { should belong_to(:question) }
end
