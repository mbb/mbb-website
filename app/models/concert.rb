class Concert < ActiveRecord::Base
	validates_presence_of :title
	validates_presence_of :date
	validates_presence_of :location
	validates_presence_of :description
	
	named_scope :upcoming, :conditions => ['date >= ?', Time.zone.today]
	named_scope :past, :conditions => ['date < ?', Time.zone.today]
	
	def self.next
		self.upcoming.first
	end
	
	def date_and_time
		if time.nil?
			date.strftime('%A %B %d, %Y')
		else
			"#{date.strftime('%A %B %d, %Y')}, #{time.strftime('%I:%M%p')}"
		end
	end
	
	def to_s
		"#{date}: #{title}"
	end
end