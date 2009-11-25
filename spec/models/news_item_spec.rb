require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItem do
	it { should have_db_column(:title) }
	it { should have_db_column(:date) }
	it { should have_db_column(:body) }
	
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:date) }
	it { should validate_presence_of(:body) }
	
	describe '"recent" scope' do
		it 'should return only ten stories' do
			11.times { Factory.create(:news_item) }
			NewsItem.recent.length.should == 10
		end
		
		it 'should only return the ten most recent stories' do
			Factory.create(:news_item, :date => Date.yesterday)
			recent_items = []
			10.times { recent_items << Factory.create(:news_item, :date => Date.today) }
			Factory.create(:news_item, :date => Date.yesterday)
			
			NewsItem.recent.should == recent_items
		end
	end
	
end
