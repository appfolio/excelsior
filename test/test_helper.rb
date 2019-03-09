ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/setup'
require 'factory_girl'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  include FactoryGirl::Syntax::Methods
end

class ActionMailer::TestCase
  EmailDomainValidator.stubs(:allowed_email_domains).returns(["alloweddomain.com"])
end

class ActionController::TestCase
  include Devise::TestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  setup :login

  def login
    user = FactoryGirl.create(:user)
    sign_in(user)
  end

  EmailDomainValidator.stubs(:allowed_email_domains).returns(["alloweddomain.com"])
end
