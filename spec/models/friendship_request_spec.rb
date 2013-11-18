require 'spec_helper'

describe FriendshipRequest do
 
  it { should ensure_inclusion_of(:status).in_array(%w[pending accepted rejected]) }

  context "when a user send a friendship request to an user" do
    before :each do
      @receiver_user = FactoryGirl.create(:user)
      @sender_user = FactoryGirl.create(:user)
    end

    it "does not send it if exist one 'pending' to same friend" do
      friendship_request = FactoryGirl.create(:friendship_request, status: 'pending', sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated.should_not be_valid
    end
    
    it "does not send it if exist one 'accepted' to same friend" do
      friendship_request_accepted = FactoryGirl.create(:friendship_request, status: 'accepted', sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_resend = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_resend.should_not be_valid
    end

    it "send it if exist one to same friend but it was rejected" do
      friendship_request = FactoryGirl.create(:friendship_request, status: 'rejected', sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated.should be_valid
    end

    it "does not send it at itself" do
      friendship_request_itself = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @sender_user)
      friendship_request_itself.should_not be_valid
    end

    it "does not send it if the friend not exist" do
      friendship_request = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user_id: 999)
      friendship_request.should_not be_valid
    end

    it "does not send it if exist one friendship request inverse 'pending' or 'accepted'" do
      friendship_request = FactoryGirl.create(:friendship_request, sender_user: @receiver_user, receiver_user: @sender_user)
      friendship_request_inverse = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_inverse.should_not be_valid
    end
  end

end

describe FriendshipRequest, "class methods" do
  let(:current_user) { FactoryGirl.create(:user) } 
  
  context "scopes" do
    let!(:not_friend) { FactoryGirl.create(:user) } 
    let!(:not_friend_2) { FactoryGirl.create(:user) } 

    before do
      FactoryGirl.create(:friendship_request, sender_user: current_user, receiver_user: not_friend)
      FactoryGirl.create(:friendship_request, sender_user: current_user, receiver_user: not_friend_2, status: 'rejected')
    end

    it ".by_status one argument" do
      FriendshipRequest.by_status('pending').count.should eq(1)
    end

    it ".by_status two arguments " do
      FriendshipRequest.by_status('pending', 'rejected').count.should eq(2)
    end

    it ".by_sender_user" do
      FriendshipRequest.by_sender_user(current_user).count.should eq(2)
    end

    it ".by_receiver_user" do
      FriendshipRequest.by_receiver_user(not_friend).count.should eq(1)
    end

     it "chaining .by_sender_user .by_status " do
      FriendshipRequest.by_sender_user(current_user).by_status('rejected').count.should eq(1)
    end

  end
end

