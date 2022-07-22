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

class User < ActiveRecord::Base
  extend Hideable::ActiveRecord
  hideable

  devise :database_authenticatable,
         :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :appreciations_received, foreign_key: "recipient_id", class_name: Appreciation
  has_many :appreciations_sent, foreign_key: "submitter_id", class_name: Appreciation
  has_many :messages_sent, foreign_key: "submitter_id", class_name: Message
  has_many :messages_received, foreign_key: "recipient_id", class_name: Message

  validate :email_domain_is_associated
  before_validation :set_password

  scope :index, -> { not_hidden }

  def set_password
    self.password = Devise.friendly_token[0, 20] if password.blank?
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    email = data['email'].downcase
    user = User.where(:email => email).first

    raise "This user is hidden!" if user && user.hidden?

    if user.blank?
      first_name, last_name = chomp_user_name(data['name'])
      user = User.new(first_name: first_name,
                      last_name: last_name,
                      email: email
      )
    end
    user
  end

  def self.chomp_user_name(name)
    [name.split(' ').first, name.split(' ').last]
  end

  def name
    [first_name, last_name].join(' ')
  end

  def short_name
    [first_name, last_name[0, 1]].join(' ')
  end

  private

  def email_domain_is_associated
    if email.present? && !EmailDomainValidator.allowed_email_domain?(email)
      errors.add(:email, "must be an associated domain")
    end
  end
end
