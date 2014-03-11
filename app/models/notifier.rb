# Logic for DB roundup queries & email sending
class Notifier

  # Construct a hash of the form:
  # {
  #   mike@gmail.com:
  #    {
  #      properties: [{property: <Property>, feedback_inputs: [<FeedbackInput>, <FeedbackInput>, ...], unsubscribe_token: 'nf897e623'}, {...}]
  #    },
  #   another@email.com: {...}
  # }
  def self.send_weekly_notifications
    puts 'Start of notifier method'

    subs = self.subscription_with_activity_since_last_email_sent

    emails_hash = self.build_hash_for_mailer(subs)

    self.deliver_emails(emails_hash)
  end

  # Get the NotificationSubscriptions which have had activity since last notification email was sent
  def self.subscription_with_activity_since_last_email_sent
    NotificationSubscription.includes(property: :feedback_inputs)
                            .where("confirmed = ? or bulk_added = ?", true, true)
                            .where('feedback_inputs.created_at >= notification_subscriptions.last_email_sent_at')
                            .references(:feedback_inputs)
  end

  # Group all the <NotificationSubscription>'s by email
  def self.build_hash_for_mailer(subs)
    result = Hash.new { |hash, k| hash[k] = {} }
    result.tap do |result|
      subs.each do |sub|
        email    = sub.email
        property = sub.property

        result[email][:properties] ||= []
        result[email][:properties] << {
          property: property,
          unsubscribe_token: sub.auth_token,
          feedback_inputs: property.feedback_inputs.where('created_at >= ?', sub.last_email_sent_at)
        }
        sub.update_attributes(last_email_sent_at: DateTime.now)
      end
    end
  end

  # Deliver for each email address in hash
  def self.deliver_emails(emails_hash)
    emails_hash.each do |email, properties|
      puts "Outbound to #{email}: #{properties.count}"
      NotificationMailer.weekly_activity2(email, properties[:properties]).deliver
    end
  end

end
