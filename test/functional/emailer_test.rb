require 'test_helper'

class EmailerTest < ActionMailer::TestCase

  setup do
    EmailDomainValidator.stubs(:allowed_email_domains).returns(["alloweddomain.com"])
    Emailer.any_instance.stubs(:default_from_email).returns("admin@alloweddomain.com")
  end

  def test_appreciation_email
    recipient = FactoryBot.create(:recipient, email: 'hey@alloweddomain.com')
    appreciation = FactoryBot.create(:appreciation, :recipient => recipient)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      Emailer.appreciation_email(appreciation).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal "We received an appreciation for #{recipient.name} on #{Date.current}!! Yippee!", email.subject
    assert_equal 'hey@alloweddomain.com', email.to[0]
    assert email.body.to_s.include?('http://localhost:5000/appreciations'), email.body.to_s
  end

  def test_feedback_email
    recipient = FactoryBot.create(:recipient, email: 'hey@alloweddomain.com')
    feedback = FactoryBot.create(:feedback, :recipient => recipient)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      Emailer.feedback_email(feedback).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal "New feedback for #{recipient.name} on #{Date.current}!! Excelsior!", email.subject
    assert_equal 'hey@alloweddomain.com', email.to[0]
    assert email.body.to_s.include?('http://localhost:5000/feedback'), email.body.to_s
  end

end
