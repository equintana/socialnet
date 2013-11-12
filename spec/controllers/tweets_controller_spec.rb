require 'spec_helper'

describe TweetsController, "Actions" do
	render_views

	context "user logged in" do
		# from macros
		login_user

		describe "on GET to #index" do
			it "is logged in" do
				get :index
				subject.current_user.should_not be_nil
			end

			it "populates an array of my tweets" do
				tw1 = FactoryGirl.create(:tweet, tweet: "m1", user: subject.current_user)
				tw2 = FactoryGirl.create(:tweet, tweet: "m2")
				get :index
				ids = assigns(:tweets).collect{ |t| t.user.id }
				expect(ids).to eq( [tw1.user.id] )
			end
		end

		describe "on GET to #new" do
			it "is logged in" do
				get :new
				subject.current_user.should_not be_nil
			end

			it "renders the template new" do
				get :new
				response.should render_template :new
			end
		end

		describe "on POST to #create" do
			before :each do
				@attrs = FactoryGirl.attributes_for(:tweet)
			end

			it "is logged in" do
				post :create, tweet: @attrs
				subject.current_user.should_not be_nil
			end

			context "with valid params" do
				it "creates a new tweet without image" do
					expect{
					  post :create, tweet: @attrs
					}.to change(Tweet, :count).by(1)
				end

				it "created a tweet with image" do
					expect{
					  post :create, tweet: FactoryGirl.attributes_for(:tweet_with_image)
					}.to change(Tweet, :count).by(1)
				end

				it "redirect to index" do
					post :create, tweet: FactoryGirl.attributes_for(:tweet_with_image)
					response.should redirect_to(tweets_path)
				end

				it "has a notice" do
					post :create, tweet: @attrs
					flash[:notice].should_not be_nil
				end
			end

			context "with invalid params" do
				it "renders new" do
					post :create, tweet: {}
					response.should render_template :new
				end

				it "have errors" do
					post :create, tweet: {}
					flash[:errors].should_not be_nil
				end
			end
		end

		describe "on GET to #edit" do
			it "is logged in" do
				get :edit, id: FactoryGirl.create(:tweet, user: subject.current_user)
				subject.current_user.should_not be_nil
			end

			context "with valid tweet id" do
				before :each do
					@tweet = FactoryGirl.create(:tweet, user: subject.current_user)
					get :edit, id: @tweet
				end

				it "founds a tweet of mine" do
					assigns(:tweet).user.id.should eq(subject.current_user.id)
				end

				it "renders the edit template" do
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
			it "is logged in" do
				get :show, id: FactoryGirl.create(:tweet, user: subject.current_user)
				subject.current_user.should_not be_nil
			end

			context "with a valid tweet ID" do
				before :each do
					@tweet = FactoryGirl.create(:tweet, user: subject.current_user)
				end

				it "renders the show template" do
					get :show, id: @tweet
					response.should render_template :show
				end

				it "founds a tweet of mine" do
					get :show, id: @tweet
					assigns(:tweet).user.id.should eq(subject.current_user.id)
				end
			end

			context "with an invalid tweet ID or a tweet not mine" do
				it "throws not found exception" do
					expect{
					  get :show, id: 0
					}.to raise_error(ActiveRecord::RecordNotFound)
				end
			end
		end

		describe "on PUT to #update" do
			before :each do
				@tweet = FactoryGirl.create(:tweet, user: subject.current_user)
			end

			it "is logged in" do
				put :update, id: @tweet
				subject.current_user.should_not be_nil
			end

			context "with a valid tweet id of mine" do
				it "founds a tweet of mine" do
					put :update, id: @tweet
					assigns(:tweet).user.id.should eq(subject.current_user.id)
				end

				it "changes the values of the message" do
					put :update, id: @tweet, tweet: FactoryGirl.attributes_for(:tweet, tweet: "new tweet edited")
					@tweet.reload
					@tweet.tweet.should eq("new tweet edited")
				end

				it "redirects to index" do
					put :update, id: @tweet
					response.should redirect_to(tweets_path)
				end

				it "changes/add an image" do
				end
			end

			context "with an invalid tweet or a tweet not mine" do
				it "renders edit" do
					put :update, id: @tweet, tweet: FactoryGirl.attributes_for(:tweet, tweet: nil)
					response.should render_template :edit
				end
			end
		end

		describe "on DELETE on #destroy" do
			it "is logged in" do
				delete :destroy, id: FactoryGirl.create(:tweet, user: subject.current_user)
				subject.current_user.should_not be_nil
			end

			context "with a valid id of mine" do
				before :each do
					@tweet = FactoryGirl.create(:tweet, user: subject.current_user)
				end

				it "founds a tweet of mine" do
					delete :show, id: @tweet
					assigns(:tweet).user.id.should eq(subject.current_user.id)
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

	context "user not logged in" do
		it "redirects to login page from index" do
			get :index
			response.should redirect_to new_user_session_path
		end

		it "redirects to login page from show" do
			get :show, id: FactoryGirl.create(:tweet)
			response.should redirect_to new_user_session_path
		end

		it "redirects to login page from edit" do
			get :edit, id: FactoryGirl.create(:tweet)
			response.should redirect_to new_user_session_path
		end
	end
end
