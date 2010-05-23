class ConcertsController < ApplicationController
	before_filter :require_user, :only => [:new, :create]
	before_filter :require_privileges, :only => [:new, :create]
	
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
			render :new
		end
	end
end
