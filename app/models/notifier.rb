class Notifier < Struct.new(:notification_subscription)
  def self.send_weekly_notifications
    NotificationSubscription.confirmed.with_new_answers.map { |s| new(s) }.each(&:deliver)
  end

  def deliver
    notification_subscription.override_last_email_sent_at_to!(Time.zone.now)
    NotificationMailer.weekly_activity2(email, [to_hash]).deliver
  end

  def to_hash
    {
      answers: notification_subscription.newest_answers,
      location: notification_subscription.location,
      unsubscribe_token: notification_subscription.auth_token,
    }
  end

  protected

  def email
    notification_subscription.email
  end
end
