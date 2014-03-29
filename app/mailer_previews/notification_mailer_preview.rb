class NotificationMailerPreview
  def confirmation_email
    NotificationMailer.confirmation_email notification_subscription
  end


  def weekly_activity2
    NotificationMailer.weekly_activity2 email, properties_array
  end

  private

  def notification_subscription
    FactoryGirl.create(:notification_subscription)
  end

  def email
    Faker::Internet.email
  end

  def properties_array
    notification_hash = Notifier.new(notification_subscription).to_hash
    [notification_hash, notification_hash]
  end
end
