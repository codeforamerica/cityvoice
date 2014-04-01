class Subscription::ConfirmsController < ApplicationController
  def show
    subscription = LocationSubscription.find_by!(auth_token: auth_token)
    subscription.confirm!
  end

  protected

  def auth_token
    params.require(:token)
  end
end
