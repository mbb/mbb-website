class NewsController < ApplicationController
	def index
		@stories = Story.find(:all, :limit => 10)
	end
end
