module MessagesUtils

  def set_received_at(message)
    if current_user == message.recipient && message.received_at.nil?
      message.update_attributes!(:received_at => Time.now)
    end
  end

end
