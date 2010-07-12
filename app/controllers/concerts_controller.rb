class ConcertsController < ApplicationController
	before_filter :require_user, :only => [:new, :create, :edit, :update]
	before_filter :require_privileges, :only => [:new, :create, :edit, :update]
	
	# GET /concerts
	def index
		redirect_to upcoming_concerts_url
	end
	
	# GET /concerts/past
	def past
		@concerts = Concert.past
		render :list
	end
	
	# GET /concerts/upcoming
	def upcoming
		@concerts = Concert.upcoming
		render :list
	end
	
	# GET /concerts/next
	def next
		@concert = Concert.next
	end
	
	# GET /concerts/new
	def new
		@concert = Concert.new
	end
	
	# POST /concerts
	def create
		@concert = Concert.new(params[:concert])
		
		if @concert.save
			flash[:notice] = "Added #{@concert} to the schedule!"
			redirect_to concerts_url
		else
			render :new, :status => 400
		end
	end
	
	# GET /concerts/:id/edit
	def edit
		@concert = Concert.find(params[:id])
	end
	
	# PUT /concerts/:id
	def update
		@concert = Concert.find(params[:id])
		
		if @concert.update_attributes(params[:concert])
			flash[:notice] = "Saved your changes to \"#{@concert.title}\"!"
			redirect_to upcoming_concerts_url, :status => 303
		else
			render :edit, :status => 400
		end
	end
	
	private
		def natural_unprivileged_render
			case action_name
			when 'update'
				render :controller => :news_items, :action => :index, :template => '/private/news_items/index', :status => 403
			else
				nil
			end
		end
end
