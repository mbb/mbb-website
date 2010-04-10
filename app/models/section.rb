class Section < ActiveRecord::Base
	include Comparable
	has_many :members, :before_add => :set_section_position
	validates_presence_of :name
	validates_presence_of :position
	acts_as_list
	default_scope :order => 'position ASC'
	named_scope :private, :conditions => {:visible => false}
	named_scope :public, :conditions => {:visible => true}
	
	def above?(other_section)
		unless self.position.nil?
			self.position < other_section.position
		else
			false
		end
	end
	
	def below?(other_section)
		unless self.position.nil?
			self.position > other_section.position
		else
			false
		end
	end
	
	def set_section_position(member)
		unless member.section.nil?
			old_section = member.section
			member.remove_from_list
			member.section = self
		
			if self.above?(old_section) and self.members.count > 0
				member.insert_at(self.members.last.position + 1) # "bottom" of higher section
			else
				member.insert_at(1) unless old_section == self
			end
		else
			member.section = self
		end
	end
	
	def to_s
		name
	end
	
	def <=>(other)
		if other.kind_of?(Section)
			self.position <=> other.position
		else
			super(other)
		end
	end
end
