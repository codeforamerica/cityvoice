class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :property

  after_create :send_notification_email

  def send_notification_email
    binding.pry
    # check if there are any subscribers
      # self.property.notification_subscribers.where(confirmed: true)
    # send an email to every subscriber where confirmed:true
  end

end
