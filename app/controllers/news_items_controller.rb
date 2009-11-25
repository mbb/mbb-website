class NewsItemsController < ApplicationController
	def index
		@stories = NewsItem.recent
	end
end
