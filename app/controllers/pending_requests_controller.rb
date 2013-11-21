class PendingRequestsController < ApplicationController
	before_filter :authenticate_user!
  def index
  	@pending_requests = current_user.pending_incoming_requests
	  respond_to do |format|
      format.html
	  	format.js
	  end
  end
end
