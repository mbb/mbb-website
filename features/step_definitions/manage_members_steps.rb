Given /^the following members:$/ do |manage_members|
  Member.create!(manage_members.hashes)
end

Then '$actor should see $member_name in the $section_name section' do |_, member_name, section_name|
	response.should have_selector('table#Sections') do |sections|
		#sections.should have_selector('#member_' + Member.find_by_name(member_name).id.to_s ) do |member|
		#	member.should have_text(member_name)
		#	member.should have_text(section_name)
		#end
		fail
	end
end
