require 'test_helper'

class OmniauthCallbacksControllerTest < ActionController::TestCase

  setup do
    sign_out(@controller.current_user)
  end

  test "google_oauth2 succeeds" do
    user = FactoryBot.create(:user)

    User.expects(:find_for_google_oauth2).with(request.env["omniauth.auth"], nil).returns(user)

    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :google_oauth2

    assert_redirected_to :root
    assert_equal user, assigns(:user)
    assert_equal 'Successfully authenticated from Google account.', flash[:notice]
    assert_equal user, @controller.current_user
  end

  test "google_oauth2 fails" do
    user = User.new(:email => "")
    User.expects(:find_for_google_oauth2).with(request.env["omniauth.auth"], nil).returns(user)

    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :google_oauth2

    assert_redirected_to :new_user_session
    assert_equal user, assigns(:user)
    assert_nil flash[:notice]
    assert_equal "We got the following errors trying to log you in: Email can't be blank",
                 flash[:alert]
    assert_nil @controller.current_user
  end

  test "google_oauth2 fails with a standard error" do
    User.expects(:find_for_google_oauth2).with(request.env["omniauth.auth"], nil).raises("hi")

    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :google_oauth2

    assert_redirected_to :new_user_session
    assert_nil flash[:notice]
    assert_equal "We got the following errors trying to log you in: hi",
                 flash[:alert]
    assert_nil @controller.current_user
  end

end
