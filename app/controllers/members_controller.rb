class MembersController < ApplicationController	
	before_filter :require_user, :except => [:index, :show]
	before_filter :require_member_edit_credentials, :only => [:edit, :update, :new, :create, :destroy, :move_up, :move_down]
	before_filter :update_identifier, :only => [:show, :edit]
	
	# GET /members
	# GET /members.xml
	def index
		@members = Member.find(:all)

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @members }
		end
	end

	# GET /members/john-smith
	# GET /members/john-smith.xml
	def show
		@member = Member.find(params[:id])
		
		unless @member.nil?
			respond_to do |format|
				format.html # show.html.erb
				format.xml	{ render :xml => @member }
			end
		else
			flash[:error] = "The member page you bookmarked no longer exists."
			redirect_to home_url
		end
	end

	# GET /private/members/new
	# GET /private/members/new.xml
	def new
		@member = Member.new(params[:member])
		
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
				format.html { redirect_to(private_roster_url) }
				format.xml	{ head :ok }
			end
		else
			flash[:error]	= "Could not create a new member account for #{@member.name}."
			render :action => 'new'
		end
	end
	
	# GET /private/members/john-smith/edit
	# GET /private/members/john-smith/edit.xml
	def edit
		@member = Member.find(params[:id])
		
		respond_to do |format|
			format.html # edit.html.erb
			format.js	 { render :partial => 'edit_form.html.erb', :member => @member }
		end
	end

	# PUT /private/members/john-smith
	# PUT /private/members/john-smith.json
	def update
		@member = Member.find(params[:id])
		
		if params[:member].has_key?(:section_id) and @member.section_id != params[:member][:section_id]
			# Don't allow unprivileged members to do this!
			unless current_user.privileged?
				render 'members/show', :status => :forbidden
				return
			end
			
			# Change the member's section.
			new_section = Section.find(params[:member][:section_id])
			params[:member].delete(:section_id)
			params[:member][:section] = new_section
		end
		
		# Update the position within the section, if sent
		if (params[:member].has_key?(:position) and params[:member][:position].is_a?(Hash))
			replaced_member = Member.find(params[:member][:position][:before])
			@new_position = replaced_member.position
			params[:member].delete(:position)
		end
		
		respond_to do |wants|
			if @member.update_attributes(params[:member])
				@member.insert_at(@new_position) unless @new_position.nil?
				flash[:notice] = 'Member was successfully updated.'
				wants.html { redirect_back_or_default(member_path(@member)) }
				wants.json { head :ok }
			else
				wants.html { render :action => "edit", :status => :bad_request }
				wants.json { head :bad_request }
			end
		end
	end
	
	# PUT /private/members/Quentin_Daniels/move_up (rjs)
	def move_up
		@member = Member.find(params[:id])
		old_position = @member.position
		@member.move_higher
		@position_changed = (old_position != @member.reload.position)
		
		respond_to do |wants|
			wants.html { redirect_to private_roster_url }
			wants.js   { render 'private/rosters/move_up' }
		end
	end
	
	# PUT /private/members/Quentin_Daniels/move_down (rjs)
	def move_down
		@member = Member.find(params[:id])
		old_position = @member.position
		@member.move_lower
		@position_changed = (old_position != @member.reload.position)
		
		respond_to do |wants|
			wants.html { redirect_to private_roster_url }
			wants.js   { render 'private/rosters/move_down' }
		end
	end
	
	private
		def update_identifier
			if MembersHelper.bad_identifier?(params[:id])
				new_params = MembersHelper.update_identifier(params)
				
				unless new_params == params
					redirect_to new_params, :status => :moved_permanently
				else
					flash[:error] = 'No member exists at this URL; are they currently a member?'
					render :index, :status => :gone
				end
			end
		end
end
