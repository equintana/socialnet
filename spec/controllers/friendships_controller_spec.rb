require 'spec_helper'

describe FriendshipsController do

  context "user not logged in" do
    before :each do
      @friendship = FactoryGirl.create(:friendship, user: FactoryGirl.create(:user), friend: FactoryGirl.create(:user) ) 
    end

    it "redirects to login page" do
      delete :destroy , id: @friendship
      response.should redirect_to new_user_session_path
    end
  end

  context "when user is logged in" do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    describe "on DELETe to #destroy" do
      let(:friend_1) { FactoryGirl.create(:user) }
      let(:friend_2) { FactoryGirl.create(:user) }

      before :each do
        @friendship =  FactoryGirl.create(:friendship, user: subject.current_user, friend: friend_1) 
        @inverse_friendship = FactoryGirl.create(:friendship, user: friend_2, friend: subject.current_user)
      end
      context "when valid data" do
        it "delete the friendship" do
          expect{
            delete :destroy, id: @friendship
          }.to change(Friendship, :count).by(-1)
        end

        it "delete the inverse friendship" do
          expect{
            delete :destroy, id: @inverse_friendship
          }.to change(Friendship, :count).by(-1)
        end

        it "return a notice message id friendship delete" do
          delete :destroy, id: @friendship
          flash[:notice].should_not be_nil
        end

        it "show respond with 404 iffriendship doesn't exist" do
          delete :destroy, id: 999
          response.response_code.should == 404
        end

        it "redirect to current_user profile" do
          delete :destroy, id: @friendship
          response.should redirect_to(user_path(id: subject.current_user))
        end

      end
    end

  end
end
