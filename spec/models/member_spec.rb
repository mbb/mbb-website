require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
	fixtures :sections
	
	context '(in general)' do
		it { should belong_to(:section) }
		it { should have_db_column(:name) }
		it { should have_db_column(:biography) }
		it { should validate_presence_of(:section) }
		it { should validate_presence_of(:name) }
	end
	
	context 'without any attributes' do
		subject { Member.new }
		it { should have_at_least(1).error_on(:section) }
		it { should have_at_least(1).error_on(:name) }
		it { should have(:no).errors_on(:biography) }
	end

	context 'with valid attributes' do
		subject { Member.create(@valid_attributes) }
		it { should be_valid }
		it { lambda { subject.save! }.should_not raise_error }
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
			:section => sections(:euphonium)
		}
	end
end
