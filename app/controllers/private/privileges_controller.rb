class Private::PrivilegesController < PrivateController
	before_filter :require_privileges
end
