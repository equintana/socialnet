require 'spec_helper'

describe User, "validations" do
  it { should validate_presence_of(:name) }
end

describe User, "associations" do
  it { should have_many(:tweets) }
end

describe User, "instance methods" do
   
  current_user = FactoryGirl.create(:user)

  context "#not_friends" do
    friend = FactoryGirl.create(:user)
    not_friend = FactoryGirl.create(:user)

    before do
      FactoryGirl.create(:friendship, user: current_user, friend: friend)
    end

    it "should not return current friends" do
      current_user.not_friends.should_not include(friend)
    end

    it "should return users who are not my friends" do
      current_user.not_friends.should include(not_friend)
    end
  end
end
