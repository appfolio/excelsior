require 'test_helper'

class EmailDomainValidatorTest < ActiveSupport::TestCase

  def test_allowed_email_domain?
    EmailDomainValidator.stubs(:allowed_email_domains).returns(['whatever.com','something.net'])

    assert EmailDomainValidator.allowed_email_domain?('hey@whatever.com')
    assert EmailDomainValidator.allowed_email_domain?('hey@something.net')

    assert !EmailDomainValidator.allowed_email_domain?('hey@not_whatever.com')
    assert !EmailDomainValidator.allowed_email_domain?('hey@something_sortof.net')
    assert !EmailDomainValidator.allowed_email_domain?('hey@something.com')
  end

  def test_allowed_email_domain__all_allowed
    EmailDomainValidator.stubs(:allowed_email_domains).returns([])

    assert EmailDomainValidator.allowed_email_domain?('hey@whatever.com')
    assert EmailDomainValidator.allowed_email_domain?('hey@something.net')

    assert EmailDomainValidator.allowed_email_domain?('hey@not_whatever.com')
    assert EmailDomainValidator.allowed_email_domain?('hey@something_sortof.net')
    assert EmailDomainValidator.allowed_email_domain?('hey@something.com')
  end

  def test_allowed_email_domains
    ENV.stubs(:[]).with(anything)
    ENV.stubs(:[]).with('ALLOWED_EMAIL_DOMAINS').returns('whatever.com,something.net')
    EmailDomainValidator.unstub(:allowed_email_domains)
    assert_equal ['whatever.com','something.net'], EmailDomainValidator.allowed_email_domains
  end

  def test_allowed_email_domains__empty
    ENV.stubs(:[]).with(anything)
    ENV.stubs(:[]).with('ALLOWED_EMAIL_DOMAINS').returns(nil)
    EmailDomainValidator.unstub(:allowed_email_domains)
    assert_equal [], EmailDomainValidator.allowed_email_domains
  end

  def test_allowed_email_recipients
    ENV.stubs(:[]).with(anything)
    ENV.stubs(:[]).with('ALLOWED_EMAILS').returns('hi@something.com,hello@something.com')
    assert EmailDomainValidator.allowed_email_recipient?('hi@something.com')
    assert !EmailDomainValidator.allowed_email_recipient?('hey@something.com')
  end

  def test_allowed_email_recipients__all_allowed
    ENV.stubs(:[]).with(anything)
    ENV.stubs(:[]).with('ALLOWED_EMAILS').returns(nil)
    assert EmailDomainValidator.allowed_email_recipient?('hi@something.com')
    assert EmailDomainValidator.allowed_email_recipient?('hey@something.com')
  end

end
