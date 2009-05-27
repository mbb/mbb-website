class Story < ActiveRecord::Base
	validates_presence_of :title, :date, :body
	default_scope :order => 'date DESC'
	
	def date
		unless attributes['date'].nil?
			this_date = attributes['date']
			def this_date.to_s
				strftime("%B %d, %Y").gsub(/\s0+/, ' ')
			end
			this_date
		else
			nil
		end
	end
end
