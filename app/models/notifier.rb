# Logic for DB roundup queries & email sending

class Notifier

  def self.send_weekly_notifications
    puts "Start of notifier method"
    # Get the NotificationSubscriptions which have had activity since last email was sent
    subs = NotificationSubscription.includes(property: :feedback_inputs)
                                   .where(notification_subscriptions: {confirmed: true})
                                   .where("feedback_inputs.created_at >= notification_subscriptions.last_email_sent_at")

    # [mike@gmail.com: {properties: [{id: 22, activity: [feedback_input, feedback_input]}]},
    #  another@email.com: {} ]

    hash = {}
    subs.each do |sub|
      hash[sub.email] = {}

      hash[sub.email][:properties] = []
      hash[sub.email][:properties] << { property: sub.property, activity: sub.property.feedback_inputs.where("created_at >= ?", sub.last_email_sent_at) }
    end


    # send the email for each in hash
    hash.each do |email, properties_array|
      NotificationMailer.weekly_activity2(email, properties_array[:properties]).deliver
    end

  end

end
