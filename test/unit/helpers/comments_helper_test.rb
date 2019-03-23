require 'test_helper'

class CommentsHelperTest < ActionView::TestCase

  def test_default_anonymous__not_by_default
    feedback = FactoryBot.create(:feedback)
    assert !view.default_anonymous?(feedback)

    appreciation = FactoryBot.create(:appreciation)
    assert !view.default_anonymous?(appreciation)
  end

  def test_default_anonymous__if_current_user_is_submitter_and_anonymous
    feedback = FactoryBot.create(:feedback, :anonymous => true)
    view.stubs(:current_user).returns(feedback.submitter)
    assert view.default_anonymous?(feedback)

    appreciation = FactoryBot.create(:appreciation, :anonymous => true)
    view.stubs(:current_user).returns(appreciation.submitter)
    assert view.default_anonymous?(appreciation)
  end

  def test_default_anonymous__if_current_user_is_not_submitter_and_anonymous
    feedback = FactoryBot.create(:feedback, :anonymous => true)
    view.stubs(:current_user).returns(FactoryBot.create(:user))
    assert !view.default_anonymous?(feedback)

    appreciation = FactoryBot.create(:appreciation, :anonymous => true)
    view.stubs(:current_user).returns(FactoryBot.create(:user))
    assert !view.default_anonymous?(appreciation)
  end

  def test_default_anonymous__if_current_user_is_submitter_and_not_anonymous
    feedback = FactoryBot.create(:feedback, :anonymous => false)
    view.stubs(:current_user).returns(feedback.submitter)
    assert !view.default_anonymous?(feedback)

    appreciation = FactoryBot.create(:appreciation, :anonymous => false)
    view.stubs(:current_user).returns(appreciation.submitter)
    assert !view.default_anonymous?(appreciation)
  end



end
