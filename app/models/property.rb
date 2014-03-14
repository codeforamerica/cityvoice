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

class Property < Subject
  has_one :property_info_set
  has_many :feedback_inputs
  has_many :notification_subscriptions

  attr_protected

  scope :activity_since, ->(time) { where("most_recent_activity >= ?", time) }

  # called by feedback_inputs to indicate activity
  def new_activity!
    update_attributes(most_recent_activity: DateTime.now)
  end

  def url_to
    name_link = self.name.gsub(' ', '-')
    path = "/subjects/#{name_link}"
  end
end
