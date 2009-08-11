require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concert do
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:title) }
  it { should_not validate_presence_of(:description) }
  
  it 'should expose #upcoming concerts'
  it 'should expose #past concerts'
  it 'should expose the #next concert'
end