class EmailSender
  include Rails.application.routes.url_helpers

  def initialize(message)
    @message = message
  end

  def send_email_and_set_flash
    flash = 'Recipients must be from an allowed domain in order to send them an email.'
    if EmailDomainValidator.allowed_email_domain?(@message.recipient.email) && EmailDomainValidator.allowed_email_recipient?(@message.recipient.email)
      Emailer.send(:"#{@message.type.downcase}_email", @message).deliver_now
      flash = "We sent the recipient email notification of this #{@message.type.downcase}."
    end

    flash
  end

end
