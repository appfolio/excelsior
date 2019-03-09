require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  setup do
    now = Time.now
    Time.stubs(:now).returns(now)
    @feedback = FactoryGirl.create(:feedback)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "new should initialize instance variables correctly" do
    recipient = FactoryGirl.create(:recipient)
    get :new, recipient_id: recipient.id
    assert_equal recipient, assigns(:feedback).recipient
    assert_equal recipient.name, assigns(:recipient_name)
    assert_not_empty assigns(:recipients)
  end

  test "should create feedback" do
    recipient = FactoryGirl.create(:recipient)
    ::EmailSender.any_instance.expects(:send_email_and_set_flash).returns("This is the result.")
    assert_difference('Feedback.count') do
      post :create, feedback: { message: @feedback.message,
                                recipient_id: recipient.to_param,
                                team: @feedback.team,
                                anonymous: "1" }
    end

    assert_equal 'Gnice - your feedback was successfully created! This is the result.',
                 flash[:notice]

    assert_equal true, assigns(:feedback).anonymous?

    assert_redirected_to feedback_path(assigns(:feedback))
  end

  test "create should handle errors gracefully" do
    assert_no_difference 'Feedback.count' do
      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        post :create, feedback: { message: @feedback.message,
                                      team: @feedback.team }
      end
    end

    assert_response :success
    assert_template 'new'
  end

  test "should show to submitters but not update the timestamp" do
    sign_in(@feedback.submitter)
    get :show, :id => @feedback.id
    assert_response :success
    assert_equal @feedback, assigns(:feedback)
    @feedback.reload
    assert_nil @feedback.received_at
  end

  test "should show to recipients and update the timestamp" do
    sign_in(@feedback.recipient)
    get :show, :id => @feedback.id
    assert_response :success
    assert_equal @feedback, assigns(:feedback)
    @feedback.reload
    assert_equal Time.zone.now.to_s, @feedback.received_at.to_s
  end

  test "should show to recipients but not update the timestamp if it is present" do
    @feedback.update_attributes(:received_at => (Time.zone.now - 1.day))
    sign_in(@feedback.recipient)
    get :show, :id => @feedback.id
    assert_response :success
    assert_equal @feedback, assigns(:feedback)
    @feedback.reload
    assert_equal (Time.zone.now - 1.day).to_s, @feedback.received_at.to_s
  end

  test "should show to admins but not update the timestamp" do
    user = FactoryGirl.create(:user, admin: true)
    sign_in(user)
    get :show, :id => @feedback.id
    assert_response :success
    assert_equal @feedback, assigns(:feedback)
    @feedback.reload
    assert_nil @feedback.received_at
  end

  test "show denied to everyone else" do
    assert @controller.current_user != @feedback.submitter
    assert @controller.current_user != @feedback.recipient
    assert !@controller.current_user.admin?
    get :show, :id => @feedback.id
    assert_equal "You don't have permission to see that feedback.", flash[:notice]
    assert_redirected_to appreciations_path
  end
end
