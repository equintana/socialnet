require 'spec_helper'

describe Friendship do
 
  it { should validate_presence_of(:friend_id) }
  it { should validate_presence_of(:user_id) }

  describe "invalid actions in a friendship between two users" do
    before :each do
      @user = FactoryGirl.create(:user)
      @friend = FactoryGirl.create(:user)
    end

    it "should does not create a friendship between same user-friend twice" do
      friendship = FactoryGirl.create(:friendship, user: @user, friend: @friend)
      friendship_repeated = FactoryGirl.build(:friendship, user: @user, friend: @friend)
      friendship_repeated.should_not be_valid
    end

    it "should does not create a friendship with an user himself" do
      friendship = FactoryGirl.build(:friendship, user: @user, friend: @user)
      friendship.should_not be_valid
    end
  end

  describe "valid actions in a friendship between two users" do
     before :each do
      @user = FactoryGirl.create(:user)
      @friend = FactoryGirl.create(:user)
    end

    it "should be possible a friendship in two paths" do
      friendship_one_way = FactoryGirl.create(:friendship, user: @user, friend: @friend)
      friendship_second_way = FactoryGirl.build(:friendship, user: @friend, friend: @user)
      friendship_second_way.should be_valid
    end
  end

end
