class SubscriptionConfirmer < Struct.new(:subscriber, :location)
  def confirm
    notification_subscription.update_attribute(:confirmation_sent_at, Time.zone.now)
    confirmation_email.deliver
  end

  def notification_subscription
    @notification_subscription ||= subscriber.notification_subscriptions.create!(location: location)
  end

  protected

  def confirmation_email
    @confirmation_email ||= NotificationMailer.confirmation_email(notification_subscription)
  end
end
