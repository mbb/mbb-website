require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	fixtures :sections
	
	# Basic attributes and validation.
	it { should have_many(:members) }
	it { should have_db_column(:name) }
	it { should have_db_column(:position) }
	it { should have_db_column(:parent_id) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:position) }
	it { should_not validate_presence_of(:parent_id) }
	
	# Sections should be hierarchical.
	it { should respond_to(:children) }
	it { should respond_to(:parent) }

	# Ordering properties
	it 'should respond to #all with only the top level of sections' do
		sections_with_parent_ids = Section.all.delete_if { |s| s.parent_id.nil? }
		sections_with_parent_ids.should be_empty
	end
	
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
	
	it 'should list children in order' do
		natural_children = Section.find_by_name('Cornet').children
		sorted_children = natural_children.sort { |a, b| a.position <=> b.position }
		natural_children.should eql(sorted_children)
	end
		
	# Output properties.
	context 'with a valid name' do
		subject { Section.new(:name => 'Something') }
		
		it 'should print to a string as its instrument' do
			subject.to_s.should equal subject.name
		end
	end
	
end
