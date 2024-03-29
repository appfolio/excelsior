# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
require './test/deprecation_toolkit_env'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
FORMATTERS = [
  SimpleCov::Formatter::LcovFormatter,
  SimpleCov::Formatter::HTMLFormatter
].freeze
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(FORMATTERS)
SimpleCov.start 'rails' do
  enable_coverage :branch
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/setup'
require 'factory_bot'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  include FactoryBot::Syntax::Methods
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  setup :login

  def login
    user = FactoryBot.create(:user)
    sign_in(user)
  end
end
