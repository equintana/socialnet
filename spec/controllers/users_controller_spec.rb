require 'spec_helper'

describe UsersController do

  context "user not logged in" do
    let(:user){ FactoryGirl.create(:user) }

    it "redirects to login page from show" do
      get :show, id: user
      response.should redirect_to new_user_session_path
    end
  end

  context "user logged in" do
    login_user

    describe "on GET to #show" do
     let(:user){ FactoryGirl.create(:user) }

     it "renders the show template" do
        get :show, id: user
        response.should render_template :show
      end

      it "found user selected" do
        get :show, id: user
       assigns(:user).should eq(user)
      end
    end
  end

end
