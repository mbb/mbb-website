# This controller handles the login/logout function of the site.	
class UserSessionsController < ApplicationController
	before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :only => :destroy

	def new
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			flash[:notice] = 'Logged in successfully!'
			redirect_back_or_default private_news_items_path
		else
			note_failed_signin
			render :action => :new
		end
	end

	def destroy
		current_user_session.destroy
		flash[:notice] = "You have been logged out."
		session[:return_to] = nil
		redirect_back_or_default(root_url)
	end

protected
	# Track failed login attempts
	def note_failed_signin
		logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
	end
end
