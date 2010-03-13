Factory.define :fan do |f|
	f.sequence(:email) { |number| "fan_#{number}@somewhereelse.com" }
end