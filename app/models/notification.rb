class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notified_by, class_name: 'User'
  belongs_to :post

  validates :user_id, :notified_by_id, :post_id, :identifier, :notice_type, presence: true
  validates :read, :inclusion => {:in => [true, false]}
end
