require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	fixtures :sections
	
	context '(in general)' do
		it { should have_many(:members) }
		it { should have_db_column(:instrument) }
		it { should have_db_column(:position) }
		it { should validate_presence_of(:instrument) }
		it { should validate_presence_of(:position) }
		
		it 'should appear in order' do
			sections_in_order = Section.all.sort {|a, b| a.position <=> b.position}
			section_dot_all = Section.all
			section_dot_all.should eql sections_in_order
		end
	end
	
	context 'with no attributes' do
		subject { Section.new }
		
		it { should have(:no).errors_on(:members) }
	end
	
	context 'with valid attributes' do
		subject { Section.new(@valid_attributes) }
		
		it { should be_valid }
		it { lambda { subject.save }.should_not raise_error }
		
		it 'should print to a string as its instrument' do
			subject.to_s.should equal subject.instrument
		end
	end
		
	before(:each) do
		@valid_attributes = {
			:instrument => 'Euphonium',
			:position => 1
		}
	end
end
