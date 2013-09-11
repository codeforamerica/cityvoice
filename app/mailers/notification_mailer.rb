class NotificationMailer < ActionMailer::Base
  default from: "notifications@cityvoice.com"

  def confirmation_email(notification_subscriber)
    @property = notification_subscriber.property
    mail(to: notification_subscriber.email, subject: 'Confirm to get notifications')
  end

end
