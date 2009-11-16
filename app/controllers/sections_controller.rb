# Note that this is an unconventional controller, according to REST. Instead of the usual
# organization where slashes are a has-a relation, e.g.
#    /people/John/ponies   "John has many ponies,"
# wherein the sub-resources can themselves be changed, this resource is under a belongs-to
# relation: A member _belongs_ to a section. Those sections never change aside from their
# membership.
#
# It's possible that this section-changing logic really doesn't belong in a controller,
# exactly because it violates REST. Perhaps it should be an overloaded function of
# Member.section?
class SectionsController < ApplicationController
  before_filter :require_user
  
  # PUT /member/:member_id/section
	# PUT /member/:member_id/section.js (RJS)
	def update
	  @member = Member.find_by_path_component(params[:member_id])
	  old_section = @member.section
	  new_section = Section.find(params[:section][:id])
	  @member.remove_from_list
    @member.section = new_section

    if new_section.position < old_section.position and new_section.members.count > 0
      @member.insert_at(new_section.members.last.position + 1) # "bottom" of higher section
    else
      @member.insert_at(1) unless old_section == new_section
    end

	  respond_to do |wants|
			wants.html { redirect_back_or_default(member_url(@member)) }
			wants.js   { render 'update' }
		end
	end
	
end