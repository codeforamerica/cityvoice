namespace :notifications do
  desc "Sends out emails to all qualify property subscribers"
  task :send => :environment do
    # This code needs to be better
    # Should be querying for NotificationSubscriptions from the start...
    # NotificationSubscription.where(confirmed: true).includes(:property).where("property.most_recent_activity <= ?", 7.days.ago)


    properties = Property.activity_since(7.days.ago)
                            .includes(:notification_subscriptions)
                            .where("notification_subscriptions.confirmed = ?", true)


    #TODO group by emails!

    properties.each do |p|
      subscriptions = p.notification_subscriptions
      subscriptions.each do |subscription|
        NotificationMailer.weekly_activity(subscription).deliver
      end
    end

  end

  task :send2 => :environment do
    Notifier.send_weekly_notifications
  end

end
