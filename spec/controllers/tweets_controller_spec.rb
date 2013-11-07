require 'spec_helper'

describe TweetsController, "Actions" do
	render_views

	describe "on GET to #index" do
		it "render the template index" do
			get :index
			response.should render_template(:index)
		end

		it "populates an array of Tweets" do
			tweet = FactoryGirl.create(:tweet)
			get :index
			assigns(:tweets).should eq([tweet])		end
	end

	describe "on GET to #new" do
		it "renders the template new" do
			get :new
			response.should render_template(:new)
		end
	end

	describe "on POST to #create" do
		before :each do
			@attrs = FactoryGirl.attributes_for(:tweet)
		end

		context "with valid params" do
			it "creates a new tweet" do
				expect{
				  post :create, tweet: @attrs
				}.to change(Tweet, :count).by(1)
			end

			it "redirect to index" do
				post :create, tweet: @attrs
				response.should redirect_to(tweets_path)
			end

			it "has a notice" do
				post :create, tweet: @attrs
				flash[:notice].should_not be_nil
			end
		end

		context "with invalid params" do
			it "redirects to new" do
				post :create, tweet: {}
				response.should redirect_to(new_tweet_path)
			end

			it "have errors" do
				post :create, tweet: {}
				flash[:errors].should_not be_nil
			end
		end
	end

	describe "on GET to #edit" do
		context "with valid tweet id" do
			before :each do
				@tweet = FactoryGirl.create(:tweet)
			end

			it "founds a tweet" do
				get :edit, id: @tweet
				assigns(:tweet).should_not be_nil
			end

			it "found the valid tweet" do
				get :edit, id: @tweet
				assigns(:tweet).should == @tweet
			end

			it "renders the edit template" do
				get :edit, id: @tweet
				response.should render_template :edit
			end
		end

		context "with invalid tweet ID" do
			it "throws not found exception" do
				expect{
				  get :edit, id: 0
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end
	end

	describe "on GET to #show" do
		context "with a valid tweet ID" do
			before :each do
				@tweet = FactoryGirl.create(:tweet)
			end

			it "founds a valid tweet" do
				get :show, id: @tweet
				assigns(:tweet).should == @tweet
			end

			it "renders the show template" do
				get :show, id: @tweet
				response.should render_template :show
			end
		end

		context "with an invalid tweet ID" do
			it "throws not found exception" do
				expect{
				  get :show, id: 0
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end
	end

	describe "on PUT to #update" do
		before :each do
			@tweet = FactoryGirl.create(:tweet)
		end

		context "with a valid tweet" do
			it "founds a valid tweet" do
				put :update, id: @tweet
				assigns(:tweet).should == @tweet
			end

			it "changes the values of the message" do
				put :update, id: @tweet, tweet: FactoryGirl.attributes_for(:tweet, tweet: "new tweet edited")
				@tweet.reload
				@tweet.tweet.should eq("new tweet edited")
			end

			it "redirects to index" do
				@tweet.tweet = "tweet changed"
				put :update, id: @tweet
				response.should redirect_to(tweets_path)
			end
		end

		context "with an invalid tweet" do
			it "redirect to edit" do
				put :update, id: @tweet, tweet: FactoryGirl.attributes_for(:tweet, tweet: nil)
				response.should redirect_to(edit_tweet_path)
			end
		end
	end

	describe "on DELETE on #destroy" do
		context "with a valid id" do
			before :each do
				@tweet = FactoryGirl.create(:tweet)
			end

			it "founds a tweet" do
				delete :destroy, id: @tweet
				assigns(:tweet).should == @tweet
			end

			it "destroys a tweet" do
				expect{
				  delete :destroy, id: @tweet
				}.to change(Tweet, :count).by(-1)
			end

			it "redirects to index" do
				delete :destroy, id: @tweet
				response.should redirect_to(tweets_path)
			end
		end

		context "with an invalid id" do
			it "shows 404" do
				expect{
				  delete :destroy, id: 0
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end
	end
end
