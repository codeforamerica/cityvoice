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
    params.require(:notification_subscription).permit(:email, :location_id)
  end
end
