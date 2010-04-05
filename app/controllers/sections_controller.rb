# Note that this is an unconventional controller, according to REST. Instead of the usual
# organization where slashes are a has-a relation, e.g.
#    /people/John/ponies   "John has many ponies,"
# wherein the sub-resources can themselves be changed, this resource is under a belongs-to
# relation: A member _belongs_ to a section. Those sections never change aside from their
# membership.
class SectionsController < ApplicationController
	before_filter :require_user
	
	# PUT /member/:member_id/section
	# PUT /member/:member_id/section.js (RJS)
	def update
		@member = Member.find(params[:member_id])
		@member.section = Section.find(params[:section][:id])
		@member.save!
		
		respond_to do |wants|
			wants.html { redirect_back_or_default(member_url(@member)) }
			wants.js   { render 'update' }
		end
	end
end