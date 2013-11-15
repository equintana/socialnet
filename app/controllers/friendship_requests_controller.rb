class FriendshipRequestsController < ApplicationController
  
  before_filter :authenticate_user!

  def index
    @users_not_friends = User.not_friends(current_user)
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
