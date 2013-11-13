class PagesController < ApplicationController
	before_filter :redirect_to_tweets
  def index
  end

  def redirect_to_tweets
  	redirect_to tweets_path if user_signed_in?
  end
end
