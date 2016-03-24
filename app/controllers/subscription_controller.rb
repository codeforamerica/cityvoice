class SubscriptionController < ApplicationController
  def create
    location = Location.find(subscription_params[:location_id])
    subscriber = Subscriber.find_or_create_by!(email: subscription_params[:email])
    confirmer = SubscriptionConfirmer.new(subscriber, location)
    @subscription = confirmer.location_subscription
    confirmer.confirm
    @errors = confirmer.location_subscription.errors.full_messages
  end

  protected

  def subscription_params
    params.require(:subscription).permit(:email, :location_id)
  end

#add weekly notifier email
  def email
    destination = params[:to]
    weekly_activity = Notification_mailer.weekly_activity(@weekly_activity, destination)
    #if notification_mailer.deliver
    #else
     # redirect_to notification_mailer_weekly_activity(@notification_mailer), 
    #end
  end

end
