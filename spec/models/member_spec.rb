# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../sample_data/phone_numbers'

describe Member do
	# Basic columns and validations
	it { should belong_to(:section) }
	it { should have_db_column(:name) }
	it { should have_db_column(:email) }
	it { should have_db_column(:biography) }
	it { should respond_to(:privileged?) }
	it { should validate_presence_of(:section) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:email) }
	it { should_not validate_presence_of(:phone_number) }
	it { should_not validate_presence_of(:password) }
	it { should_not validate_presence_of(:password_confirmation) }
	it { should_not validate_presence_of(:biography) }
	
	#
	# Default values assumed by the application.
	#
	it 'should assume that members are unprivileged, by default' do
		member = Factory.create(:member, :privileged => nil)
		member.should_not be_privileged
	end
	
	#
	# Verify format of phone number
	# Tests which express what the user should see are at the story/integration
	# level. This is only a valid/invalid specification.
	#
	SampleData::InvalidNorthAmericanPhoneNumbers.each do |example|
		it "should not accept a phone number of #{example.number} because #{example.description}" do
			user = Factory.stub(:member, :phone_number => example.number)
			user.valid? # Triggers validation errors.
			user.should have_at_least(1).errors_on(:phone_number)
		end
	end
	
	#
	# Verify display of phone number versus the internal storage mechanism.
	# Note that we only test that an internal representation is offered, not that it
	#
	it 'should display a phone number in an attractive format' do
		user = Factory.stub(:member, :phone_number => '9099999999')
		user.pretty_phone_number.should == '(909) 999-9999'
	end
	
	#
	# Ordering within a section
	#
	it { should have_db_column(:position) }
	it { should_not validate_presence_of(:position) }
	
	describe 'position' do
		it 'should determine ordering of a section' do
			section = Factory.create(:section)
			2.times { Factory.create(:member, :section => section) }
			section.members[1].move_to_top # Perturb the list
			natural_order = section.members
			sorted_order = natural_order.sort { |a, b| a.position <=> b.position }
			natural_order.should eql(sorted_order)
		end
		
		context 'at record create' do
			it 'should default to something' do
				section = Factory.create(:section)
				Factory.create(:member, :section => section)	# Existing member in section.
				new_member = Factory.create(:member, :section => section)
				new_member.valid? # triggers validations and position setting
				new_member.position.should_not be_nil
			end
			
			it 'should default to the bottom of a full section' do
				section = Factory.create(:section)
				Factory.create(:member, :section => section)	# Existing member in section.
				new_member = Factory.create(:member, :section => section)
				new_member.valid? # triggers validations and position setting
				new_member.last?.should be_true
			end
			
			it 'should be positioned at the top of their section if that section is empty' do
				member = Factory.create(:member, :section => Factory.create(:section))
				member.valid? # triggers validations
				member.position.should be(1)
			end
		end
		
		context 'at record save' do
			context 'without a section change' do
				it 'should not change from the top of the section' do
					section = Factory.create(:section, :members => [Factory(:member), Factory(:member)])
					member = section.members.first
					old_position = member.position
					member.email = 'new@email.com'
					member.save
					member.position.should eql(old_position)
				end

				it 'should not change from the bottom of the section' do
					section = Factory.create(:section, :members => [Factory(:member), Factory(:member)])
					member = section.members.last
					old_position = member.position
					member.email = 'new@email.com'
					member.save
					member.position.should eql(old_position)
				end
			end
			
			context 'with a section change' do
				before :each do
					# Note that this relies on the factory creating linearly-increasing positions for the sections.
					@higher_section = Factory.create(:section)
					@lower_section = Factory.create(:section)
					
					# Some people just to fill in the sections. One per section.
					Factory(:member, :section => @higher_section)
					Factory(:member, :section => @lower_section)
				end
				
				it 'should explicitly remove the member from the old section' do
					moving_member = @lower_section.members.first
					extra_member = Factory.build(:member, :section => nil)
					@lower_section.members << extra_member
					moving_member.section = @higher_section
					@lower_section.members.first.should == extra_member
					@lower_section.members.first.position.should == 1
				end
				
				it 'should place the member at the bottom of a higher section' do
					moving_member = @lower_section.members.first
					last_high_member = @higher_section.members.last
					moving_member.section = @higher_section
					moving_member.higher_item.should == last_high_member
				end
				
				it 'should place the member at the top of a lower section' do
					moving_member = @higher_section.members.last
					first_low_member = @lower_section.members.first
					moving_member.section = @lower_section
					moving_member.lower_item.should == first_low_member
				end
			end
		end
	end
	
	it { should respond_to(:neighbors) }
	context 'in a nonempty section' do
		before :each do
			@the_section = Factory(:section)
			@top_member    = Factory(:member, :section => @the_section)
			@this_member   = Factory(:member, :section => @the_section)
			@bottom_member = Factory(:member, :section => @the_section)
		end
		
		it 'should list only one neighbor when he is the first in the section' do
			@this_member.move_to_top
			@this_member.neighbors.should == [@top_member]
		end
		
		it 'should only list one neighbor when he is the last in the section' do
			@this_member.move_to_bottom
			@this_member.neighbors.should == [@bottom_member]
		end
		
		it 'should list two neighbors in order when he is inbetween them in the section' do
			@this_member.neighbors.should == [@top_member, @bottom_member]
		end
	end
end
