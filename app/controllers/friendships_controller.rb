class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Friendship deleted"
    redirect_to controller: :users, action: :show, id: current_user
  end

end
