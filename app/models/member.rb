class Member < ActiveRecord::Base
	private
		FirstName = /([\w\.]+)/
		MiddleNames = /\s([\w\s\.]+)/
		LastName = /\s([\w\.]+)/
		FullName = /#{FirstName} #{MiddleNames}? #{LastName}/x

	public
		belongs_to :section
		validates_presence_of :name, :section
		validates_format_of :name, :with => FullName
	
		def to_pc
			name.gsub(' ', '_').downcase
		end
	
		def self.find_by_path_component(component)
			self.find_by_name(component.humanize.titleize)
		end
	
		def to_param
			to_pc
		end
	
		def to_s
			name
		end
end
