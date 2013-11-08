class TweetsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@tweets = User.find(current_user.id).tweets
	end

	def new
		@tweet = Tweet.new
	end

	def create
		@tweet = Tweet.new(params[:tweet])
		if @tweet.save
			flash[:notice] = 'Successfully Saved'
			redirect_to action: "index"
		else
			flash[:errors] = @tweet.errors
			render :new
		end
	end

	def edit
		@tweet = Tweet.find(params[:id])
	end

	def show
		@tweet = Tweet.find(params[:id])
	end

	def update
		@tweet = Tweet.find(params[:id])
		if @tweet.update_attributes(params[:tweet])
			flash[:notice] = 'Successfully Updated'
  			redirect_to action: :index
	  	else
	  		flash[:errors] = @tweet.errors
	  		render :edit
	  	end
	end

	def destroy
		@tweet = Tweet.find(params[:id])
    	@tweet.destroy
    	flash[:notice] = 'Tweet Deleted'
    	redirect_to action: :index
	end
end