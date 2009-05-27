class Section < ActiveRecord::Base
	has_many :members
	validates_presence_of :name
	validates_presence_of :position
	acts_as_tree
	acts_as_list :scope => :parent_id
	default_scope :order => 'position ASC', :conditions => {:parent_id => nil}
	
	def to_s
		name
	end
end
