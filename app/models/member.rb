class Member < ActiveRecord::Base
	belongs_to :section
	
	validates_presence_of :first_name, :last_name, :section
	
	def full_name
		unless middle_names.nil?
			"#{first_name} #{middle_names} #{last_name}"
		else
			"#{first_name} #{last_name}"
		end
	end
	
	def to_pc
		full_name.gsub(' ', '_').downcase
	end
	
	def self.find_by_path_component(component)
		name = component.humanize.titleize
		self.find(:first, :conditions => {
			:first_name => simple_or_abbreviated(name.match(FullName)[1]),
			:middle_names => simple_or_abbreviated(name.match(FullName)[2]),
			:last_name => simple_or_abbreviated(name.match(FullName)[3])
		})
	end
	
	def to_param
		to_pc
	end
	
	def to_s
		full_name
	end
	
	private
		FirstName = /([\w\.]+)/
		MiddleNames = /\s([\w\s\.]+)/
		LastName = /\s([\w\.]+)/
		FullName = /#{FirstName} #{MiddleNames}? #{LastName}/x
		
		def self.simple_or_abbreviated(name_with_spaces)
			#TODO This doesn't actually generate an array of abbreviation possibilities.
			name_with_spaces
		end
end
