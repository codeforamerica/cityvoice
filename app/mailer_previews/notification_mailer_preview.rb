class NotificationMailerPreview
  def confirmation_email
    NotificationMailer.confirmation_email(location_subscription)
  end

  def weekly_activity
    NotificationMailer.weekly_activity(subscriber)
  end

  private

  def location_subscription
    FactoryGirl.create(:location_subscription)
  end

  def subscriber
    subscriber = FactoryGirl.create(:subscriber)
    FactoryGirl.create(:location_subscription, subscriber: subscriber)
    FactoryGirl.create(:location_subscription, subscriber: subscriber)
    subscriber
  end
end
