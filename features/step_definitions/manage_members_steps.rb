Given /^the following members:$/ do |manage_members|
  Member.create!(manage_members.hashes)
end

Then '$actor should see $member_name in the $section_name section' do |_, member_name, section_name|
	response.should have_selector("ul#Sections li h2:contains('#{section_name}') + ul") do |section_list|
		section_list.should have_selector("li:contains('#{member_name}')")
	end
end
