require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concert do
	it { should validate_presence_of(:date) }
	it { should validate_presence_of(:location) }
	it { should validate_presence_of(:time) }
	it { should validate_presence_of(:title) }
	it { should_not validate_presence_of(:description) }
	
	it '#to_s should include the title of the concert' do
		concert = Factory(:concert)
		concert.to_s.should =~ /#{concert.title}/
	end
	
	describe '#upcoming' do
		it 'should expose future concerts' do
			upcoming_concerts = [
				Factory(:concert, :date => 2.days.from_now),
				Factory(:concert, :date => 3.days.from_now)
			]
			upcoming_concerts.each do |this_concert|
				Concert.upcoming.should include(this_concert)				
			end
		end
		
		it 'should not expose past concerts' do
			past_concerts = [
				Factory(:concert, :date => 2.days.ago),
				Factory(:concert, :date => 3.days.ago)
			]
			past_concerts.each do |this_concert|
				Concert.upcoming.should_not include(this_concert)				
			end
		end
		
		it 'should display concerts that happened earlier today' do
			todays_concert = Factory(:concert, :date => Date.today, :time => 1.minute.ago)
			Concert.upcoming.should include(todays_concert)
		end
	end
	
	describe '#past' do
		it 'should not expose future concerts' do
			upcoming_concerts = [
				Factory(:concert, :date => 2.days.from_now),
				Factory(:concert, :date => 3.days.from_now)
			]
			upcoming_concerts.each do |this_concert|
				Concert.past.should_not include(this_concert)				
			end
		end
		
		it 'should not expose past concerts' do
			past_concerts = [
				Factory(:concert, :date => 2.days.ago),
				Factory(:concert, :date => 3.days.ago)
			]
			past_concerts.each do |this_concert|
				Concert.past.should include(this_concert)				
			end
		end
		
		it 'should not select concerts that happened earlier today' do
			todays_concert = Factory(:concert, :date => Date.today, :time => '12:00am')
			Concert.past.should_not include(todays_concert)
		end
	end
	
	describe '#next' do
		it 'should return nil when there are no concerts at all' do
			Concert.delete_all
			Concert.next.should be_nil
		end
		
		it 'should return nil when there are only past concerts' do
			Concert.delete_all
			Factory(:concert, :date => 2.days.ago)
			Concert.next.should be_nil
		end
		
		it 'should return the nearest future concert' do
			upcoming_concerts = [
				Factory(:concert, :date => 2.days.from_now),
				Factory(:concert, :date => 3.days.from_now)
			]
			Concert.next.should == upcoming_concerts[0]
		end
		
		it 'should return today\'s concert, if it exists' do
			today, tomorrow = Factory(:concert, :date => Date.today), Factory(:concert, :date => Date.tomorrow)
			Concert.next.should == today
		end
		
		it 'should return today\'s concert if it has just passed' do
			today = Factory(:concert, :date => Date.today, :time => 1.minute.ago)
			Concert.next.should == today
		end
	end
end
