module ThreeDegrees
  
  # Includes common regular expressions for validating database column formats.
  module Regex
    def self.phone_number
      PhoneNumber
    end
    
    private
      AreaCode = /[2-9]\d{2}/
      Exchange = /(?!\d[1]{2}|[5]{3})[2-9]\d{2}/
      Line = /\d{4}/
      PhoneNumber = /^\(?(#{AreaCode})\)?[. -]*(#{Exchange})[. -]*(#{Line})$/
  end
  
end