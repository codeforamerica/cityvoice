class NotificationSubscriptionsController < ApplicationController

  def create
    location = Location.find(subscription_params[:location_id])
    subscriber = Subscriber.find_or_create_by!(email: subscription_params[:email])
    confirmer = SubscriptionConfirmer.new(subscriber, location)
    @subscription = confirmer.location_subscription
    @errors = confirmer.location_subscription.errors.full_messages
  end

  def confirm
    subscription = LocationSubscription.find_by!(auth_token: auth_token)
    subscription.confirm!
  end

  def unsubscribe
    @subscription = LocationSubscription.find_by!(auth_token: auth_token)
    @property = @subscription.location
    if params[:all] # delete all under that email address
      @subscription.subscriber.notification_subscriptions.delete_all
    else
      @subscription.delete
    end
  end

  protected

  def subscription_params
    params.require(:notification_subscription).permit(:email, :location_id)
  end

  def auth_token
    params.require(:token)
  end
end
