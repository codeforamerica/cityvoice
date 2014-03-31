class NotificationMailer < ActionMailer::Base
  default from: "notifications@cityvoiceapp.com"
  include NotificationsMailerHelper
  helper :notifications_mailer

  def confirmation_email(location_subscription)
    @location_subscription = location_subscription
    mail(to: location_subscription.subscriber.email, subject: 'Confirm to get notifications')
  end

  def weekly_activity(subscriber)
    @subscriber = subscriber
    @unsubscribe_all_token = subscriber.location_subscriptions.first.auth_token
    mail(to: subscriber.email, subject: 'New Activity on CityVoice!')
  end
end
