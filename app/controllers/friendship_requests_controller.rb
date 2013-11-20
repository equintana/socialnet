class FriendshipRequestsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @users_to_send_frienship_requests = current_user.users_to_send_frienship_requests
  end

  def create
    @friendship_request = current_user.sent_requests.build(:receiver_user_id => params[:receiver_user_id], :status => 'pending')
    if @friendship_request.save
      UserNotifications.friend_request_notification(@friendship_request.receiver_user, current_user).deliver
      flash[:notice] = "Friendship request sended"
      redirect_to friendship_requests_path
    else
      flash[:error] = @friendship_request.errors
      redirect_to friendship_requests_path
    end
  end

  def update
    data = params[:friendship_request]
    @friendship_request = FriendshipRequest.find(params[:id])

    FriendshipRequest.transaction do
      if @friendship_request.update_attributes(:status => data[:status])
        redirect_to friendship_requests_path
      else
        flash[:error] = @friendship_request.errors
        redirect_to friendship_requests_path
      end
    end
  end

end
