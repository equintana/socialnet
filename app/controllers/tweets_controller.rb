class TweetsController < ApplicationController

	def index
		@tweets = Tweet.all
	end

	def new
		@tweet = Tweet.new
	end

	def create
		@tweet = Tweet.new(params[:tweet])
		if @tweet.save
			flash[:notice] = 'Successfully Saved'
			redirect_to tweets_path
		else
			flash[:errors] = @tweet.errors
			redirect_to new_tweet_path
		end
	end

	def show
		@tweet = Tweet.find(params[:id])
	end

	def edit
		@tweet = Tweet.find(params[:id])
  end

  def update
  	@tweet = Tweet.find(params[:id])
  	if @tweet.update(params[:tweet])
  		redirect_to tweets_path
  	else

  	end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to tweets_path
  end

end