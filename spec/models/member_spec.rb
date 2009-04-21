# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe Member do
	fixtures :members
	fixtures :sections
	
	context '(in general)' do
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
				it "'#{email_str}'" do
					lambda do
						u = create_member(:email => email_str)
						u.errors.on(:email).should		 be_nil
					end.should change(Member, :count).by(1)
				end
			end
		end
		
		describe 'disallows illegitimate emails' do
			['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
			 'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
			 'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
			 # these are technically allowed but not seen in practice:
			 'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
			].each do |email_str|
				it "'#{email_str}'" do
					lambda do
						u = create_member(:email => email_str)
						u.errors.on(:email).should_not be_nil
					end.should_not change(Member, :count)
				end
			end
		end
	end

	context 'with valid attributes' do
		subject { Member.create(@valid_attributes) }
		it { should be_valid }
		it { should generate_a_stable_path_component }
	end

	context 'with an abbreviated' do
		context 'first name' do
			subject { Member.create(@valid_attributes.merge(:name => 'A. Jaworski Smith Sullivan')) }
			it { should be_valid }
			it { should generate_a_stable_path_component }
		end
	
		context 'middle name' do
			subject	{ Member.create(@valid_attributes.merge(:name => 'Anthony J. S. Sullivan')) }
			it { should be_valid }
			it { should generate_a_stable_path_component }
		end
	
		context 'last name' do
			subject	{ Member.create(@valid_attributes.merge(:name => 'Anthony Jaworski Smith S.')) }
			it { should be_valid }
			it { should generate_a_stable_path_component }
		end
	end

	context 'with no middle name' do
		subject { Member.create(@valid_attributes.merge(:name => 'Anthony Sullivan')) }
		it { should be_valid }
		it { should generate_a_stable_path_component }
	end

	context 'with only one name' do
		subject { Member.new(@valid_attributes.merge(:name => 'Anthony')) }
		it { should_not be_valid }
	end

	before(:each) do
		@valid_attributes = {
			:name => 'Anthony Jaworski Smith Sullivan',
			:email => 'ajay@test.net',
			:section => sections(:euphonium)
		}
	end

	describe 'being created' do
		before do
			@member = nil
			@creating_member = lambda do
				@member = create_member
				violated "#{@member.errors.full_messages.to_sentence}" if @member.new_record?
			end
		end

		it 'increments Member#count' do
			@creating_member.should change(Member, :count).by(1)
		end
	end

	it 'resets password' do
		members(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
		Member.authenticate(members(:quentin).name, 'new password').should == members(:quentin)
	end

	it 'does not rehash password' do
		members(:quentin).update_attributes(:name => 'Quentin Florin')
		Member.authenticate(members(:quentin).name, 'monkey').should == members(:quentin)
	end

	#
	# Authentication
	#
	it 'authenticates member' do
		Member.authenticate(members(:quentin).name, 'monkey').should == members(:quentin)
	end

	it "doesn't authenticate member with bad password" do
		Member.authenticate(members(:quentin).name, 'invalid_password').should be_nil
	end

 if REST_AUTH_SITE_KEY.blank?
	 # old-school passwords
	 it "authenticates a user against a hard-coded old-style password" do
		 Member.authenticate(members(:old_password_holder).name, 'test').should == members(:old_password_holder)
	 end
 else
	 it "doesn't authenticate a user against a hard-coded old-style password" do
		 Member.authenticate(members(:old_password_holder).name, 'test').should be_nil
	 end

	 # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
	 desired_encryption_expensiveness_ms = 0.1
	 it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
		 test_reps = 100
		 start_time = Time.now; test_reps.times{ Member.authenticate('quentin', 'monkey'+rand.to_s) }; end_time	 = Time.now
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

protected
	def create_member(options = {})
		record = Member.new(@valid_attributes.merge(options))
		record.save
		record
	end
end
