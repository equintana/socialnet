require 'spec_helper'

describe Friendship do
 
  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:user_id) }

  it "should not create a friendship between same user-friend twice" do
    friendship = FactoryGirl.create(:friendship)
    friendship_repeated = FactoryGirl.build(:friendship)
    friendship_repeated.should_not be_valid
  end

  it "should does not create a friendship with an user himself" do
    friendship = FactoryGirl.build(:friendship, user_id: 1, friend_id: 1)
    friendship.should_not be_valid
  end

end
