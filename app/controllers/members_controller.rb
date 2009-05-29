class MembersController < ApplicationController
	helper :members
	
	# GET /members
	# GET /members.xml
	def index
		@members = Member.find(:all)

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @members }
		end
	end

	# GET /members/john_smith
	# GET /members/john_smith.xml
	def show
		@member = Member.find_by_path_component(params[:id])
	
		respond_to do |format|
			format.html # show.html.erb
			format.xml	{ render :xml => @member }
		end
	end
end
