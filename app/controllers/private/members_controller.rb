class Private::MembersController < ApplicationController
	before_filter :login_required
	before_filter :must_be_this_member_or_board, :only => [:edit, :update]
	require_role 'Roster Adjustment', :only => [:new, :create, :destroy, :move_up, :move_down]
	helper 'private/members'
	
	# GET /private/members
	# GET /private/members.json
	def index
		if (params.has_key? :section)
			@members = Section.find(params[:section]).members
		else
			@members = Member.find(:all)
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render :json => @members }
		end
	end

	# GET /private/members/john_smith
	# GET /private/members/john_smith.xml
	def show
		@member = Member.find_by_path_component(params[:id])
	
		respond_to do |format|
			format.html # show.html.erb
			format.xml	{ render :xml => @member }
		end
	end

	# GET /private/members/new
	# GET /private/members/new.xml
	def new
		@member = Member.new
		
		respond_to do |format|
			format.html # new.html.erb
			format.xml	{ render :xml => @member }
		end
	end
 
	# POST /private/members
	# POST /private/members.xml
	def create
		@member = Member.new(params[:member])
		success = @member && @member.save
		if success && @member.errors.empty?
			# Protects against session fixation attacks, causes request forgery
			# protection if visitor resubmits an earlier form using back
			# button. Uncomment if you understand the tradeoffs.
			# reset session
			flash[:notice] = "#{@member.name} has been added to the band!"
			
			respond_to do |format|
				format.html { redirect_to(private_members_url) }
				format.xml	{ head :ok }
			end
		else
			flash[:error]	= "Could not create a new member account for #{@member.name}."
			render :action => 'new'
		end
	end
	
	# GET /private/members/john_smith/edit
	# GET /private/members/john_smith/edit.xml
	def edit
		@member = Member.find_by_path_component(params[:id])
		
		respond_to do |format|
			format.html # edit.html.erb
			format.xml	{ render :xml => @member }
		end
	end

	# PUT /private/members/john_smith
	# PUT /private/members/john_smith.xml
	def update
		@member = Member.find_by_path_component(params[:id])
	
		respond_to do |format|
			if @member.update_attributes(params[:member])
				flash[:notice] = 'Member was successfully updated.'
				format.html { redirect_to private_member_path(@member) }
				format.xml	{ head :ok }
			else
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @member.errors, :status => :unprocessable_entity }
			end
		end
	end
	
	# PUT /private/members/Quentin_Daniels/move_up (rjs)
	def move_up
		@member = Member.find_by_path_component(params[:id])
		old_position = @member.position
		@member.move_higher
		@position_changed = (old_position != @member.reload.position)
	end
	
	# PUT /private/members/Quentin_Daniels/move_down (rjs)
	def move_down
		@member = Member.find_by_path_component(params[:id])
		old_position = @member.position
		@member.move_lower
		@position_changed = (old_position != @member.reload.position)
	end
	
	private
		def must_be_this_member_or_board
			unless current_member.has_role?('board') or params[:id] == current_member.to_pc
				flash[:error] = "You do not have permission to #{action_name} another member."
				redirect_to private_members_path
				false
			else
				true
			end
		end
end
