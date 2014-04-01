class SubscriptionConfirmer < Struct.new(:subscriber, :location)
  def confirm
    location_subscription.update_attribute(:confirmation_sent_at, Time.zone.now)
    confirmation_email.deliver
  end

  def location_subscription
    @location_subscription ||= subscriber.location_subscriptions.create!(location: location)
  end

  protected

  def confirmation_email
    @confirmation_email ||= NotificationMailer.confirmation_email(location_subscription)
  end
end
