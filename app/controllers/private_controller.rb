class PrivateController < ApplicationController
	layout 'private'
	before_filter :require_user
end