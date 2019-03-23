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

class CommentTest < ActiveSupport::TestCase

  test "valid" do
    feedback = FactoryBot.create(:feedback)
    comment = Comment.new(:submitter => feedback.recipient, :recipient => feedback.submitter,
                          :message => "This is a good comment", :root => feedback)
    assert comment.valid?, comment.errors.full_messages
  end

  test "root can't be blank" do
    feedback = FactoryBot.create(:feedback)
    comment = Comment.new(:submitter => feedback.recipient, :recipient => feedback.submitter,
                          :message => "This is a good comment", :root => nil)
    assert !comment.valid?
    assert_equal ["Root can't be blank"], comment.errors.full_messages
  end

  test "submitter can't be an admin" do
    comment = Comment.new(:submitter => FactoryBot.create(:admin), :recipient => FactoryBot.create(:user),
                          :message => "This is not allowed", :root => FactoryBot.create(:feedback))
    assert !comment.valid?
    assert_equal ["Admin can't submit comments on feedback"], comment.errors.full_messages
  end

  test "submitter can't be an admin unless they are the original recipient" do
    feedback = FactoryBot.create(:feedback, :recipient => FactoryBot.create(:admin))
    comment = Comment.new(:submitter => feedback.recipient, :recipient => feedback.submitter,
                          :message => "This is allowed", :root => feedback)
    assert comment.valid?, comment.errors.full_messages
  end

  test "submitter can't be an admin unless they are the original submitter" do
    feedback = FactoryBot.create(:feedback, :submitter => FactoryBot.create(:admin))
    comment = Comment.new(:submitter => feedback.submitter, :recipient => feedback.recipient,
                          :message => "This is allowed", :root => feedback)
    assert comment.valid?, comment.errors.full_messages
  end

  test "comments are only valid on feedback" do
    comment = Comment.new(:submitter => FactoryBot.create(:user), :recipient => FactoryBot.create(:user),
                          :message => "This is not allowed", :root => FactoryBot.create(:appreciation))
    assert !comment.valid?
    assert_equal ["Comments can only be attached to feedback"], comment.errors.full_messages
  end


end
