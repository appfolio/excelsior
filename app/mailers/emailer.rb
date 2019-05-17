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

  def comment_email(comment)
    @feedback = comment.root
    @url = send(:"#{@feedback.class.name.downcase}_url", comment.root)
    @message = comment
    mail(from: default_from_email,
         to: @message.recipient.email,
         subject: "New reply to feedback for #{@feedback.recipient.name} on #{Date.current}!! Discuss!")
  end

end
