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
			date
		else
			"#{date}, #{time}"
		end
	end
	
	def date
		attributes['date'].strftime('%A %B %d, %Y')
	end
	
	def time
		unless attributes['time'].nil?
			attributes['time'].strftime('%I:%M%p')
		else
			nil
		end
	end
	
	def to_s
		"#{date}: #{title}"
	end
end