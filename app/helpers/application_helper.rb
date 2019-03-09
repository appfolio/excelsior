module ApplicationHelper
  def active?(action, controller)
    (action_name == action && controller_name == controller) ? "active" : ""
  end

  def anonymous_name(anonymous, name, anonymous_name = 'Someone anonymous')
    anonymous ? anonymous_name : name
  end
end
