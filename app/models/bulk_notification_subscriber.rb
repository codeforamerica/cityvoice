module BulkNotificationSubscriber

  def self.create_subscription_from_parcel_id_without_confirmation(email, parcel_id)
    target_subject = Subject.find_by_parcel_id(parcel_id)
    if !target_subject
      puts "Subject with parcel ID #{parcel_id} not found."
      return false
    end
    subscription = NotificationSubscription.create(:property_id => target_subject.id, :email => email, :bulk_added => true)
    subscription
  end

end
