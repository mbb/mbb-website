class Private::PrivilegesController < PrivateController
	before_filter :require_member_edit_credentials, :only => [:show]
	before_filter :require_privileges, :only => [:edit]
	
	def show
		@member = Member.find(params[:member_id])
	end
end
