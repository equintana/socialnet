class FriendshipRequestsController < ApplicationController
  
  before_filter :authenticate_user!

  def index   
    @users_to_send_frienship_requests = current_user.users_to_send_frienship_requests 
  end

  def create
    @friendship_request = current_user.sent_requests.build(:receiver_user_id => params[:receiver_user_id], :status => 'pending')
    if @friendship_request.save
      flash[:notice] = "Friendship request sended"
      redirect_to friendship_requests_path
    else
      flash[:error] = @friendship_request.errors
      redirect_to friendship_requests_path
    end
  end


  def update
    p "params: #{params}"

    @friendship_request = FriendshipRequest.find(params[:id])
    if @friendship_request.update_attributes(params[:friendship_request])
      if @friendship_request.status == "accepted"
        create_friendship(@friendship_request)
      end
      redirect_to friendship_requests_path
    else
       flash[:errors] = @friendship_request.errors
      redirect_to friendship_requests_path
    end
  end

  private
  def create_friendship(friendship_request)
    @friendship = Friendship.new({user_id: friendship_request.sender_user_id, friend_id: friendship_request.receiver_user_id })
    @friendship.save
  end

end
