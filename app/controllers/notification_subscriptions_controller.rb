class NotificationSubscriptionsController < ApplicationController

  def create
    location = Location.find(notification_subscription_params[:location_id])
    subscriber = Subscriber.find_or_create_by!(email: notification_subscription_params[:email])
    confirmer = SubscriptionConfirmer.new(subscriber, location)
    @subscription = confirmer.notification_subscription
    @errors = confirmer.notification_subscription.errors.full_messages
  end

  def confirm
    subscription = NotificationSubscription.find_by!(auth_token: auth_token)
    subscription.confirm!
  end

  def unsubscribe
    @subscription = NotificationSubscription.find_by!(auth_token: auth_token)
    @property = @subscription.location
    if params[:all] # delete all under that email address
      @subscription.subscriber.notification_subscriptions.delete_all
    else
      @subscription.delete
    end
  end

  protected

  def notification_subscription_params
    params.require(:notification_subscription).permit(:email, :location_id)
  end

  def auth_token
    params.require(:token)
  end
end
