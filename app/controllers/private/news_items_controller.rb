class Private::NewsItemsController < PrivateController
	before_filter :require_user
	
  def index
    @news_items = NewsItem.recent
  end
end