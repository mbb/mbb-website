require 'mbb/phone_number'

class MemberObserver < ActiveRecord::Observer
	def before_save(record)
		record.phone_number = MadisonBrassBand::PhoneNumber.to_db(record.phone_number)
	end
end
