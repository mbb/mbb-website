class Member < ActiveRecord::Base
	belongs_to :section
	
	def full_name
		unless middle_names.nil?
			"#{first_name} #{middle_names} #{last_name}"
		else
			"#{first_name} #{last_name}"
		end
	end
	
	def to_s
		full_name
	end
end
