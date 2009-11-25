class NewsController < ApplicationController
	def index
		@stories = NewsItem.find(:all, :limit => 10)
	end
end
