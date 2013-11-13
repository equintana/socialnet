require 'spec_helper'

describe PagesController do
	render_views
  	describe "GET 'index'" do
	  	context "without a user signed in" do
		    it "returns http success" do
		      get 'index'
		      response.should be_success
		    end

		    it "renders index template" do
		    	get :index
		    	response.should render_template :index
		    end
		end

		context "with a user signed in" do
			login_user
			it "redirects to tweets#index" do
				get :index
				response.should redirect_to tweets_path
			end
		end
  end
end
