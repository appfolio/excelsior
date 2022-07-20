require 'test_helper'

class EmailSenderTest < ActiveSupport::TestCase

  setup do
    EmailDomainValidator.stubs(:allowed_email_recipient?).returns(true)
    EmailDomainValidator.stubs(:allowed_email_domains).returns(["alloweddomain.com"])
    Emailer.any_instance.stubs(:default_from_email).returns("admin@alloweddomain.com")
  end

  def test_sends_correct_email_type__appreciation
    recipient = FactoryBot.create(:recipient, email: 'hey@alloweddomain.com')
    appreciation = FactoryBot.create(:appreciation, recipient: recipient)
    Emailer.expects(:appreciation_email).with(appreciation).returns(stub(:deliver_now => true))
    ::EmailSender.new(appreciation).send_email_and_set_flash
  end

  def test_sends_email__associated_domain
    recipient = FactoryBot.create(:recipient, email: 'hey@alloweddomain.com')
    appreciation = FactoryBot.create(:appreciation, recipient: recipient)

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      flash = ::EmailSender.new(appreciation).send_email_and_set_flash

      email = ActionMailer::Base.deliveries.last
      assert_equal 'hey@alloweddomain.com', email.to[0]
      assert_equal 'We sent the recipient email notification of this appreciation.',
                   flash
    end
  end

  def test_sends_email__non_associated_account
    recipient = FactoryBot.create(:recipient)
    recipient.email = "hey@not_alloweddomain.com"
    recipient.save(:validate => false)
    appreciation = FactoryBot.create(:appreciation, recipient: recipient)

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      flash = ::EmailSender.new(appreciation).send_email_and_set_flash

      assert_equal 'Recipients must be from an allowed domain in order to send them an email.',
                   flash
    end
  end

  def test_sends_email__non_allowed_email_recipient
    EmailDomainValidator.expects(:allowed_email_recipient?).returns(false)
    recipient = FactoryBot.create(:recipient, email: 'hey@alloweddomain.com')
    appreciation = FactoryBot.create(:appreciation, recipient: recipient)

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      flash = ::EmailSender.new(appreciation).send_email_and_set_flash

      assert_equal 'Recipients must be from an allowed domain in order to send them an email.',
                   flash
    end
  end

  def test_sends_email__allowed_email_recipient
    EmailDomainValidator.expects(:allowed_email_recipient?).returns(true)
    recipient = FactoryBot.create(:recipient, email: 'hi@alloweddomain.com')
    appreciation = FactoryBot.create(:appreciation, recipient: recipient)

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      flash = ::EmailSender.new(appreciation).send_email_and_set_flash

      email = ActionMailer::Base.deliveries.last
      assert_equal 'hi@alloweddomain.com', email.to[0]
      assert_equal 'We sent the recipient email notification of this appreciation.',
                   flash
    end
  end

end
