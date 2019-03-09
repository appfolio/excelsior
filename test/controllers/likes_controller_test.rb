require 'test_helper'

class LikesControllerTest < ActionController::TestCase

  def test_create
    appreciation = FactoryGirl.create(:appreciation)
    5.times do
      FactoryGirl.create(:like, :message => appreciation)
    end
    user = FactoryGirl.create(:user)

    assert_difference 'Like.count' do
      xhr :post, :create, :message_id => appreciation, :user_id => user
    end

    assert_response :success
    assert_equal '6', response.body
  end

end
