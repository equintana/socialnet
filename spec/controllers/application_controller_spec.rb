require "spec_helper"

describe ApplicationController do
	controller do
		def after_sign_in_path_for(resource)
			super resource
		end

    def destroy
      raise ActiveRecord::RecordNotFound
    end

	end

	before (:each) do
		@user = FactoryGirl.create(:user)
	end

	describe "After sigin-in" do
		it "redirects to the /tweets page" do
			controller.after_sign_in_path_for(@user).should == tweets_path
		end
	end

  describe "handling ActiveRecord exceptions when record not found" do
    before(:each) do
      @not_found_template = "#{Rails.root}/public/404.html"
    end
    
    it "should render the /404.html page" do
      delete :destroy , id: 999
      response.should render_template(:file => @not_found_template)
    end
  end

end