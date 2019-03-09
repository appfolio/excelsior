module CommentsHelper
  def default_anonymous?(message)
    if message.anonymous? && current_user == message.submitter
      true
    end
  end
end
