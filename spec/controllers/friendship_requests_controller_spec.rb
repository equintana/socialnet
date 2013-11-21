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

    describe "on POST to #create" do
      context "when valid data" do
        let(:friend) { FactoryGirl.create(:user) }

        it "send a friendship requests to selected friend" do
          expect{
            post :create, receiver_user_id: friend.id
          }.to change(FriendshipRequest,:count).by(1)
        end

        it "has a notice if a friendship requests was saved " do
          post :create, receiver_user_id: friend.id
          flash[:notice].should_not be_nil
        end

        it "redirect to #index after create" do
          post :create, receiver_user_id: friend.id
          response.should redirect_to(friendship_requests_path)
        end

        it "sends a mail to the requested user" do
          # the and_return(double("UserNotifications", :deliver => true)) is needed
          # because should_receive(:friend_request_notification) is apparentely replaced
          # with a mock method so it returns nil cause the strange
          # undefined method deliver for nilClass.
          UserNotifications.should_receive(:friend_request_notification).with(friend, subject.current_user).and_return(double("UserNotifications", :deliver => true))
          post :create, receiver_user_id: friend.id
        end
      end

      context "when invalid data" do
        it "has a error if a friendship requests wasn't saved " do
          post :create, receiver_user_id: 999
          flash[:error].should_not be_nil
        end
      end
    end

    describe "on GET to #index" do
      let!(:not_friend_1) { FactoryGirl.create(:user) }
      let!(:not_friend_2) { FactoryGirl.create(:user) }
      let!(:not_friend_3) { FactoryGirl.create(:user) }

      before do
        FactoryGirl.create(:friendship_request, sender_user: subject.current_user, receiver_user: not_friend_1)
        FactoryGirl.create(:friendship_request, sender_user: not_friend_3 , receiver_user: subject.current_user)
      end

      it "returns list of users that aren't friends and the users haven't send a requests" do
        get :index
        assigns(:users_to_send_frienship_requests).should include( not_friend_2 )
      end

      it "dont show users who I sent a requests" do
        get :index
        assigns(:users_to_send_frienship_requests).should_not include( not_friend_1 )
      end

      it "dont show users who sent me requests" do
        get :index
        assigns(:users_to_send_frienship_requests).should_not include( not_friend_3 )
      end
    end

    describe "on PUT to #update" do
      let!(:not_friend_1) { FactoryGirl.create(:user) }

      before do
        @friendship_request = FactoryGirl.create(:friendship_request, sender_user: subject.current_user, receiver_user: not_friend_1)
      end

      context "valid data" do
        it "update the requests' status" do
          put :update, id: @friendship_request, friendship_request: FactoryGirl.attributes_for(:friendship_request, status: 'accepted')
          @friendship_request.reload
          @friendship_request.status.should eq('accepted')
        end

        it "redirects to index" do
          put :update, id: @friendship_request, friendship_request: FactoryGirl.attributes_for(:friendship_request, status: 'accepted')
          response.should redirect_to(friendship_requests_path)
        end

        it "create a friendship if request was accepted" do
          put :update, id: @friendship_request, friendship_request: FactoryGirl.attributes_for(:friendship_request, status: 'accepted')
          subject.current_user.friends.count.should eq(1)
        end
      end

      context "in valid data" do
        before do
          @friendship_request_attrs = FactoryGirl.attributes_for(:friendship_request, status: '')
        end

        it "no create a friendship " do
          put :update, id: @friendship_request, friendship_request: @friendship_request_attrs
          subject.current_user.friends.count.should eq(0)
        end

        it "has a error message" do
          put :update, id: @friendship_request, friendship_request: @friendship_request_attrs
          flash[:error].should_not be_nil
        end

         it "has a error message" do
          put :update, id: @friendship_request, friendship_request: @friendship_request_attrs
          response.should redirect_to(friendship_requests_path)
        end

      end

    end

  end

end
