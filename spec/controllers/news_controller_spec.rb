require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItemsController do
	it { should route(:get, '/news').to(:controller => :news_items, :action => :index) }
	
	describe 'index' do
		it 'should expose an array of news_items in @news_items' do
			2.times { Factory.create(:news_item) }
			get :index
			assigns(:stories).collect do |item|
				item.class == NewsItem
			end.uniq.should == [true]
		end
		
		it 'should expose only ten stories in @stories' do
			11.times { Factory.create(:news_item) }   # An abundance of news items.
			get :index
			assigns(:stories).length.should equal(10)
		end
		
		it 'should expose only the "recent" NewsItems' do
		  # Create a pretend set of news items that are "Recent".
		  # (Don't save them, so they only exist if the correct scope is applied.)
		  recent_news_items = Array.new
		  10.times { recent_news_items << Factory.build(:news_item, :date => Date.today) }
		  NewsItem.stub(:recent).and_return(recent_news_items)  # the "recent" scope
	    
			get :index
			assigns(:stories).should eql(recent_news_items)
		end
	end
end