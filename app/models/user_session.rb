class UserSession < Authlogic::Session::Base
	authenticate_with Member
end