# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

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
	it { should_not validate_presence_of(:password) }
	it { should_not validate_presence_of(:password_confirmation) }
	it { should_not validate_presence_of(:biography) }
	
	describe 'allows legitimate emails:' do
		['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
		 'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
		 'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
		 'domain@can.haz.many.sub.doma.in', 'student.name@university.edu'
		].each do |email_str|
			it "'#{email_str}' should be allowed" do
				u = create_member(:email => email_str)
				u.should have(:no).errors_on(:email)
			end
		end
	end
	
	describe 'disallows illegitimate emails' do
		['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
		 'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
		 'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com'
		].each do |email_str|
			it "'#{email_str}' should be disallowed" do
				u = create_member(:email => email_str)
				u.should_not have(:no).errors_on(:email)
			end
		end
	end

	# Ordering within a section
	it { should have_db_column(:position) }
	it { should_not validate_presence_of(:position) }
	
	it 'should get a default position at the bottom of the section' do
		member = Member.new(:position => nil, :section => sections(:solo_cornet))
		member.valid? # triggers validations
		member.position.should_not be_nil
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

	# Generation of path components.
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

	#
	# Authentication
	#
	it 'authenticates member' do
		Member.authenticate(members(:quentin).email, 'monkey').should == members(:quentin)
	end

	it "doesn't authenticate member with bad password" do
		Member.authenticate(members(:quentin).email, 'invalid_password').should be_nil
	end

 if REST_AUTH_SITE_KEY.blank?
	 # old-school passwords
	 it "authenticates a user against a hard-coded old-style password" do
		 Member.authenticate(members(:old_password_holder).email, 'test').should == members(:old_password_holder)
	 end
 else
	 it "doesn't authenticate a user against a hard-coded old-style password" do
		 Member.authenticate(members(:old_password_holder).email, 'test').should be_nil
	 end

	 # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
	 desired_encryption_expensiveness_ms = 0.1
	 it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
		 test_reps = 100
		 start_time = Time.now; test_reps.times{ Member.authenticate('quentin@example.com', 'monkey'+rand.to_s) }; end_time	 = Time.now
		 auth_time_ms = 1000 * (end_time - start_time)/test_reps
		 auth_time_ms.should > desired_encryption_expensiveness_ms
	 end
 end

	#
	# Authentication
	#
	it 'sets remember token' do
		members(:quentin).remember_me
		members(:quentin).remember_token.should_not be_nil
		members(:quentin).remember_token_expires_at.should_not be_nil
	end

	it 'unsets remember token' do
		members(:quentin).remember_me
		members(:quentin).remember_token.should_not be_nil
		members(:quentin).forget_me
		members(:quentin).remember_token.should be_nil
	end

	it 'remembers me for one week' do
		before = 1.week.from_now.utc
		members(:quentin).remember_me_for 1.week
		after = 1.week.from_now.utc
		members(:quentin).remember_token.should_not be_nil
		members(:quentin).remember_token_expires_at.should_not be_nil
		members(:quentin).remember_token_expires_at.between?(before, after).should be_true
	end

	it 'remembers me until one week' do
		time = 1.week.from_now.utc
		members(:quentin).remember_me_until time
		members(:quentin).remember_token.should_not be_nil
		members(:quentin).remember_token_expires_at.should_not be_nil
		members(:quentin).remember_token_expires_at.should == time
	end

	it 'remembers me default two weeks' do
		before = 2.weeks.from_now.utc
		members(:quentin).remember_me
		after = 2.weeks.from_now.utc
		members(:quentin).remember_token.should_not be_nil
		members(:quentin).remember_token_expires_at.should_not be_nil
		members(:quentin).remember_token_expires_at.between?(before, after).should be_true
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
