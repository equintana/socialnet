require 'spec_helper'

describe TweetsController, "Actions" do
	render_views

	describe "on GET to #index" do
		it "should render the template" do
			get :index
			response.should render_template(:index)
		end

		it "should populates an array of Tweets" do
			get :index
		end
	end

	describe "on GET to #new" do
		it "should render the template" do
			get :new
			response.should render_template(:new)
		end
	end

	describe "on POST to #create" do
		before :each do
			@attrs = FactoryGirl.attributes_for(:tweet)
		end

		context "with valid params" do
			it "should create a new tweet" do
				expect{
				  post :create, tweet: @attrs
				}.to change(Tweet, :count).by(1)
			end

			it "should redirect to index on save" do
				post :create, tweet: @attrs
				response.should redirect_to(tweets_path)
			end

			it "notice should not be nil on save" do
				post :create, tweet: @attrs
				flash[:notice].should_not be_nil
			end
		end

		context "with invalid params" do
			it "should redirect to new on fail saving" do
				post :create, tweet: {}
				response.should redirect_to(new_tweet_path)
			end

			it "should have errors on fail saving" do
				post :create, tweet: {}
				flash[:errors].should_not be_nil
			end
		end
	end

end
