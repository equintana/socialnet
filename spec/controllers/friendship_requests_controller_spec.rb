require 'spec_helper'

describe FriendshipRequestsController do

  context "when not logged in" do
    describe "should redirect to sing_in " do
      let(:friendship_request) { FactoryGirl.attributes_for(:friendship_request)}

      it "should not have a current_user" do
        subject.current_user.should be_nil
      end

      it "should redirect to sing_in when try to see its friendship requests" do
        get :index 
        response.should redirect_to new_user_session_path 
      end

      it "should redirect to sing_in when try to send a friendship requests" do
        post :create, :friendship_request => friendship_request
        response.should redirect_to new_user_session_path 
      end

      it "should redirect to sing_in when try to respond a friendship requests received" do
        put :update, :id => friendship_request
        response.should redirect_to new_user_session_path 
      end
    end
  end

  context "when user is logged in" do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    # describe "on POST to #create" do
    #   context "when valid data" do
    #     before :each do
    #       @friend = FactoryGirl.create(:user)
    #     end

    #     it "should send a friendship requests to selected friend" do
    #       expect{
    #         post :create, receiver_user_id: @friend.id
    #       }.to change(FriendshipRequest,:count).by(1)
    #     end

    #     it "should has a notice if a friendship requests was saved " do
    #       post :create, receiver_user_id: @friend.id
    #       flash[:notice].should_not be_nil
    #     end
    #   end

    #   context "when invalid data" do
    #     it "should has a error if a friendship requests wasn't saved " do
    #       post :create, receiver_user_id: 999
    #       flash[:error].should_not be_nil
    #     end
    #   end
    # end

    describe "on GET to #index" do
      before :each do
        created_users = FactoryGirl.create_list(:user, 2)
        #subject.current_user.friends  = FactoryGirl.create_list(:user, 1)
      end

      it "should return a list of users that aren't friends and the users haven't send a requests" do
        get :index
        assigns(:users_not_friends).should_be eq( created_users )
      end

    end
  end

end
