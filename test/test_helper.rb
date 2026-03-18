ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'
require 'minitest/autorun'

require 'action_controller'
require 'action_dispatch'
require 'rails'

# Minimal Rails app for testing
class TestApp < Rails::Application
  config.eager_load = false
  config.active_support.deprecation = :stderr
  config.secret_key_base = 'test-secret-key-base-for-respond-with-chart'
  config.hosts.clear
end

require 'respond_with_chart'

# Boot the app so Railtie initializers run
TestApp.initialize!

# Draw a minimal route set for integration tests
TestApp.routes.draw do
  get 'charts/show', to: 'charts#show'
end
