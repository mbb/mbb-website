class Private::NewsItemsController < PrivateController	
	def index
		@news_items = NewsItem.recent
	end
	
	def new
		@news_item = NewsItem.new
	end
	
	def create
		@news_item = NewsItem.new(params[:news_item])
		
		if @news_item.save
			flash[:notice] = 'News item is posted!'
			redirect_to new_private_news_item_attached_file_url(@news_item)
		else
			flash[:notice] = 'Could not post news item'
			render :new
		end
	end
end