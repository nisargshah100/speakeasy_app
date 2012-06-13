ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

def app
  Rails.application
end

RSpec.configure do |config|
  config.include app.routes.url_helpers
  config.infer_base_class_for_anonymous_controllers = false
end
