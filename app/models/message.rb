# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  message      :text             not null
#  team         :string
#  created_at   :datetime
#  updated_at   :datetime
#  recipient_id :integer          not null
#  submitter_id :integer          not null
#  hidden_at    :datetime
#  private      :boolean          default(FALSE), not null
#  anonymous    :boolean          default(FALSE), not null
#  type         :string
#  received_at  :datetime
#  root_id      :integer
#

class Message < ActiveRecord::Base
  extend Hideable::ActiveRecord
  hideable

  belongs_to :recipient, :class_name => User
  belongs_to :submitter, :class_name => User
  has_many :comments, :foreign_key => :root_id

  has_many :likes

  validates_presence_of :message, :recipient, :submitter

  scope :index, -> { not_hidden.order('created_at DESC') }

  before_save do
    team.try(:downcase!)
  end
end
