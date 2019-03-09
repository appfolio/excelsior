# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  message      :text             not null
#  team         :string
#  created_at   :datetime
#  updated_at   :datetime
#  recipient_id :integer          not null
#  submitter_id :integer          not null
#  hidden_at    :datetime
#  private      :boolean          default(FALSE), not null
#  anonymous    :boolean          default(FALSE), not null
#  type         :string
#  received_at  :datetime
#  root_id      :integer
#

class Comment < Message
  # the root is the original message being commented on
  belongs_to :root, :class_name => Message

  validates_presence_of :root

  validate do |o|
    if o.root && !o.root.is_a?(Feedback)
      errors.add(:base, "Comments can only be attached to feedback")
    end
  end

  validate do |o|
    if o.submitter.admin? && o.submitter != root.recipient && o.submitter != root.submitter
      errors.add(:base, "Admin can't submit comments on feedback")
    end
  end
end
