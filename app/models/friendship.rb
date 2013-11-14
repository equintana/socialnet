class Friendship < ActiveRecord::Base
  attr_accessible :friend_id, :user_id

  validates :friend_id, presence: true
  validates :user_id, presence: true
  validate :disallow_self_friendship
  validates_uniqueness_of :friend_id, :scope => :user_id

  # Relationships
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  def disallow_self_friendship
    if friend_id == user_id
      errors.add(:friend_id, 'You can not be friend with yourself')
    end
  end
end
