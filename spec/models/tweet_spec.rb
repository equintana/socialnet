require 'spec_helper'

describe Tweet, "validations"  do
	it { should validate_presence_of(:tweet) }

	it { should ensure_length_of(:tweet).is_at_most(140) }

	it "does not let me create repeated messages on the same day" do
		user = FactoryGirl.create(:user)
		tweet = FactoryGirl.create(:tweet, tweet: "test message", user: user)
		tweet2 = FactoryGirl.build(:tweet, tweet: "test message", user: user)
		tweet2.should_not be_valid
		tweet2.should have(1).error_on(:tweet)
	end

	it "let two or more users write the same tweet" do
		user1 = FactoryGirl.create(:user)
		user2 = FactoryGirl.create(:user)

		tweet = FactoryGirl.create(:tweet, tweet: "test message", user: user1)
		tweet2 = FactoryGirl.build(:tweet, tweet: "test message", user: user2)
		tweet2.should be_valid
	end

	it "let the user update add a photo with the same text" do
		tweet = FactoryGirl.create(:tweet, tweet: "test message")
		tweet.tweet = "test message"
		tweet.should be_valid
	end

	it "has a valid user" do
		tweet = FactoryGirl.build(:tweet)
		tweet.user.should be_valid
	end

	context "image upload" do

		it "is a valid img file" do
			tweet = FactoryGirl.create(:tweet_with_image)
			tweet.should be_valid
		end

		it "is invalid if it is not an image" do
			tweet = FactoryGirl.build(:tweet_with_pdf)
			tweet.should_not be_valid
		end
	end
end

describe Tweet, "associations" do
	it { should belong_to(:user) }
end