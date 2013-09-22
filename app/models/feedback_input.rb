class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :subject, :foreign_key => "property_id"
end
