class AboutController < ApplicationController
	def index
		redirect_to :controller => 'about', :action => 'history'
	end
end