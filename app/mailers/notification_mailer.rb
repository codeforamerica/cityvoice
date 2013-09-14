class NotificationMailer < ActionMailer::Base
  default from: "notifications@cityvoice.com"
  include NotificationsMailerHelper
  helper :notifications_mailer

  def confirmation_email(notification_subscription)
    @token = notification_subscription.auth_token
    @property = notification_subscription.property
    mail(to: notification_subscription.email, subject: 'Confirm to get notifications')
  end

  def weekly_activity(notification_subscription)
    @property = notification_subscription.property
    mail(to: notification_subscription.email, subject: 'Weekly Activity')
  end

  # properties array: [{property: property_object, unsubscribe_token: '23423jfsdf', activity: [feedback_input1, feedback_input2]}]
  def weekly_activity2(email, properties_array)
    @properties_array = properties_array
    @unsubscribe_all_token = properties_array.last[:unsubscribe_token]
    mail(to: email, subject: 'Weekly Activity')
  end

end
