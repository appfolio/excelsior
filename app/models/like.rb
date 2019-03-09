class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :message

  validates_uniqueness_of :user, :scope => :message
end
