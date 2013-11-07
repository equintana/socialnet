require 'spec_helper'

describe Tweet, "validations"  do

	it { should validate_presence_of(:tweet) }

	it { should ensure_length_of(:tweet).is_at_most(140) }

	it "should not let me create repeated messages on the same day" do
		tweet = FactoryGirl.create(:tweet, tweet: "test message")
		tweet2 = FactoryGirl.build(:tweet, tweet: "test message")
		tweet2.valid?.should == false
		tweet2.should have(1).error_on(:tweet)
	end

end
