class Section < ActiveRecord::Base
	has_many :members
	
	def to_s
		instrument
	end
end
