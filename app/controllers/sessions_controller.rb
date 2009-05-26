# This controller handles the login/logout function of the site.	
class SessionsController < ApplicationController
	# Be sure to include AuthenticationSystem in Application Controller instead
	include AuthenticatedSystem

	# render new.rhtml
	def new
	end

	def create
		logout_keeping_session!
		member = Member.authenticate(params[:name], params[:password])
		if member
			# Protects against session fixation attacks, causes request forgery
			# protection if user resubmits an earlier form using back
			# button. Uncomment if you understand the tradeoffs.
			# reset_session
			self.current_member = member
			new_cookie_flag = true
			handle_remember_cookie! new_cookie_flag
			redirect_back_or_default private_member_path(member)
			flash[:notice] = "Logged in successfully"
		else
			note_failed_signin
			@name			 = params[:name]
			render :action => 'new'
		end
	end

	def destroy
		logout_killing_session!
		flash[:notice] = "You have been logged out."
		session[:return_to] = nil
		redirect_back_or_default('/')
	end

protected
	# Track failed login attempts
	def note_failed_signin
		flash[:error] = "Couldn't log you in as '#{params[:name]}'"
		logger.warn "Failed login for '#{params[:name]}' from #{request.remote_ip} at #{Time.now.utc}"
	end
end
