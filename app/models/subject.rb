# == Schema Information
#
# Table name: subjects
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  neighborhood_id      :integer
#  type                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  property_code        :string(255)
#  parcel_id            :string(255)
#  lat                  :string(255)
#  long                 :string(255)
#  description          :text
#  most_recent_activity :datetime
#

class Subject < ActiveRecord::Base
  attr_protected
  validates :name, presence: true

  def property_code
    digits = content_set.call_in_code_digits.to_i
    self.id.to_s.rjust(digits, '0')
  end

  protected

  def content_set
    Rails.application.config.app_content_set
  end
end
