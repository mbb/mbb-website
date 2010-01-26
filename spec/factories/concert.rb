Factory.define :concert do |c|
	c.sequence(:title) { |n| "Concert #{n}" }
	c.sequence(:date)  { |n| n.weeks.ago }
	c.sequence(:time)  { |n| Time.parse("#{(n % 12) + 1}:30pm")}
	c.location 'Your Mom\'s House'
end
