class NotificationSubscriptionsController < ApplicationController

  def create
    @subscription = NotificationSubscription.create(params[:notification_subscriber])
  end

  def confirm
    # user will go to this link through the email
    auth_token = params[:token]
    subscription = NotificationSubscription.find_by(auth_token: auth_token)
    subscription.confirm!
  end

  def unsubscribe
    auth_token = params[:token]
    subscription = NotificationSubscription.find_by(auth_token: auth_token)
    subscription.delete
  end
end
