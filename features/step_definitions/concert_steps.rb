Given /no upcoming concert/ do
	Concert.upcoming.destroy_all
end

Given /an upcoming concert/ do
	Concert.create!(:title => 'Concert on the Green',
	                :location => 'The Green',
	                :date => 2.days.from_now,
	                :description => 'Nothing to see here') if Concert.next.nil?
end

Given /a few upcoming concerts/ do
  Concert.create!(:title => 'Concert on the Green',
                  :location => 'The Green',
                  :date => 2.days.from_now,
                  :description => 'Nothing to see here')
  Concert.create!(:title => 'Concert on the Brown',
	                :location => 'The Brown',
	                :date => 3.days.from_now,
	                :description => 'Something to see here')
end

Given '$actor should see the concert $datum' do |_, datum|
	case datum
	when 'date'
		response.should have_text(/#{Concert.next.date.strftime('%B %d, %Y')}/)
	else
		response.should have_text(/#{Concert.next.send(datum)}/)
	end
end

Then '$actor should see all upcoming concerts in a table' do |_|
  Concert.upcoming.each do |concert|
    response.should have_text(/#{concert.date}/)
    response.should have_text(/#{concert.time}/)
    response.should have_text(/#{concert.location}/)
  end
end
