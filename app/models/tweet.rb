class Tweet < ActiveRecord::Base
  attr_accessible :tweet, :image

  mount_uploader :image, TweetImageUploader

	validates :tweet, presence: true
  validates :tweet, length: { maximum: 140 }
  validate  :unik_message_per_day

  belongs_to :user

  def unik_message_per_day
    item = Tweet.where('tweet = :message and created_at >= :date', message: self.tweet, date: Date.current).first
    # item.id != self.id because I have to exclude the own tweet from the search
    # item.user.id == self.user.id because its a single tweet for a single user,
    # but a different user can write the same tweet a day
  	if item && item.created_at.strftime("%Y-%m-%d").eql?(Date.current.strftime("%Y-%m-%d")) && item.id != self.id && item.user.id == self.user.id
      errors.add(:tweet, "You can't write a tweet twice a day")
    end
  end

end
