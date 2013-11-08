require 'spec_helper'

describe Tweet, "validations"  do
	it { should validate_presence_of(:tweet) }

	it { should ensure_length_of(:tweet).is_at_most(140) }

	it "does not let me create repeated messages on the same day" do
		tweet = FactoryGirl.create(:tweet, tweet: "test message")
		tweet2 = FactoryGirl.build(:tweet, tweet: "test message")
		tweet2.valid?.should == false
		tweet2.should have(1).error_on(:tweet)
	end

	it "let the user update add a photo with the same text" do
		tweet = FactoryGirl.create(:tweet, tweet: "test message")
		tweet.tweet = "test message"
		tweet.should be_valid
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