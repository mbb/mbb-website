module MadisonBrassBand
	module PhoneNumber
		def self.to_db(number)
			unless number.nil?
				digits = number.match(ThreeDegrees::Regex.phone_number)
				unless digits.nil?
					digits[1..3].join
				else
					nil
				end
			else
				nil
			end
		end
		
		def self.to_display(number)
			unless number.nil?
				match = number.match(ThreeDegrees::Regex.phone_number)
				unless match.nil?
					area_code, exchange, line = match[1..3]
					"(#{area_code}) #{exchange}-#{line}"
				else
					nil
				end
			else
				nil
			end
		end
	end
end