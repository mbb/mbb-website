require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Private::NewsItemsController do
	it { should route(:get,    '/private/news_items'  ).to(:controller => 'private/news_items', :action => :index  ) }
	it { should route(:post,   '/private/news_items'  ).to(:controller => 'private/news_items', :action => :create ) }
	it { should route(:get,    '/private/news_items/1').to(:controller => 'private/news_items', :action => :show,    :id => 1 ) }
	it { should route(:delete, '/private/news_items/1').to(:controller => 'private/news_items', :action => :destroy, :id => 1 ) }
	it { should route(:put,    '/private/news_items/1').to(:controller => 'private/news_items', :action => :update,	 :id => 1 ) }
	
	describe 'index' do
		it 'should expose an array of news_items in @news_items' do
			2.times { Factory.create(:news_item) }
			get :index
			assigns(:news_items).collect do |item|
				item.class == NewsItem
			end.uniq.should == [true]
		end
		
		it 'should expose only ten stories in @stories' do
			11.times { Factory.create(:news_item) }   # An abundance of news items.
			get :index
			assigns(:news_items).length.should equal(10)
		end
		
		it 'should expose only the "recent" NewsItems' do
		  # Create a pretend set of news items that are "Recent".
		  # (Don't save them, so they only exist if the correct scope is applied.)
		  recent_news_items = Array.new
		  10.times { recent_news_items << Factory.build(:news_item, :date => Date.today) }
		  NewsItem.stub(:recent).and_return(recent_news_items)  # the "recent" scope
	    
			get :index
			assigns(:news_items).should eql(recent_news_items)
		end
	end
end