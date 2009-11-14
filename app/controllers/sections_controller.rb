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