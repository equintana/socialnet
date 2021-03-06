class TweetsController < ApplicationController

	before_filter :authenticate_user!

	def index
	#	@tweets = current_user.tweets
		@tweets = current_user.timeline
		@tweet = current_user.tweets.build
	end

	def new
		@tweet = current_user.tweets.build
	end

	def create
		@tweet = current_user.tweets.build(params[:tweet])

    if @tweet.save
    	flash[:notice] = 'Your tweet was saved'
      	redirect_to action: :index unless request.xhr?
    else
    	flash[:error] = 'We could not save yor tweet'
      	render action: "new" unless request.xhr?
    end

		# respond_to do |format|
  #   if @tweet.save
  #     format.html { redirect_to action: :index, notice: 'Your tweet was saved' }
  #     format.js
  #     format.json { render json: @tweet, status: :created, location: @tweet }
  #   else
  #     format.html { render action: "new" }
  #     format.json { render json: @tweet.errors, status: :unprocessable_entity }
  #   end
  # end

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