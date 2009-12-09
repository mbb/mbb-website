require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section do
	# Basic attributes and validation.
	it { should have_many(:members) }
	it { should have_db_column(:name) }
	it { should have_db_column(:position) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:position) }
	
	# Adding members to a section (w.r.t. ordering)
	context 'when gaining members' do
		before :each do
			@new_section = Factory(:section)
			@old_section = Factory(:section)
			@moving_member = Factory(:member, :section => @old_section)
			Factory(:member, :section => @new_section)  # Just some extra member.
		end
		
		context 'one at a time' do
			it 'should remove members from the old section' do
				@moving_member.should_receive(:remove_from_list)
				@new_section.members << @moving_member
			end

			it 'should place the members at the bottom of the new section' do
				last_position =	@new_section.members.last.position
				@new_section.members << @moving_member
				@moving_member.position.should == last_position + 1
			end
			
			it 'should not leave their new positions unsaved' do
				@new_section.members << @moving_member
				@moving_member.position_changed?.should be_false
			end
		end
		
		context 'all at once' do
			it 'should remove any existing members of the section' do
				former_new_section_members =	@new_section.members
				former_old_section_members = @old_section.members
				@new_section.members = [@moving_member]
				former_new_section_members.each { |m| m.position.should == nil }
			end
			
			it 'should be sure to assign new positions to new members' do
				new_member = Factory.build(:member, :section => nil)
				@new_section.members = [new_member]
				new_member.position.should_not be_nil
			end
			
			it 'should not leave new positions changed?' do
				@new_section.members = [@moving_member]
				@moving_member.position_changed?.should be_false
			end
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
