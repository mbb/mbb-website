class NewsItemsController < ApplicationController
	def index
		@stories = NewsItem.find(:all, :limit => 10)
	end
end
