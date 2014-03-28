class NotificationSubscriptionsController < ApplicationController

  def create
    @subscription = NotificationSubscription.create(params[:notification_subscription])
    @errors = @subscription.errors.full_messages
  end

  def confirm
    # user will go to this link through the email
    auth_token = params[:token]
    subscription = NotificationSubscription.find_by(auth_token: auth_token)
    subscription.confirm!
  end

  def unsubscribe
    auth_token = params[:token]
    @subscription = NotificationSubscription.find_by(auth_token: auth_token)
    @property = @subscription.subject
    if params[:all] # delete all under that email address
      NotificationSubscription.delete_all(email: subscription.email)
    else
      @subscription.delete
    end
  end
end
