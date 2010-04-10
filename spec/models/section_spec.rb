require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	# Basic attributes and validation.
	it { should have_many(:members) }
	it { should have_db_column(:name) }
	it { should have_db_column(:position) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:position) }
	
	# Ordering of sections in the band.
	describe 'ordering' do
		it 'should consider low section position numbers to be higher sections' do
			high_section = Factory(:section)
			low_section = Factory(:section)
			high_section.move_to_top
			high_section.should be_above(low_section)
		end
		
		it 'should consider high section position numbers to be a lower sections' do
			high_section = Factory(:section)
			low_section = Factory(:section)
			low_section.move_to_bottom
			low_section.should be_below(high_section)
		end
	end
	
	# Adding members to a section (membership)
	context 'when gaining members' do
		before :each do
			@new_section = Factory(:section)
			@old_section = Factory(:section)
			@moving_member = Factory(:member, :section => @old_section)
			Factory(:member, :section => @new_section)  # Just some extra member.
		end
		
		it 'should remove members from the old section' do
			@new_section.members << @moving_member
			@old_section.members.should_not include(@moving_member)
		end
		
		it 'should not leave their new positions unsaved' do
			@new_section.members << @moving_member
			@moving_member.position_changed?.should be_false
		end
	end
	
	# Moving members to a section (comparative ordering)
	context 'when moving members from one section to another' do
		before :each do
			sections = [Factory(:section), Factory(:section)]
			sections.each { |s| Factory(:member, :section => s) }
			@high_section = sections.sort.first
			@low_section = sections.sort.last
		end
		
		it 'should place the members at the bottom of a higher section' do
			moving_member = @low_section.members.first
			existing_member = @high_section.members.last
			@high_section.members << moving_member
			moving_member.should be_last
		end
		
		it 'should place members at the top of a lower section' do
			moving_member = @high_section.members.last
			existing_member = @low_section.members.first
			@low_section.members << moving_member
			moving_member.should be_first
		end
	end
	
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
