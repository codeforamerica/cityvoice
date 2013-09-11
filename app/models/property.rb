class Property < Subject
  belongs_to :neighborhood
  has_one :property_info_set
  has_many :feedback_inputs
  has_many :notification_subscriptions
  attr_protected

  # called by feedback_inputs to indicate activity
  def new_activity!
    self.update_attributes(most_recent_activity: DateTime.now)
  end

  def recently_active?(since = 7.days.ago)
    return false if self.most_recent_activity.nil?
    since < self.most_recent_activity
  end

end
