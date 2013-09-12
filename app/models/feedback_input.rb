class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :property

  after_create :update_property

  def update_property
    self.property.new_activity!
  end


end
