# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../sample_data/phone_numbers'

describe Member do

	# Basic columns and validations
	it { should belong_to(:section) }
	it { should have_db_column(:name) }
	it { should have_db_column(:email) }
	it { should have_db_column(:biography) }
	it { should validate_presence_of(:section) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:email) }
	it { should_not validate_presence_of(:phone_number) }
	it { should_not validate_presence_of(:password) }
	it { should_not validate_presence_of(:password_confirmation) }
	it { should_not validate_presence_of(:biography) }
	
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
	
	describe 'position in section' do
		it 'should default to something' do
			section = Factory.create(:section)
			Factory.create(:member, :section => section)  # Existing member in section.
			new_member = Factory.create(:member, :section => section)
			new_member.valid? # triggers validations and position setting
			new_member.position.should_not be_nil
		end
		
		it 'should default to the bottom of the list' do
			section = Factory.create(:section)
			Factory.create(:member, :section => section)  # Existing member in section.
			new_member = Factory.create(:member, :section => section)
			new_member.valid? # triggers validations and position setting
			new_member.last?.should be_true
		end
	end
	
	it 'should be positioned at the top of their section if that section is empty' do
		member = Factory.create(:member, :section => Factory.create(:section))
		member.valid? # triggers validations
		member.position.should be(1)
	end
	
	it 'should be listed in order within their section' do
		section = Factory.create(:section)
		section.members = [Factory.create(:member), Factory.create(:member)]
		section.members[1].move_to_top
		natural_order = section.members
		sorted_order = natural_order.sort { |a, b| a.position <=> b.position }
		natural_order.should eql(sorted_order)
	end
	
	describe 'upon saving' do
		it 'should not be re-ordered (from the top)' do
			section = Factory.create(:section, :members => [Factory(:member), Factory(:member)])
			member = section.members.first
			old_position = member.position
			member.email = 'new@email.com'
			member.save
			member.position.should eql(old_position)
		end
		
		it 'should not be re-ordered (from the bottom)' do
			section = Factory.create(:section, :members => [Factory(:member), Factory(:member)])
			member = section.members.last
			old_position = member.position
			member.email = 'new@email.com'
			member.save
			member.position.should eql(old_position)
		end
	end

end
