require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItemsController do
	it { should route(:get, '/news').to(:controller => :news, :action => :index) }
	
	describe 'index' do
		fixtures :news_items
		
		before :each do
			get :index
		end
		
		it 'should expose an array of stories in @stories' do
			assigns(:stories).class.should be(Array)
		end
		
		it 'should expose only ten stories in @stories' do
			assigns(:stories).length.should equal(10)
		end
		
		it 'should expose the very last ten stories in @stories' do
			assigns(:stories).should eql(NewsItem.find(:all, :order => 'date DESC', :limit => 10))
		end
	end
end