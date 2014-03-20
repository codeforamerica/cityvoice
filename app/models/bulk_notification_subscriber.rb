require 'csv'

module BulkNotificationSubscriber

  # Bulk subscribes from a csv with columns "parcel_id" and "email"
  def self.bulk_subscribe_from_csv(csv_path, subscribe_to_past_feedback = false)
    table = CSV.read(csv_path, :headers => true)
    table.each do |row|
      email = row["email"]
      parcel_id = row["parcel_id"]
      if subscribe_to_past_feedback
        ns = create_subscription_from_parcel_id_without_confirmation(email, parcel_id) do |subscription|
          # Set the subscriptions to receive all past feedback
          subscription.override_last_email_sent_at_to!(FeedbackInput.minimum(:created_at) - 1)
        end
      else
        ns = create_subscription_from_parcel_id_without_confirmation(email, parcel_id)
      end
      if ns == false
        puts "Problem with #{row}"
      else
        puts "Successfully subscribed #{email} to #{parcel_id}"
      end
    end
  end

  def self.create_subscription_from_parcel_id_without_confirmation(email, parcel_id)
    target_subject = Subject.find_by_parcel_id(parcel_id)
    if !target_subject
      puts "Subject with parcel ID #{parcel_id} not found."
      return false
    end
    if NotificationSubscription.find_by(:property_id => target_subject.id, :email => email)
      puts "#{email} already subscribed to #{parcel_id}"
      return false
    end
    subscription = NotificationSubscription.create(:property_id => target_subject.id, :email => email, :bulk_added => true)
    yield subscription if block_given?
    subscription
  end

end
