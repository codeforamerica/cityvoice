class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :subject, foreign_key: :property_id

  belongs_to :question
  belongs_to :property
end
