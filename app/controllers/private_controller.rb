class PrivateController < ApplicationController
	before_filter :require_user
end