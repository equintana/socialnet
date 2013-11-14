class FriendshipRequest < ActiveRecord::Base
  attr_accessible :receiver_user_id, :sender_user_id, :status

  validates :status, inclusion: { in: %w(pending accepted rejected) }
  validate :disallow_resend_friendship_request

  # Relationships
  belongs_to :sender_user, :class_name => "User"
  belongs_to :receiver_user, :class_name => "User"

  def disallow_resend_friendship_request
     request = FriendshipRequest.where('status in (:statuses)', statuses: [ 'pending', 'accepted']).
                                 where('sender_user_id = :sender_user and receiver_user_id = :receiver_user', 
                                      sender_user: self.sender_user, receiver_user: self.receiver_user).first
    if request
      errors.add(:tweet, "You had send already Friendship Request or he/her has accepted you")
    end
  end


end
