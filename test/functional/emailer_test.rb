require 'test_helper'

class EmailerTest < ActionMailer::TestCase

  setup do
    Emailer.any_instance.stubs(:default_from_email).returns("admin@alloweddomain.com")
  end

  def test_appreciation_email
    admin = FactoryGirl.create(:user, admin: true)
    recipient = FactoryGirl.create(:recipient, email: 'hey@alloweddomain.com')
    appreciation = FactoryGirl.create(:appreciation, :recipient => recipient)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      Emailer.appreciation_email(appreciation).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal "We received an appreciation for #{recipient.name} on #{Date.current}!! Yippee!", email.subject
    assert_equal 'hey@alloweddomain.com', email.to[0]
    assert_equal [admin.email], email.bcc
    assert email.body.to_s.include?('http://localhost:5000/appreciations'), email.body.to_s
  end

  def test_feedback_email
    admin = FactoryGirl.create(:user, admin: true)
    recipient = FactoryGirl.create(:recipient, email: 'hey@alloweddomain.com')
    feedback = FactoryGirl.create(:feedback, :recipient => recipient)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      Emailer.feedback_email(feedback).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal "New feedback for #{recipient.name} on #{Date.current}!! Excelsior!", email.subject
    assert_equal 'hey@alloweddomain.com', email.to[0]
    assert_equal [admin.email], email.bcc
    assert email.body.to_s.include?('http://localhost:5000/feedback'), email.body.to_s
  end

  def test_comment_email
    admin = FactoryGirl.create(:user, admin: true)
    recipient = FactoryGirl.create(:user, email: 'hey@alloweddomain.com')
    submitter = FactoryGirl.create(:user)
    feedback = FactoryGirl.create(:feedback, :recipient => recipient, :submitter => submitter)
    comment = FactoryGirl.create(:comment, :recipient => recipient, :submitter => submitter, :anonymous => true, :root => feedback)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      Emailer.comment_email(comment).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal "New reply to feedback for #{feedback.recipient.name} on #{Date.current}!! Discuss!", email.subject
    assert_equal 'hey@alloweddomain.com', email.to[0]
    assert_equal [admin.email], email.bcc
    assert email.body.to_s.include?("http://localhost:5000/feedbacks/#{comment.root.id}"), email.body.to_s
  end

end
