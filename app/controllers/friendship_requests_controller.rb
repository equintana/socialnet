class FriendshipRequestsController < ApplicationController
  
  before_filter :authenticate_user!

  def index   
    @not_friends_without_request = current_user.users_to_send_friendship_requests 
  end

  def create
    @friendship_request = current_user.sent_requests.build(:receiver_user_id => params[:receiver_user_id], :status => 'pending')
    if @friendship_request.save
      flash[:notice] = "Friendship request sended"
      redirect_to tweets_path
    else
      flash[:error] = 'Friendship request no sended'
      redirect_to tweets_path
    end
  end

  def update
  end

end
