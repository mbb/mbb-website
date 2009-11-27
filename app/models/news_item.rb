class NewsItem < ActiveRecord::Base
	has_many :attached_files
	
	def date
		created_at.strftime('%B %d, %Y')
	end
	
	validates_presence_of :title, :body
	validates_inclusion_of :is_private, :in => [true, false]
	default_scope :order => 'created_at DESC'
	named_scope :recent, :limit => 10
	named_scope :public_items, :conditions => {:is_private => false}
	named_scope :private_items, :conditions => {:is_private => true}
end
