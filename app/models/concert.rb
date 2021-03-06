class Concert < ActiveRecord::Base
	validates_presence_of :title
	validates_presence_of :date
	validates_presence_of :time
	validates_presence_of :location
	
	named_scope :upcoming, :conditions => ['date >= ?', Date.today], :order => 'date ASC'
	named_scope :past, :conditions => ['date < ?', Date.today], :order => 'date DESC'
	
	def self.next
		self.upcoming.first
	end
	
	def to_s
		"#{date.strftime('%B %d, %Y')}: #{title}"
	end
end