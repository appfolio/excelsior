require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = FactoryBot.create(:user)
  end

  test "should show user" do
    get :show, params: { id: @user }
    assert_response :success
    assert assigns(:appreciations_received)
    assert assigns(:appreciations_sent)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    EmailDomainValidator.stubs(:allowed_email_domain?).returns(true)
    assert_difference('User.count') do
      post :create, params: {
        user: { :first_name => "Hi", :last_name => "There", :nickname => "Hello", :email => "whatever@alloweddomain.com" }
      }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should redirect on create if user is invalid" do
    EmailDomainValidator.stubs(:allowed_email_domain?).returns(false)
    assert_no_difference('User.count') do
      post :create, params: {
        user: { :first_name => "Hi", :last_name => "There", :nickname => "Hello", :email => "not@allowed.com" }
      }
    end

    assert_response :success
    assert_template :new
  end

  test "should hide user if current user is an admin" do
    @controller.current_user.update_attributes!(admin: true)
    assert_no_difference 'User.count' do
      delete :destroy, params: { id: @user }
      assert @user.reload.hidden_at
    end

    assert_redirected_to root_path
    assert_equal "User was successfully hidden.", flash[:notice]
  end

  test "should not destroy user if current user is not an admin" do
    @controller.current_user.update_attributes!(admin: false)
    assert_no_difference 'User.count' do
      delete :destroy, params: { id: @user }
      assert_nil @user.reload.hidden_at
    end

    assert_redirected_to root_path
    assert_equal "There was a problem hiding the user.", flash[:notice]
  end
end
