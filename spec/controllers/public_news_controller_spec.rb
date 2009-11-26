require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItemsController do
	it { should route(:get, '/news').to(:controller => :news_items, :action => :index) }
	
	describe 'index' do
		it 'should expose an array of news_items in @news_items' do
			2.times { Factory.create(:news_item, :is_private => false) }
			get :index
			assigns(:stories).collect do |item|
				item.class == NewsItem
			end.uniq.should == [true]
		end
		
		it 'should expose only ten stories in @stories' do
			11.times { Factory.create(:news_item, :is_private => false) }   # An abundance of news items.
			get :index
			assigns(:stories).length.should equal(10)
		end
		
		it 'should expose only the ten most recent NewsItems' do
		  # Create a pretend set of news items that are "Recent".
			NewsItem.delete_all
		  10.times { Factory.create(:news_item, :date => Date.today, :is_private => false) }
			non_recent_item = Factory.create(:news_item, :date => Date.yesterday, :is_private => false)
	    
			get :index
			assigns(:stories).should_not include(non_recent_item)
		end
		
		it 'should only expose public news items' do
			# Create a recent item which is also private
			private_item = unless NewsItem.recent.first.nil?
				Factory.create(:news_item, :is_private => true, :date => NewsItem.recent.first.date + 1.day)
			else
				Factory.create(:news_item, :is_private => true)
			end
			
			get :index
			assigns(:stories).should_not include(private_item)
		end
	end
end