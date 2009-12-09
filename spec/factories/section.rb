Factory.define :section do |s|
	s.sequence(:name) { |id| "#{id}" }
	s.sequence(:position) { |id| id }
end