if defined?(StyleGuide::Engine)
  ActionView::Base.send(:include, ApplicationHelper)
  ActionView::Base.send(:include, Rails.application.routes.url_helpers)

  class ActionView::Base
    def protect_against_forgery?
    end
  end if Rails.env.development?
end
