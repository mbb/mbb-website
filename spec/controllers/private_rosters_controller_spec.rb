require File.dirname(__FILE__) + '/../spec_helper'

describe Private::RostersController do	
	it { should route(:get, '/private/roster').to(:controller => [:private, :rosters], :action => :show) }

	context 'when logged in as a roster adjuster' do
		fixtures :members, :sections, :roles
		before :each do login_as(roles(:roster_adjustment).members.first) end
			
		describe 'the show action' do
			before :each do get :show end
		
			it 'should expose an array of sections in @sections' do
				assigns(:sections).class.should be(Array)
			end

			it 'should populate @sections with the full member list' do
				assigns(:sections).should eql(Section.all)
			end
		end
	end
	
	context 'when not logged in' do
		describe 'the show action' do
			before :each do get :show end
			it { should_not render_template('private/rosters/show') }
		end
	end
end
