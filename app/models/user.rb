class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
  				  			:profile_img
  # attr_accessible :title, :body

  validates :name, presence: true

  has_many :tweets

  mount_uploader :profile_img, ProfilePictureUploaderUploader
end
