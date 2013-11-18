class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
  				  			:profile_img
  # attr_accessible :title, :body

  mount_uploader :profile_img, ProfilePictureUploaderUploader

  validates :name, presence: true

  # Relationships
  has_many :tweets

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :friendship_requests
  has_many :sent_requests, :class_name => "FriendshipRequest", :foreign_key => "sender_user_id" 
  has_many :incoming_requests, :class_name => "FriendshipRequest", :foreign_key => "receiver_user_id"  


  def not_friends
    User.where('id != :user_id', user_id: self.id) - self.all_friends
  end

  def users_to_send_frienship_requests
    users_i_have_sent_requests = FriendshipRequest.by_sender_user(self).by_status('pending', 'accepted').map(&:receiver_user)
    users_who_had_sent_requests_to_me = FriendshipRequest.by_receiver_user(self).by_status('pending','accepted').map(&:sender_user)

    self.not_friends - users_i_have_sent_requests - users_who_had_sent_requests_to_me
  end

  def pending_incoming_requests
    FriendshipRequest.by_receiver_user(self).by_status('pending')
  end

  def timeline
    users_ids = [ self.id ] + all_friends.map(&:id)
    Tweet.by_id_users(users_ids).order("created_at DESC")
  end

  def all_friends
    self.friends + self.inverse_friends
  end

end
