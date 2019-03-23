require 'test_helper'

class LikesControllerTest < ActionController::TestCase

  def test_create
    appreciation = FactoryBot.create(:appreciation)
    5.times do
      FactoryBot.create(:like, :message => appreciation)
    end
    user = FactoryBot.create(:user)

    assert_difference 'Like.count' do
      xhr :post, :create, :message_id => appreciation, :user_id => user
    end

    assert_response :success
    assert_equal '6', response.body
  end

end
