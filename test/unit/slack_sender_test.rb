require 'test_helper'

class SlackSenderTest < ActiveSupport::TestCase
  def setup
    ENV.stubs(:[]).with("SLACK_URL").returns("https://www.slackurl.com/")
    ENV.stubs(:[]).with("SLACK_CHANNEL").returns("#excelsior_dev")
    ENV.stubs(:[]).with("ALLOWED_EMAIL_DOMAINS").returns("alloweddomain.com,another_allowed.com")
    stub_request(:post, "https://www.slackurl.com/")
  end

  def test_slack_sender__stage
    appreciation = FactoryGirl.create(:appreciation)

    body = { "username" => "Excelsior!",
             "text" => "*#{appreciation.submitter.name}* appreciates *#{appreciation.recipient.name}*:\nI appreciate when a rails upgrade works smoothly\n*BOOM.*\n",
             "channel" => "#excelsior_dev"
           }.to_json

    stub_request(:post, 'https://www.slackurl.com/').
      with(:body => body).
        to_return(:body => 'success!')

    sender = SlackSender.new(appreciation)
    sender.expects(:signoff).returns("BOOM.")
    response = sender.send_slack_message
    assert_equal 'success!', response.body
  end

  def test_slack_sender__production
    ENV.stubs(:[]).with("SLACK_CHANNEL").returns("#excelsior")
    appreciation = FactoryGirl.create(:appreciation)

    body = { "username" => "Excelsior!",
             "text" => "*#{appreciation.submitter.name}* appreciates *#{appreciation.recipient.name}*:\nI appreciate when a rails upgrade works smoothly\n*BOOM.*\n",
             "channel" => "#excelsior"
           }.to_json
    stub_request(:post, 'https://www.slackurl.com/').
      with(:body => body).
        to_return(:body => 'success!')

    sender = SlackSender.new(appreciation)
    sender.expects(:signoff).returns("BOOM.")
    response = sender.send_slack_message
    assert_equal 'success!', response.body
  end

  def test_slack_sender__refuse_feedback
    feedback = FactoryGirl.create(:feedback)
    HTTParty.expects(:post).never

    response = ::SlackSender.new(feedback).send_slack_message
  end
end
