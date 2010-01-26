module SampleData
	module PhoneNumbers
		class Example
			attr_reader :description, :number
			
			def initialize(description, number)
				@description = description
				@number = number
			end
		end
	end
	
	InvalidNorthAmericanPhoneNumbers = [
			PhoneNumbers::Example.new('area codes cannot begin with 0', '099-999-9999'),
			PhoneNumbers::Example.new('area codes cannot begin with 1', '199-999-9999'),
			PhoneNumbers::Example.new('area codes are required',        '999-9999'),
			PhoneNumbers::Example.new('area codes are required',        '199-9999'),
			PhoneNumbers::Example.new('area codes are required',        '099-9999'),
			PhoneNumbers::Example.new('there aren\'t enough digits',    '999-999'),
			PhoneNumbers::Example.new('there aren\'t enough digits',    '199-999'),
			PhoneNumbers::Example.new('there aren\'t enough digits',    '099-999'),
			PhoneNumbers::Example.new('letters are not allowed',        'abc-def-gehi'),
			PhoneNumbers::Example.new('letters are not allowed',        'abc-999-9999'),
			PhoneNumbers::Example.new('letters are not allowed',        '999-def-9999'),
			PhoneNumbers::Example.new('letters are not allowed',        '999-999-gehi'),
			PhoneNumbers::Example.new('it is too long',                 '9999-999-9999'),
			PhoneNumbers::Example.new('it is too long',                 '999-999-99999')
		]
end
