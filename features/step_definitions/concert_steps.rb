Given /an upcoming concert/ do
	Concert.create!(:title => 'Concert on the Green',
	                :location => 'The Green',
	                :date => 2.days.from_now,
	                :description => 'Nothing to see here') if Concert.next.nil?
end

Given /no upcoming concert/ do
	Concert.upcoming.destroy_all
end

Given '$actor should see the concert $datum' do |_, datum|
	case datum
	when 'date'
		response.should have_text(/#{Concert.next.date.strftime('%B %d, %Y')}/)
	else
		response.should have_text(/#{Concert.next.send(datum)}/)
	end
end
