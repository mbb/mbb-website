class Section < ActiveRecord::Base
	has_many :members
	validates_presence_of :name
	validates_presence_of :position
	acts_as_tree # Acts as Nested Set would be better; preserving order for leaves would be solved.
	acts_as_list :scope => :parent_id
	default_scope :order => 'position ASC'
	
	# Currently returns in the total order of positions, not just within sections. :(
	# Acts as Nested Set would be better; preserving order for leaves would be solved.
	named_scope :leaves,
		:conditions => 
			'NOT EXISTS (SELECT "parent_id" FROM "sections" AS "other_sections" WHERE "sections"."id" = "other_sections"."parent_id")'
	
	def self.all
		find(:all, :conditions => {:parent_id => nil})
	end
	
	def full_name
		this_one = self
		names = []
		until this_one.nil?
			names << this_one.name
			this_one = this_one.parent
		end
		
		names.join(' ')
	end
	
	def to_s
		name
	end
end
