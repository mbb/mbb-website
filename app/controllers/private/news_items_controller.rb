class Private::NewsItemsController < PrivateController	
  def index
    @news_items = NewsItem.recent
  end
end