class ConcertsController < ApplicationController
	def index
		redirect_to next_concerts_url
	end
end
