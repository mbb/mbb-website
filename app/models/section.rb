class Section < ActiveRecord::Base
	has_many :members
	
	validates_presence_of :instrument
	
	def to_s
		instrument
	end
end
