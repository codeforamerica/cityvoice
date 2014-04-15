# == Schema Information
#
# Table name: callers
#
#  id           :integer          not null, primary key
#  phone_number :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Caller < ActiveRecord::Base
  has_many :calls

  attr_accessible :phone_number, :consented_to_callback
end
