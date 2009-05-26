class Section < ActiveRecord::Base
	has_many :members
	validates_presence_of :instrument
	validates_presence_of :position
	default_scope :order => :position
	
	def to_s
		instrument
	end
end
