class FriendshipRequest < ActiveRecord::Base

  attr_accessible :receiver_user_id, :sender_user_id, :status

  validates :status, inclusion: { in: %w(pending accepted rejected) }
  validate :disallow_resend_friendship_request
  validate :disallow_self_friendship_request
  validate :disallow_send_inverse_friendship_request  
  validates :receiver_user, presence: true

  # Relationships
  belongs_to :sender_user, :class_name => "User"
  belongs_to :receiver_user, :class_name => "User"

  # Scopes
  scope :by_status, lambda{ |*statuses| where('status in (?)', statuses) unless statuses.nil? }
  scope :by_sender_user, lambda{ |sender_user| where(sender_user_id: sender_user.id) unless sender_user.nil? }
  scope :by_receiver_user, lambda{ |receiver_user| where(receiver_user_id: receiver_user.id) unless receiver_user.nil? }

  # Callbacks
  after_save :create_friendship


  def disallow_resend_friendship_request
     request = FriendshipRequest.by_status('pending','accepted').by_sender_user(self.sender_user).by_receiver_user(self.receiver_user).first
    if request && request.id != self.id
      errors.add(:sender_user, "You had send already Friendship Request or he/her has accepted you")
    end
  end

  def disallow_self_friendship_request
    if self.sender_user_id == self.receiver_user_id
      errors.add(:friend_id, 'You can not send a friendship request at yourself')
    end
  end

  def disallow_send_inverse_friendship_request
    request = FriendshipRequest.by_status('pending','accepted').by_sender_user(self.receiver_user).by_receiver_user(self.sender_user).first
    if request && request.id != self.id
      errors.add(:sender_user, "#{self.receiver_user.name} has sent you a friendship request already!")
    end
  end

  def create_friendship
    if self.status == "accepted"
      @friendship = Friendship.new({user_id: self.sender_user_id, friend_id: self.receiver_user_id })
      @friendship.save
    end
  end

end
