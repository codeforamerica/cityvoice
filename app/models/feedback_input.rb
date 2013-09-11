class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :property

  after_create :send_notification_email

  def send_notification_email
    puts "Hey!"
    binding.pry
  end

end
