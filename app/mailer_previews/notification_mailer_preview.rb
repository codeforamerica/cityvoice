class NotificationMailerPreview
  def confirmation_email
    NotificationMailer.confirmation_email(notification_subscription)
  end

  def weekly_activity
    NotificationMailer.weekly_activity(subscriber)
  end

  private

  def notification_subscription
    FactoryGirl.create(:notification_subscription)
  end

  def subscriber
    subscriber = FactoryGirl.create(:subscriber)
    FactoryGirl.create(:notification_subscription, subscriber: subscriber)
    FactoryGirl.create(:notification_subscription, subscriber: subscriber)
    subscriber
  end
end
