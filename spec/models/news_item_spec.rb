require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItem do
	it { should have_db_column(:title) }
	it { should have_db_column(:date) }
	it { should have_db_column(:body) }
	it { should have_db_column(:is_private) }
	it { should respond_to(:is_private?) }
	
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:date) }
	it { should validate_presence_of(:body) }
	
	describe 'scoped by' do
		subject { NewsItem }
		
		describe '"recent"' do
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

		describe '"private_items"' do
			it { should respond_to(:private_items) }

			it 'should not return records with the "is_private" flag set to false' do
				public_item = Factory.create(:news_item, :is_private => false)
				NewsItem.private_items.should_not include(public_item)
			end

			it 'should return items with the "is_private" flag set to true' do
				private_item = Factory.create(:news_item, :is_private => true)
				NewsItem.private_items.should include(private_item)
			end
		end

		describe '"public_items"' do
			it { should respond_to(:public_items) }

			it 'should not return records with the "is_private" flag set to true' do
				private_item = Factory.create(:news_item, :is_private => true)
				NewsItem.public_items.should_not include(private_item)
			end

			it 'should return items with the "is_private" flag set to false' do
				public_item = Factory.create(:news_item, :is_private => false)
				NewsItem.public_items.should include(public_item)
			end
		end
	end
	
end
