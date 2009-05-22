class ConcertsController < ApplicationController
	def index
		redirect_to upcoming_concerts_url
	end
	
	def past
		@concerts = Concert.past
		render :list
	end
	
	def upcoming
		@concerts = Concert.upcoming
		render :list
	end
	
	def next
		@concert = Concert.next
	end
end
