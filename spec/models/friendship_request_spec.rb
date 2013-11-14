require 'spec_helper'

describe FriendshipRequest do
 
  it { should ensure_inclusion_of(:status).in_array(%w[pending accepted rejected]) }

  context "when a user send a friendship request to other user" do
    before :each do
      @receiver_user = FactoryGirl.create(:user)
      @sender_user = FactoryGirl.create(:user)
    end

    it "should does not send it if exist one 'pending' to same friend" do
      friendship_request = FactoryGirl.create(:friendship_request, status: 'pending', sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated.should_not be_valid
    end
    
    it "should does not send it if exist one 'accepted' to same friend" do
      friendship_request_accepted = FactoryGirl.create(:friendship_request, status: 'accepted', sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_resend = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_resend.should_not be_valid
    end

    it "should  resend it if exist one to same friend but it was rejected" do
      friendship_request = FactoryGirl.create(:friendship_request, status: 'rejected', sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated = FactoryGirl.build(:friendship_request, sender_user: @sender_user, receiver_user: @receiver_user)
      friendship_request_repeated.should be_valid
    end
    
  end


end
