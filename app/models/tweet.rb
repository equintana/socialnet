class Tweet < ActiveRecord::Base
  attr_accessible :tweet

	validates :tweet, presence: true
  	validates :tweet, length: { maximum: 140 }
  	validates :tweet, uniqueness: { case_sensitive: false, scope: :created_at }

end
