require 'simplecov'
SimpleCov.start 'rails' do
  coverage_dir 'tmp/coverage'
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'turn'
require 'faker'
require 'factory_girl'
require 'capybara/rails'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

module ActionDispatch
  class IntegrationTest
    include Capybara
  end
end

class ActionController::TestCase
end

class ActiveSupport::TestCase
end
