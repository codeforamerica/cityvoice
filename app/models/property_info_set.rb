# == Schema Information
#
# Table name: property_info_sets
#
#  id                      :integer          not null, primary key
#  property_id             :integer
#  condition_code          :integer
#  condition               :string(255)
#  estimated_cost_exterior :string(255)
#  estimated_cost_interior :string(255)
#  demo_order              :string(255)
#  recommendation          :string(255)
#  outcome                 :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  lat                     :string(255)
#  long                    :string(255)
#

class PropertyInfoSet < ActiveRecord::Base
  attr_protected
end
