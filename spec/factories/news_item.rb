Factory.define :news_item do |i|
	i.sequence(:title) { |number| "Story ##{number}" }
	i.body 'Hooray! We are awesome (again!)'
	i.sequence(:created_at) { |n| n.days.ago }
	i.is_private false
end
