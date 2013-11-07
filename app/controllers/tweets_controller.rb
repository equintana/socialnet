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
			redirect_to action: "index"
		else
			flash[:errors] = @tweet.errors
			redirect_to action: "new"
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
  		redirect_to action: :index
  	else
  		redirect_to action: :edit
  	end
	end

	def destroy
		@tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to action: :index
	end
end