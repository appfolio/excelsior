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

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase

  test "feedback is private" do
    feedback = FactoryBot.build(:feedback)
    assert_equal false, feedback.private?

    feedback.save!
    assert_equal true, feedback.reload.private?

    feedback.private = false
    feedback.save!
    assert_equal true, feedback.reload.private?
  end

end
