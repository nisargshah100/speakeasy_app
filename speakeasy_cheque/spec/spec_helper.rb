ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'


def app
  Rails.application
end

Dir[Rails.root.join("spec/factories/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include app.routes.url_helpers
  config.infer_base_class_for_anonymous_controllers = false
  config.include Mongoid::Matchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
