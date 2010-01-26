require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Private::NewsItemsController do
	describe 'routing' do
		it { should route(:get,    '/private/news_items'  ).to(:controller => 'private/news_items', :action => :index  ) }
		it { should route(:post,   '/private/news_items'  ).to(:controller => 'private/news_items', :action => :create ) }
		it { should route(:get,    '/private/news_items/1').to(:controller => 'private/news_items', :action => :show,    :id => 1 ) }
		it { should route(:delete, '/private/news_items/1').to(:controller => 'private/news_items', :action => :destroy, :id => 1 ) }
		it { should route(:put,    '/private/news_items/1').to(:controller => 'private/news_items', :action => :update,	 :id => 1 ) }
	end
	
	setup :activate_authlogic
	
	context 'when logged in' do
		before :each do login end
		
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
				10.times { recent_news_items << Factory.build(:news_item, :created_at => Date.today) }
				NewsItem.stub(:recent).and_return(recent_news_items)  # the "recent" scope
				
				get :index
				assigns(:news_items).should eql(recent_news_items)
			end
			
			it 'should expose public news items' do
				# Create a recent item which is also private
				public_item = unless NewsItem.recent.first.nil?
					Factory.create(:news_item, :is_private => true, :created_at => NewsItem.recent.first.date + 1.day)
				else
					Factory.create(:news_item, :is_private => false)
				end
				
				get :index
				assigns(:news_items).should include(public_item)
			end
			
			it 'should expose private news items' do
				# Create a recent item which is also private
				private_item = unless NewsItem.recent.first.nil?
					Factory.create(:news_item, :is_private => true, :created_at => NewsItem.recent.first.date + 1.day)
				else
					Factory.create(:news_item, :is_private => true)
				end
				
				get :index
				assigns(:news_items).should include(private_item)
			end
		end
	end
	
	context 'when not logged in' do
		# All of this is provided and tested by AuthLogic. If anything, we test the methods of
		# ApplicationController (e.g. the require_user filter).
	end
end
