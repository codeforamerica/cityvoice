class SubscriberNotifier < Struct.new(:subscriber)
  def self.send_weekly_notifications
    NotificationSubscription.confirmed.with_new_answers.pluck(:subscriber_id).uniq.each do |subscriber_id|
      new(Subscriber.find(subscriber_id)).deliver
    end
  end

  def deliver
    subscriber.notification_subscriptions.with_new_answers.each do |notification_subscription|
      notification_subscription.update_attribute(:last_email_sent_at, Time.zone.now)
    end
    NotificationMailer.weekly_activity(subscriber).deliver
  end
end
