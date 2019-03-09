module AppreciationsHelper

  def recipient_list_json(recipients)
    raw(recipients.to_json) unless recipients.nil?
  end
end
