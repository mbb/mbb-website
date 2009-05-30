require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	fixtures :sections
	
	# Basic attributes and validation.
	it { should have_many(:members) }
	it { should have_db_column(:name) }
	it { should have_db_column(:position) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:position) }

	# Ordering properties
	it 'should respond to #all with sections appearing in order' do
		sections_in_order = Section.all.sort {|a, b| a.position <=> b.position}
		section_dot_all = Section.all
		section_dot_all.should eql sections_in_order
	end
	
	it 'should respond to #find with sections appearing in order' do
		sections_in_order = Section.all.sort {|a, b| a.position <=> b.position}
		section_dot_find = Section.find(:all)
		section_dot_find.should eql sections_in_order
	end
		
	# Output properties.
	context 'with a valid name' do
		subject { Section.new(:name => 'Something') }
		
		it 'should print to a string as its instrument' do
			subject.to_s.should equal subject.name
		end
	end
	
end
