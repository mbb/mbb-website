require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	context '(in general)' do
		it { should have_many(:members) }
		it { should have_db_column(:instrument) }
		it { should validate_presence_of(:instrument) }
	end
	
	context 'with no attributes' do
		subject { Section.new }
		
		it { should have_at_least(1).error_on(:instrument) }
		it { should have(:no).errors_on(:members) }
	end
	
	context 'with valid attributes' do
		subject { Section.new(@valid_attributes) }
		
		it { should be_valid }
		it { lambda { subject.save }.should_not raise_error }
		
		it 'should print to a string as its instrument' do
			subject.to_s.should equal(subject.instrument)
		end
	end
	
	before(:each) do
		@valid_attributes = {
			:instrument => 'Euphonium'
		}
	end
end
