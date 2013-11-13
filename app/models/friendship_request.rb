class FriendshipRequest < ActiveRecord::Base
  attr_accessible :receiver_user_id, :sender_user_id, :status

  validates :status, inclusion: { in: %w(pending accepted rejected) }

  # Relationships
  belongs_to :sender_user, :class_name => "User"
  belongs_to :receiver_user, :class_name => "User"

end
