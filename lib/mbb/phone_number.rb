module MadisonBrassBand
  module PhoneNumber
    def self.to_db(number)
      unless number.nil?
        digits = number.match(ThreeDegrees::Regex.phone_number)[1..3]
        digits.join
      else
        nil
      end
    end
    
    def self.to_display(number)
      unless number.nil?
        area_code, exchange, line = number.match(ThreeDegrees::Regex.phone_number)[1..3]
        "(#{area_code}) #{exchange}-#{line}"
      else
        nil
      end
    end
  end
end