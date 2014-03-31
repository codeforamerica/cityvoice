class NotificationMailer < ActionMailer::Base
  default from: "notifications@cityvoiceapp.com"
  include NotificationsMailerHelper
  helper :notifications_mailer

  def confirmation_email(notification_subscription)
    @notification_subscription = notification_subscription
    mail(to: notification_subscription.subscriber.email, subject: 'Confirm to get notifications')
  end

  def weekly_activity(subscriber)
    @subscriber = subscriber
    @unsubscribe_all_token = subscriber.notification_subscriptions.first.auth_token
    mail(to: subscriber.email, subject: 'New Activity on CityVoice!')
  end
end
