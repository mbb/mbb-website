require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Story do
	it { should have_db_column(:title) }
	it { should have_db_column(:date) }
	it { should have_db_column(:body) }
	
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:date) }
	it { should validate_presence_of(:body) }
	
	context 'with a valid date' do
		subject { Story.new(:date => 'April 4, 2009') }
		
		it 'should print its date to a string in a nice format' do
			subject.date.to_s.should eql('April 4, 2009')
		end
	end
end
