class NotificationMailer < ActionMailer::Base
  default from: "notifications@cityvoiceapp.com"
  include NotificationsMailerHelper
  helper :notifications_mailer

  def confirmation_email(notification_subscription)
    @token = notification_subscription.auth_token
    @property = notification_subscription.subject
    mail(to: notification_subscription.email, subject: 'Confirm to get notifications')
  end

  def weekly_activity2(email, properties_array)
    @properties_array = properties_array
    @unsubscribe_all_token = properties_array.last[:unsubscribe_token]
    mail(to: email, subject: 'New Activity on CityVoice!')
  end
end
