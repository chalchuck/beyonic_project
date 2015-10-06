require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "rails/all"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BeyonicProject
  class Application < Rails::Application

    config.generators do |config|
      config.helper false
      config.assets false
      # config.test_framework :rspec,
      #   fixtures: true,
      #   view_specs: false,
      #   helper_specs: false,
      #   routing_specs: false,
      #   controller_specs: false,
      #   request_specs: false
      config.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.time_zone = 'Nairobi'
    Dir[Rails.root.join("app/services/**")]
    config.action_mailer.default_url_options = {host: ENV['HOST']}    
    config.active_record.raise_in_transactional_callbacks = true
  end
end
