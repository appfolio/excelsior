require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  def test_create__html_request
    appreciation = FactoryGirl.create(:appreciation)
    post :create, :comment => { :root_id => appreciation.id, :message => 'Some message'}

    assert_redirected_to appreciation_path(appreciation)
  end

  def test_create__ajax_request__comment_submitter_is_feedback_recipient
    EmailSender.any_instance.expects(:send_email_and_set_flash)

    recipient = FactoryGirl.create(:user)
    submitter = FactoryGirl.create(:user)
    feedback = FactoryGirl.create(:feedback, :recipient => recipient, :submitter => submitter)

    sign_in(recipient)
    xhr :post, :create, :comment => { :root_id => feedback.id, :message => 'Some message', :anonymous => true}

    assert_response :success
    feedback.reload
    assert_equal 'Some message', feedback.comments.first.message
    assert_equal submitter, feedback.comments.first.recipient
    assert_equal recipient, feedback.comments.first.submitter
    assert       feedback.comments.first.anonymous?
  end

  def test_create__comment_submitter_is_feedback_submitter
    EmailSender.any_instance.expects(:send_email_and_set_flash)

    recipient = FactoryGirl.create(:user)
    submitter = FactoryGirl.create(:user)
    feedback = FactoryGirl.create(:feedback, :recipient => recipient, :submitter => submitter)

    sign_in(submitter)
    xhr :post, :create, :comment => { :root_id => feedback.id, :message => 'Some message', :anonymous => true}

    assert_response :success
    feedback.reload
    assert_equal 'Some message', feedback.comments.first.message
    assert_equal recipient, feedback.comments.first.recipient
    assert_equal submitter, feedback.comments.first.submitter
    assert       feedback.comments.first.anonymous?
  end

  def test_create__ajax_request__validation_error
    user = FactoryGirl.create(:user)
    sign_in(user)
    feedback = FactoryGirl.create(:feedback)
    assert_no_difference 'Comment.count' do
      xhr :post, :create, :comment => { :root_id => feedback.id, :message => nil, :submitter_id => feedback.recipient.id, :receiver_id => feedback.submitter.id}
    end

    assert_response :success
    feedback.reload
    assert_nil feedback.comments.first
  end

  def test_destroy
    @controller.current_user.update_attributes!(admin: true)
    comment = FactoryGirl.create(:comment)

    assert_no_difference 'Comment.count' do
      xhr :post, :destroy, :id => comment.id
      assert_response :success
    end

    comment.reload
    assert comment.hidden_at
  end

  def test_destroy__not_an_admin
    @controller.current_user.update_attributes!(admin: false)
    comment = FactoryGirl.create(:comment)

    assert_no_difference 'Comment.count' do
      xhr :post, :destroy, :id => comment.id
      assert_response :success
    end

    comment.reload
    assert_nil comment.hidden_at
  end

end
