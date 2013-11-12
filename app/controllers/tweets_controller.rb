class TweetsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@tweets = current_user.tweets
	end

	def new
		@tweet = current_user.tweets.build
	end

	def create
		@tweet = current_user.tweets.build(params[:tweet])
		if @tweet.save
			flash[:notice] = 'Successfully Saved'
			redirect_to action: "index"
		else
			flash[:errors] = @tweet.errors
			render :new
		end
	end

	def edit
		@tweet = current_user.tweets.find(params[:id])
		if @tweet.user.id != current_user.id
			redirect_to action: :index
		end
	end

	def show
		@tweet = current_user.tweets.find(params[:id])
	end

	def update
		@tweet = current_user.tweets.find(params[:id])
		if @tweet.update_attributes(params[:tweet])
			flash[:notice] = 'Successfully Updated'
  			redirect_to action: :index
	  	else
	  		flash[:errors] = @tweet.errors
	  		render :edit
	  	end
	end

	def destroy
		@tweet = current_user.tweets.find(params[:id])
    	@tweet.destroy
    	flash[:notice] = 'Tweet Deleted'
    	redirect_to action: :index
	end
end