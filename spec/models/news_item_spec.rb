require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItem do
	it { should have_db_column(:title) }
	it { should have_db_column(:date) }
	it { should have_db_column(:body) }
	
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:date) }
	it { should validate_presence_of(:body) }
end
