class Private::NewsItemsController < ApplicationController
	before_filter :require_user
	
  def index
    @news_items = NewsItem.recent
  end
end