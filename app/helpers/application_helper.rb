module ApplicationHelper
	def has_member_edit_permission(member)
		(current_member.id == member.id) or (member.has_role?(:board))
	end
end
