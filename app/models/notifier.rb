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
    # Get the NotificationSubscriptions which have had activity since last email was sent
    subs = NotificationSubscription.includes(property: :feedback_inputs)
                                   .where(confirmed: true)
                                   .where('feedback_inputs.created_at >= notification_subscriptions.last_email_sent_at')

    # Group all the <NotificationSubscription>'s by email
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

    # Deliver for each email address in hash
    result.each do |email, properties|
      puts "Outbound to #{email}: #{properties.count}"
      NotificationMailer.weekly_activity2(email, properties[:properties]).deliver
    end
  end

end
