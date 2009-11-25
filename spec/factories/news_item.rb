Factory.define :news_item do |i|
	i.sequence(:title) { |number| "Story ##{number}" }
	i.body 'Hooray! We are awesome (again!)'
	i.sequence(:date) { |n| n.days.ago }
end