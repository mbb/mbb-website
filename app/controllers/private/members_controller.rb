class Private::MembersController < ApplicationController
	before_filter :login_required
	require_role 'board', :only => [:new, :create, :edit, :update]
	
	# GET /private/members
	# GET /private/members.xml
	def index
		@members = Member.find(:all)

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @members }
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
				format.html { redirect_to(@member) }
				format.xml	{ head :ok }
			else
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @member.errors, :status => :unprocessable_entity }
			end
		end
	end
end
