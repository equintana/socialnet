require 'spec_helper'

describe Users::RegistrationsController do
	render_views

	context "when a user is logged in" do
		login_user

		describe "doing GET on #edit" do
			before :each do
				@user = subject.current_user
				get :edit, id: @user
			end

			it "is logged in" do
				subject.current_user.should_not be_nil
			end

			it "is showing my profile" do
				subject.current_user.should eq(@user)
			end
		end
	end
end
