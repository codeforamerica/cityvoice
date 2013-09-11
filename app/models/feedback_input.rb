class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :property

  after_create :send_notification_email
  #  -- or --
  after_create :add_to_notification_que

  def send_notification_email
    # TODO - Mike
    binding.pry
    # find confirmed subscribers to this property:
    # self.property.notification_subscribers.where(confirmed: true)

    # send email to all of them
  end



end
