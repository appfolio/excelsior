require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def test_valid
    like = FactoryGirl.build(:like)
    assert like.valid?
    like.save!

    like2 = FactoryGirl.build(:like, :message => like.message, :user => like.user)
    assert !like2.valid?
    assert_equal ["User has already been taken"],
                 like2.errors.full_messages

    like3 = FactoryGirl.build(:like, :message => like.message, :user => FactoryGirl.create(:user))
    assert like3.valid?

    like4 = FactoryGirl.build(:like, :message => FactoryGirl.create(:feedback), :user => like.user)
    assert like4.valid?
  end

end
