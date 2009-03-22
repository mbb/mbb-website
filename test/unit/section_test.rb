require 'test_helper'

class SectionTest < ActiveSupport::TestCase
	test 'section\'s string representation is its instrument' do
		assert_equal sections(:flugelhorn).instrument, sections(:flugelhorn).to_s
	end
	
	test 'a section has an instrument and members' do
		assert Section.new.respond_to?(:instrument)
		assert Section.new.respond_to?(:members)
	end
	
  # For shoulda?
	# Verifies instrument
end
