Given /^the following members:$/ do |manage_members|
  Member.create!(manage_members.hashes)
end

Then '$actor should see $member_name in the $section_name section' do |_, member_name, section_name|
	fail
end
