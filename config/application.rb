require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

I18n.enforce_available_locales = true

module Automidnight
  class Application < Rails::Application
    config.style_guide.paths = [ Rails.root.join('app/views/style-guide/**/*') ] if defined?(StyleGuide::Engine)
    config.autoload_paths << Rails.root.join('lib')
  end
end
