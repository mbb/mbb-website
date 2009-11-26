class NewsItemsController < ApplicationController
	def index
		@stories = NewsItem.recent.public_items
	end
end
