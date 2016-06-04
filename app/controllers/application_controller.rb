class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate if ENV["LOCK_CITYVOICE"] == "true"
  before_filter :load_app_content

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == ENV["CITYVOICE_LOCK_USERNAME"] && password == ENV["CITYVOICE_LOCK_PASSWORD"]
    end
  end

    def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def load_app_content
    @content = Rails.application.config.app_content_set
  end
end
