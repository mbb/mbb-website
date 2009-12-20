require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concert do
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:title) }
  it { should_not validate_presence_of(:description) }
  
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
    
    it 'should display concerts that happened earlier today as upcoming' do
      todays_concert = Factory(:concert, :date => Date.today, :time => 1.minute.ago)
      Concert.upcoming.should include(todays_concert)
    end
  end
  
  it 'should expose #past concerts'
  it 'should expose the #next concert'
end