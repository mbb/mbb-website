Factory.define :member do |m|
	m.sequence(:name) { |number| "User #{number}" }
	m.sequence(:email) { |number| "user_#{number}@mbb.com" }
	m.sequence(:phone_number) { |number| "212-436-#{number.to_s.rjust(4, "0")}" }
	m.association :section
end
