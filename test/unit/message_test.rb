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

class MessageTest < ActiveSupport::TestCase

  test "valid" do
    appreciation = Appreciation.new
    assert !appreciation.valid?
    assert_equal ["Message can't be blank", "Recipient can't be blank", "Submitter can't be blank"],
                 appreciation.errors.full_messages
  end

  test "team is downcased" do
    appreciation = FactoryBot.create(:appreciation)
    appreciation.team = "TEAM"
    appreciation.save!
    assert_equal "team", appreciation.team
  end

  test "index scope" do
    appreciation = FactoryBot.create(:appreciation)
    assert_equal [appreciation], Appreciation.all
    assert_equal [appreciation], Appreciation.index

    appreciation.hide!

    assert_equal [], Appreciation.not_hidden
    assert_equal [appreciation], Appreciation.all
    assert_equal [], Appreciation.index
  end
end
