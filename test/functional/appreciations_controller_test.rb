require 'test_helper'

class AppreciationsControllerTest < ActionController::TestCase
  setup do
    now = Time.now
    Time.stubs(:now).returns(now)
    @appreciation = FactoryBot.create(:appreciation)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:appreciations)
  end

  test "should get index scoped by submitter" do
    appreciations = [FactoryBot.create(:appreciation), FactoryBot.create(:appreciation)]
    appreciations << FactoryBot.create(:appreciation, :team => "heyo")

    get :index, :filters => {:submitter_id => appreciations[0].submitter_id}
    assert_response :success
    assert_equal [appreciations[0]], assigns(:appreciations)
    assert_equal appreciations[0].submitter.name, assigns(:by)
  end

  test "should get index scoped by recipient" do
    appreciations = [FactoryBot.create(:appreciation), FactoryBot.create(:appreciation)]
    appreciations << FactoryBot.create(:appreciation, :team => "heyo")

    get :index, :filters => {:recipient_id => appreciations[1].recipient_id}
    assert_response :success
    assert_equal [appreciations[1]], assigns(:appreciations)
    assert_equal appreciations[1].recipient.name, assigns(:for)
  end

  test "should get index scoped by team" do
    appreciations = [FactoryBot.create(:appreciation), FactoryBot.create(:appreciation)]
    appreciations << FactoryBot.create(:appreciation, :team => "heyo")

    get :index, :filters => {:team => appreciations[2].team}
    assert_response :success
    assert_equal [appreciations[2]], assigns(:appreciations)
    assert_equal "heyo", assigns(:for)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "new should initialize instance variables correctly" do
    recipient = FactoryBot.create(:recipient)
    get :new, recipient_id: recipient.id
    assert_equal recipient, assigns(:appreciation).recipient
    assert_equal recipient.name, assigns(:recipient_name)

    assert_not_empty assigns(:recipients)
  end

  test "should create appreciation" do
    recipient = FactoryBot.create(:recipient)
    ::EmailSender.any_instance.expects(:send_email_and_set_flash).returns("This is the result.")
    ::SlackSender.any_instance.expects(:send_slack_message)
    assert_difference('Appreciation.count') do
      post :create, appreciation: { message: @appreciation.message,
                                    recipient_id: recipient.to_param,
                                    team: @appreciation.team,
                                    anonymous: true}
    end

    assert_equal 'Awesome - your appreciation was successfully created! This is the result.',
                 flash[:notice]

    assert_redirected_to appreciation_path(assigns(:appreciation))

    assert assigns(:appreciation).anonymous?
  end

  test "create should handle errors gracefully" do
    assert_no_difference 'Appreciation.count' do
      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        post :create, appreciation: { message: @appreciation.message,
                                      team: @appreciation.team }
      end
    end

    assert_response :success
    assert_template 'new'
  end

  test "should show appreciation but not update the received at if the user is not the recipient" do
    assert @controller.current_user != @appreciation.recipient

    get :show, id: @appreciation

    assert_response :success
    @appreciation.reload
    assert_nil @appreciation.received_at
  end

  test "should show appreciation and update the received at if the user is the recipient" do
    sign_in(@appreciation.recipient)

    assert_equal @appreciation.recipient, @controller.current_user

    get :show, id: @appreciation

    assert_response :success
    @appreciation.reload
    assert_equal Time.zone.now.to_s, @appreciation.received_at.to_s
  end

  test "should show appreciation and but not update the received at if it is already there" do
    sign_in(@appreciation.recipient)
    @appreciation.update_attributes(:received_at => (Time.now - 1.day))
    assert_equal @appreciation.recipient, @controller.current_user

    get :show, id: @appreciation

    assert_response :success
    @appreciation.reload
    assert_equal (Time.zone.now - 1.day).to_s, @appreciation.received_at.to_s
  end

  test "should hide appreciation if user is an admin" do
    @controller.current_user.update_attributes!(admin: true)
    assert_no_difference 'Appreciation.count' do
      delete :destroy, id: @appreciation
      assert @appreciation.reload.hidden_at
    end

    assert_redirected_to appreciations_path
  end

  test "should not destroy appreciation if user is not an admin" do
    @controller.current_user.update_attributes!(admin: false)
    assert_no_difference 'Appreciation.count' do
      delete :destroy, id: @appreciation
      assert_nil @appreciation.reload.hidden_at
    end

    assert_redirected_to appreciations_path
  end
end
