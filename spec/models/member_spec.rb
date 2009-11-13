# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../sample_data/phone_numbers'

describe Member do
	fixtures :members
	fixtures :sections

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
      user = Member.new(:phone_number => example.number)
      user.valid? # Triggers validation errors.
      user.should have_at_least(1).errors_on(:phone_number)
    end
  end
  
  #
  # Verify display of phone number versus the internal storage mechanism.
  # Note that we only test that an internal representation is offered, not that it
  #
  it 'should display a phone number in an attractive format' do
    user = Member.new(:phone_number => '9099999999')
    user.pretty_phone_number.should == '(909) 999-9999'
  end

  #
	# Ordering within a section
	#
	it { should have_db_column(:position) }
	it { should_not validate_presence_of(:position) }
	
	it 'should get a default position at the bottom of the section' do
		member = Member.new(:position => nil, :section => sections(:solo_cornet))
		member.valid? # triggers validations
		member.position.should_not be_nil
	end
	
	it 'should be positioned at the top of their section if that section is empty' do
		member = Member.new(:position => nil, :section => Section.create!(:name => 'Penis', :position => 1000))
		member.valid? # triggers validations
		member.position.should be(1)
	end
	
	it 'should be listed in order within their section' do
		natural_order = sections(:euphonium).members
		sorted_order = natural_order.sort { |a, b| a.position <=> b.position }
		natural_order.should eql(sorted_order)
	end
	
	describe 'upon saving' do
		it 'should not be re-ordered (from the top)' do
			cornet_1 = sections(:solo_cornet).members.first
			old_position = cornet_1.position
			cornet_1.email = 'new@email.com'
			cornet_1.save
			cornet_1.position.should eql(old_position)
		end
		
		it 'should not be re-ordered (from the bottom)' do
			cornet_last = sections(:solo_cornet).members.last
			old_position = cornet_last.position
			cornet_last.email = 'new@email.com'
			cornet_last.save
			cornet_last.position.should eql(old_position)
		end
	end

  #
	# Generation of path components.
	#
	context 'with valid attributes' do
		subject { Member.create(@valid_attributes) }
		it { should generate_a_stable_path_component }
	end

	context 'with an abbreviated' do
		context 'first name' do
			subject { Member.create(@valid_attributes.merge(:name => 'A. Jaworski Smith Sullivan')) }
			it { should have(:no).errors_on(:name) }
			it { should generate_a_stable_path_component }
		end
	
		context 'middle name' do
			subject	{ Member.create(@valid_attributes.merge(:name => 'Anthony J. S. Sullivan')) }
			it { should have(:no).errors_on(:name) }
			it { should generate_a_stable_path_component }
		end
	
		context 'last name' do
			subject	{ Member.create(@valid_attributes.merge(:name => 'Anthony Jaworski Smith S.')) }
			it { should have(:no).errors_on(:name) }
			it { should generate_a_stable_path_component }
		end
	end

	context 'with no middle name' do
		subject { Member.create(@valid_attributes.merge(:name => 'Anthony Sullivan')) }
		it { should have(:no).errors_on(:name) }
		it { should generate_a_stable_path_component }
	end

	context 'with only one name' do
		subject { Member.new(@valid_attributes.merge(:name => 'Anthony')) }
		it { should_not have(:no).errors_on(:name) }
	end

	it 'resets password when given a new password and confirmation' do
		members(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
		Member.authenticate(members(:quentin).email, 'new password').should == members(:quentin)
	end

	it 'does not rehash password when updating the name' do
		members(:quentin).update_attributes(:name => 'Quentin Florin')
		Member.authenticate(members(:quentin).email, 'monkey').should == members(:quentin)
	end
	
	before(:each) do
		@valid_attributes = {
			:name => 'Anthony Jaworski Smith Sullivan',
			:email => 'ajay@test.net',
			:section => sections(:euphonium)
		}
	end

protected
	def create_member(options = {})
		record = Member.new(@valid_attributes.merge(options))
		record.save
		record
	end
end
