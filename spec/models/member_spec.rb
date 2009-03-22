require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
	fixtures :sections
	
	context '(in general)' do
		it { should belong_to(:section) }
		it { should have_db_column(:first_name) }
		it { should have_db_column(:middle_names) }
		it { should have_db_column(:last_name) }
		it { should have_db_column(:biography) }
		it { should validate_presence_of(:section) }
		it { should validate_presence_of(:first_name) }
		it { should validate_presence_of(:last_name) }
	end
	
	context 'without any attributes' do
		subject { Member.new }
		it { should have_at_least(1).error_on(:section) }
		it { should have_at_least(1).error_on(:first_name) }
		it { should have_at_least(1).error_on(:last_name) }
		it { should have(:no).errors_on(:middle_names) }
		it { should have(:no).errors_on(:biography) }
	end

	context 'with valid attributes' do
		subject { Member.create!(@valid_attributes) }
		it { should be_valid }
		it { lambda { subject.save! }.should_not raise_error }
		it { should generate_a_stable_path_component }
	end
	
	context 'with an abbreviated' do
		context 'first name' do
			subject { Member.create!(@valid_attributes.merge(:first_name => 'Ant.')) }
			it { should be_valid }
			it { should generate_a_stable_path_component }
		end
		
		context 'middle name' do
			subject	{ Member.create!(@valid_attributes.merge(:middle_names => 'E.')) }
			it { should be_valid }
			it { should generate_a_stable_path_component }
		end
		
		context 'last name' do
			subject	{ Member.create!(@valid_attributes.merge(:last_name => 'Q.')) }
			it { should be_valid }
			it { should generate_a_stable_path_component }
		end
	end
	
	context 'with multiple middle names' do
		subject { Member.create!(@valid_attributes.merge(:middle_names => 'J. K. Barkhausen')) }
		it { should generate_a_stable_path_component }
	end
	
	before(:each) do
	  @valid_attributes = {
			:first_name => 'Anthony',
			:middle_names => 'Jaworski Smith',
			:last_name => 'Sullivan',
			:section => sections(:euphonium)
		}
	end
end
