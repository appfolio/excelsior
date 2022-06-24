class Emailer < ActionMailer::Base
  helper ApplicationHelper

  def default_from_email
    ENV['DEFAULT_FROM_EMAIL']
  end

  def appreciation_email(appreciation)
    @recipient = appreciation.recipient
    @message = appreciation
    @url = appreciation_url(appreciation)
    mail(from: default_from_email,
         to: @recipient.email,
         subject: "We received an appreciation for #{@recipient.name} on #{Date.current}!! Yippee!")
  end

  def feedback_email(feedback)
    @recipient = feedback.recipient
    @url = feedback_url(feedback)
    @message = feedback
    mail(from: default_from_email,
         to: @recipient.email,
         subject: "New feedback for #{@recipient.name} on #{Date.current}!! Excelsior!")
  end

end
