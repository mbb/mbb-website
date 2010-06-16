# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	protect_from_forgery # See ActionController::RequestForgeryProtection for details
	activate_css_auto_include

	filter_parameter_logging :password, :password_confirmation
	helper_method :current_user_session, :current_user, :logged_in?

	private
		def current_user_session
			return @current_user_session if defined?(@current_user_session)
			@current_user_session = UserSession.find
		end

		def current_user
			return @current_user if defined?(@current_user)
			@current_user = current_user_session && current_user_session.member
		end
		
		def logged_in?
			current_user != nil
		end
		
		def require_user
			unless current_user
				store_location
				flash[:notice] = "You must be logged in to access this page"
				redirect_to login_url
				return false
			end
		end
		
		def require_privileges
			unless current_user and current_user.privileged?
				render :nothing => true, :status => :forbidden
				return false
			end
		end
		
		def require_member_edit_credentials
			member_id = params[:member_id] || params[:id] 
			unless current_user.privileged? or member_id == current_user.to_param
				flash[:error] = "You do not have permission to #{action_name.humanize} another member."
				render 'private/rosters/show', :status => :forbidden
				false
			else
				true
			end
		end
		
		def require_no_user
			if current_user
				store_location
				flash[:notice] = "You must be logged out to access this page"
				redirect_back_or_default(member_path(current_user))
				return false
			end
		end

		def store_location
			session[:return_to] = request.request_uri
		end

		def redirect_back_or_default(default)
			redirect_to(session[:return_to] || default, :status => 303)
			session[:return_to] = nil
		end

	helper :application
end
