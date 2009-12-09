require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	# Basic attributes and validation.
	it { should have_many(:members) }
	it { should have_db_column(:name) }
	it { should have_db_column(:position) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:position) }

	# Ordering properties
	it 'should respond to #all with sections appearing in order' do
		sections = [Factory(:section), Factory(:section)]
		sections[1].move_to_top # Rearrange so it's not just ordered by ID.
		
		sections_in_order = Section.all.sort {|a, b| a.position <=> b.position}
		section_dot_all = Section.all
		section_dot_all.should eql sections_in_order
	end
	
	it 'should respond to #find with sections appearing in order' do
		sections = [Factory(:section), Factory(:section)]
		sections[1].move_to_top # Rearrange so it's not just ordered by ID.
		
		sections_in_order = Section.all.sort {|a, b| a.position <=> b.position}
		section_dot_find = Section.find(:all)
		section_dot_find.should eql sections_in_order
	end
		
	# Output properties.
	it 'should print to a string as its instrument' do
		section = Factory(:section)
		section.to_s.should == section.name
	end
	
end
