class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :property

  after_create :send_notification_email
  #  -- or --
  after_create :update_property

  def send_notification_email
    # TODO - Mike
    # find confirmed subscribers to this property:
    # self.property.notification_subscriptions.where(confirmed: true)

    # send email to all of them
  end

  def update_property
    self.property.new_activity!
  end


end
