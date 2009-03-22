require 'test_helper'

class MemberTest < ActiveSupport::TestCase
	test 'members as strings are represented by full names' do
		assert_equal members(:john).full_name, members(:john).to_s
	end
	
  test 'member\'s full name is formatted correctly' do
  	jd = Member.new(:first_name => 'John', :last_name => 'Doe')
		assert_equal 'John Doe', jd.full_name
		
		jnd = Member.new(:first_name => 'Jane', :middle_names => 'Nancy', :last_name => 'Doe')
		assert_equal 'Jane Nancy Doe', jnd.full_name
  end

	test 'member has first, middle, last, and section' do
		assert Member.new.respond_to?(:first_name), "Member does not implement the first_name method."
		assert Member.new.respond_to?(:last_name), "Member does not implement the last_name method."
		assert Member.new.respond_to?(:middle_names), "Member does not implement the middle_names method."
		assert Member.new.respond_to?(:section), "Member does not implement the sections method."
		assert Member.new.respond_to?(:full_name), "Member does not implement the full_name method."
	end

	# Maybe better for specs or shouldas.
	# verifies first and last name
	# verifies section
end
