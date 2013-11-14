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

  has_many :friendship_requests
  has_many :sent_requests, :class_name => "FriendshipRequest", :foreign_key => "sender_user_id" 
  has_many :incoming_requests, :class_name => "FriendshipRequest", :foreign_key => "receiver_user_id"  
end
