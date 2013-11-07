class Tweet < ActiveRecord::Base
  attr_accessible :tweet

	validates :tweet, presence: true
  validates :tweet, length: { maximum: 140 }
  validates :tweet, uniqueness: { case_sensitive: false }
  validate :unik_message_per_day

  def unik_message_per_day
  	item = Tweet.where(tweet: tweet)
  	puts item
  	#if Date.parse(item.created_at).strftime("%Y-%m-%d") == Date.today
  		#errors.add(:tweet, "You can't write a tweet twice a day")
  	#end
  end

end
