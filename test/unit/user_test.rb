# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  nickname               :string
#  admin                  :boolean          default(FALSE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user visible" do
    user1 = FactoryBot.create(:user, :email => 'my_email@alloweddomain.com')
    user2 = FactoryBot.create(:user, :email => 'my_email2@alloweddomain.com', :hidden_at => Time.now)

    assert_equal [user1], User.visible
    assert_equal [user1, user2], User.all.order(:id)
  end

  test "valid email domains" do
    EmailDomainValidator.stubs(:allowed_email_domains).returns(["alloweddomain.com", "anotheralloweddomain.com"])

    user = User.new(:email => 'hey@alloweddomain.com', :password => '11111111')
    assert user.valid?, user.errors.full_messages

    user = User.new(:email => 'hey@anotheralloweddomain.com', :password => '11111111')
    assert user.valid?, user.errors.full_messages

    user = User.new(:email => 'hey@lloweddomain.com', :password => '11111111')
    assert !user.valid?
    assert user.errors.full_messages.include?("Email must be an associated domain"), user.errors.full_messages
  end

  test "find_for_google_oauth finds a user" do
    user = FactoryBot.create(:user, :email => 'my_email@alloweddomain.com')
    access_token = stub(:info => {'email' => 'my_email@alloweddomain.com'})

    assert_equal user, User.find_for_google_oauth2(access_token, :not_used)
  end

  test "find_for_google_oauth raises on a hidden user" do
    user = FactoryBot.create(:user, :email => 'my_email@alloweddomain.com', :hidden_at => Time.now)
    access_token = stub(:info => {'email' => 'my_email@alloweddomain.com'})

    assert_raises(StandardError) do
      User.find_for_google_oauth2(access_token, :not_used)
    end
  end

  test "find_for_google_oauth finds a user even with different cases returned by oath" do
    user = FactoryBot.create(:user, :email => 'my_email@alloweddomain.com')
    access_token = stub(:info => {'email' => 'My_Email@alloweddomain.com'})

    assert_equal user, User.find_for_google_oauth2(access_token, :not_used)
  end

  test "find_for_google_oauth creates a user when not found for an associated domain" do
    access_token = stub(:info => {'email' => 'not_my_email@alloweddomain.com', 'name' => 'Some Name'})

    assert_empty User.where(:email => 'not_my_email@alloweddomain.com')

    user = User.find_for_google_oauth2(access_token, :not_used)
    assert_equal 'Some', user.first_name
    assert_equal 'Name', user.last_name
    assert_equal 'not_my_email@alloweddomain.com', user.email
    assert user.new_record?
    assert user.valid?
  end

  test "validation fails for non-allowed domain" do
    EmailDomainValidator.stubs(:allowed_email_domains).returns(["alloweddomain.com"])
    access_token = stub(:info => {'email' => 'not_my_email@address.com', 'name' => 'Some Name'})

    assert_empty User.where(:email => 'not_my_email@address.com')

    user = User.find_for_google_oauth2(access_token, :not_used)
    assert !user.valid?
  end

  test "users validated without a password get a password" do
    user = User.new
    assert user.password.blank?

    user.valid?

    assert !user.password.blank?
  end

  test "users validated with a password does not get a new password" do
    user = User.new(password: "heythere")
    user.valid?

    assert_equal "heythere", user.password
  end

  test "appreciations_received appreciations_sent" do
    user = FactoryBot.create(:user)
    appreciation_received = FactoryBot.create(:appreciation, :recipient => user)
    appreciation_sent = FactoryBot.create(:appreciation, :submitter => user)
    rando_appreciation = FactoryBot.create(:appreciation)

    assert_equal [appreciation_received], user.appreciations_received
    assert_equal [appreciation_sent], user.appreciations_sent
  end

end
