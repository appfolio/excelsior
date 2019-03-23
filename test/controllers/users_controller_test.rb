require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = FactoryBot.create(:user)
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
    assert assigns(:appreciations_received)
    assert assigns(:appreciations_sent)
    assert assigns(:feedback_received)
    assert assigns(:feedback_sent)
  end

  test "show user should only show feedback sent if the user is current_user" do
    feedback_to_show = FactoryBot.create(:feedback, :submitter => @user)
    sign_in @user
    assert_equal @controller.current_user, @user

    get :show, id: @user
    assert_response :success

    assert_equal [feedback_to_show], assigns(:feedback_sent)
  end

  test "show user should show feedback sent if the user is an admin" do
    feedback_to_show = FactoryBot.create(:feedback, :submitter => @user)
    admin = FactoryBot.create(:user, :admin => true)
    sign_in admin

    get :show, id: @user
    assert_response :success

    assert_equal [feedback_to_show], assigns(:feedback_sent)
  end

  test "show user should not show feedback sent if the user is not current_user unless it is to the current_user" do
    feedback_to_show = FactoryBot.create(:feedback, :submitter => @user, :recipient => @controller.current_user)
    feedback_to_hide = FactoryBot.create(:feedback, :submitter => @user)

    get :show, id: @user
    assert_response :success

    assert_equal [feedback_to_show], assigns(:feedback_sent)
  end

  test "show user should show feedback received if the user is current_user" do
    feedback_to_show = FactoryBot.create(:feedback, :recipient => @user)
    sign_in @user
    assert_equal @controller.current_user, @user

    get :show, id: @user
    assert_response :success

    assert_equal [feedback_to_show], assigns(:feedback_received)
  end

  test "show user should show feedback received if the user is an admin" do
    feedback_to_show = FactoryBot.create(:feedback, :recipient => @user)
    admin = FactoryBot.create(:user, :admin => true)
    sign_in admin

    get :show, id: @user
    assert_response :success

    assert_equal [feedback_to_show], assigns(:feedback_received)
  end

  test "show user should not show feedback received if the user is not current_user unless it is from the current_user" do
    feedback_to_show = FactoryBot.create(:feedback, :recipient => @user, :submitter => @controller.current_user)
    feedback_to_hide = FactoryBot.create(:feedback, :recipient => @user)

    get :show, id: @user
    assert_response :success

    assert_equal [feedback_to_show], assigns(:feedback_received)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    EmailDomainValidator.stubs(:allowed_email_domain?).returns(true)
    assert_difference('User.count') do
      post :create, user: { :first_name => "Hi", :last_name => "There", :nickname => "Hello", :email => "whatever@alloweddomain.com" }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should redirect on create if user is invalid" do
    EmailDomainValidator.stubs(:allowed_email_domain?).returns(false)
    assert_no_difference('User.count') do
      post :create, user: { :first_name => "Hi", :last_name => "There", :nickname => "Hello", :email => "not@allowed.com" }
    end

    assert_response :success
    assert_template :new
  end

  # test "should get edit" do
  #   get :edit, id: @user
  #   assert_response :success
  # end
  #
  # test "should update user" do
  #   patch :update, id: @user, user: {  }
  #   assert_redirected_to user_path(assigns(:user))
  # end

  test "should hide user if current user is an admin" do
    @controller.current_user.update_attributes!(admin: true)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
      assert @user.reload.hidden_at
    end

    assert_redirected_to users_path
    assert_equal "User was successfully hidden.", flash[:notice]
  end

  test "should not destroy user if current user is not an admin" do
    @controller.current_user.update_attributes!(admin: false)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
      assert_nil @user.reload.hidden_at
    end

    assert_redirected_to users_path
    assert_equal "There was a problem hiding the user.", flash[:notice]
  end
end
