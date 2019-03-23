require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def test_valid
    like = FactoryBot.build(:like)
    assert like.valid?
    like.save!

    like2 = FactoryBot.build(:like, :message => like.message, :user => like.user)
    assert !like2.valid?
    assert_equal ["User has already been taken"],
                 like2.errors.full_messages

    like3 = FactoryBot.build(:like, :message => like.message, :user => FactoryBot.create(:user))
    assert like3.valid?

    like4 = FactoryBot.build(:like, :message => FactoryBot.create(:feedback), :user => like.user)
    assert like4.valid?
  end

end
