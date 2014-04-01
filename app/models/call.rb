# == Schema Information
#
# Table name: calls
#
#  id                    :integer          not null, primary key
#  caller_id             :integer
#  location_id           :integer
#  consented_to_callback :boolean
#  source                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Call < ActiveRecord::Base
  belongs_to :location
  belongs_to :caller

  attr_accessible :caller, :location, :consented_to_callback, :source
end
