namespace :notifications do

  desc "Subscribes in bulk from the CSV at the below address"
  task :bulk_subscribe_from_csv => :environment do
    p "Downloading CSV for bulk-loading subscriptions..."
    system("cd /tmp && curl -O https://s3-us-west-1.amazonaws.com/south-bend-secrets/parcel_ids_and_emails.csv")
    BulkNotificationSubscriber.bulk_subscribe_from_csv("/tmp/parcel_ids_and_emails.csv", true)
  end

  task :send => :environment do
    Notifier.send_weekly_notifications
  end

end
