class Property < Subject
  belongs_to :neighborhood
  has_one :property_info_set
  attr_protected
end
