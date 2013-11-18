require 'spec_helper'

describe User, "validations" do
  it { should validate_presence_of(:name) }
end

describe User, "associations" do
  it { should have_many(:tweets) }
end

describe User, "instance methods" do
  let(:current_user) { FactoryGirl.create(:user) } 
  
  context "#not_friends" do
    let!(:friend) { FactoryGirl.create(:user) } 
    let!(:not_friend) { FactoryGirl.create(:user) } 

    before do
      FactoryGirl.create(:friendship, user: current_user, friend: friend)
    end

    it "not return current friends" do
      current_user.not_friends.should_not include(friend)
    end

    it "returns users who are not my friends" do
      current_user.not_friends.should include( not_friend)
    end

     it "return all others users if any friendship" do
      Friendship.delete_all
      current_user.not_friends.should include(friend, not_friend)
    end
  end

  context "#users_to_send_frienship_requests" do
    let!(:not_friend_1) { FactoryGirl.create(:user) } 
    let!(:not_friend_2) { FactoryGirl.create(:user) }
    let!(:not_friend_3) { FactoryGirl.create(:user) } 

    before do
      @friendship_request = FactoryGirl.create(:friendship_request, sender_user: current_user, receiver_user: not_friend_1)
    end

    it "users who i can send friendship requests" do
      current_user.users_to_send_frienship_requests.should include(not_friend_2, not_friend_3)
    end
    
    it "users who i can not send friendship requests" do
      current_user.users_to_send_frienship_requests.should_not include(not_friend_1)
    end

    it "users who i can not send friendship requests if any friendship requests" do
      FriendshipRequest.delete_all
      current_user.users_to_send_frienship_requests.should include(not_friend_1, not_friend_2, not_friend_3)
    end

    it "users who can not send me friendship requests" do
      not_friend_1.users_to_send_frienship_requests.should_not include(current_user)
    end

    it "users who can not send me friendship requests if friendship_request rejected" do
       @friendship_request.status = "rejected"
       @friendship_request.save
       current_user.users_to_send_frienship_requests.should include(not_friend_1, not_friend_2, not_friend_3)
    end

  end

  context "#pending_incoming_requests" do
    let!(:not_friend_1) { FactoryGirl.create(:user) } 
    let!(:not_friend_2) { FactoryGirl.create(:user) }
    
    before do
      FactoryGirl.create(:friendship_request, sender_user: not_friend_1, receiver_user: current_user)
      FactoryGirl.create(:friendship_request, sender_user: not_friend_2, receiver_user: current_user, status: 'accepted')
    end

    it "return friendship requests sent to the user" do
      current_user.pending_incoming_requests.count.should eq(1)
    end
  end

  context "#all_friends" do
    let!(:friend_1) { FactoryGirl.create(:user) } 
    let!(:friend_2) { FactoryGirl.create(:user) }
    let!(:not_friend) { FactoryGirl.create(:user) }

     before do
      FactoryGirl.create(:friendship, user: current_user, friend: friend_1)
      FactoryGirl.create(:friendship, user: friend_2, friend: current_user)
    end

    it "include my friends" do
      current_user.all_friends.should include(friend_1, friend_2)
    end 

    it "not include user who are not friends" do
      current_user.all_friends.should_not include(not_friend)
    end
  end

  context "#timeline" do
    let(:friend) { FactoryGirl.create(:user) }
    let(:not_friend) { FactoryGirl.create(:user) }

    let(:my_tweet){  FactoryGirl.create(:tweet, user: current_user) }
    let(:friend_tweet){  FactoryGirl.create(:tweet, user: friend) }
    let(:not_friend_tweet){  FactoryGirl.create(:tweet, user: not_friend) }
    
    before do
      FactoryGirl.create(:friendship, user: current_user, friend: friend)
    end

    it "tweets of my timeline" do
      current_user.timeline.should include(my_tweet, friend_tweet)
    end
  end

end
