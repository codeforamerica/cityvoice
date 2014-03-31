class Subscription::UnsubscribesController < ApplicationController
  def show
    @subscription = LocationSubscription.find_by!(auth_token: auth_token)
    @property = @subscription.location
    if params[:all] # delete all under that email address
      @subscription.subscriber.notification_subscriptions.delete_all
    else
      @subscription.delete
    end
  end

  protected

  def auth_token
    params.require(:token)
  end
end
