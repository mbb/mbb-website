class Private::RostersController < ApplicationController
	before_filter :login_required
			
	# GET /private/roster
	# GET /private/roster.json
	def show
		@sections = Section.all

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render :json => @members }
		end
	end

end
