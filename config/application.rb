require_relative 'boot'

require File.expand_path('../boot', __FILE__)
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
Bundler.require(*Rails.groups)
module Guitoire
  class Application < Rails::Application
    config.assets.quiet = true
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.action_controller.action_on_unpermitted_parameters = :raise
    config.time_zone = 'Mountain Time (US & Canada)'
    config.i18n.available_locales = [:en]
  end
end
