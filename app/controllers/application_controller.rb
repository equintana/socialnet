class ApplicationController < ActionController::Base
  protect_from_forgery

	def after_sign_in_path_for(resource)
		tweets_path
	end

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
