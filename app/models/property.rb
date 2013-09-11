class Property < Subject
  belongs_to :neighborhood
  has_one :property_info_set
  has_many :notification_subscribers
  attr_protected
end
