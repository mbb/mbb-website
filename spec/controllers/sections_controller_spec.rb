require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SectionsController do
	before do
		@the_member = stub_model(Member)
		Member.stub!(:find).and_return(@the_member)
	end
	
	describe '#update' do
		context 'when not logged in' do
			before { logout }
			
			it 'should redirect to the login page' do
				put :update, :member_id => :something
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in but unprivileged' do
			before { login({}, {:privileged? => false}) }
			
			it 'should forbid access' do
				put :update, :member_id => :something
				response.code.should == '403' # Forbidden
			end
		end
		
		context 'when logged in and privileged' do
			before do
				login({}, {:privileged? => true})
				
				@new_section = mock_model(Section)
				Section.should_receive(:find).with(:whatever).and_return(@new_section)
				
				@the_member.stub!(:neighbors).and_return([mock_model(Member, :reload => true), mock_model(Member, :reload => true)])
				@the_member.stub!(:save!).and_return(true)
			end
			
			context '(rendering JSON)' do
				it 'should respond successfully' do
					put :update, :format => 'js', :member_id => :something, :section => {:id => :whatever}
					response.should be_success
				end
				
				it 'should render the javascript result' do
					put :update, :format => 'js', :member_id => :something, :section => {:id => :whatever}
					response.should render_template('sections/update')
				end
				
				it 'should update the section id' do
					@the_member.should_receive(:section=).with(@new_section)
					put :update, :format => 'js', :member_id => :something, :section => {:id => :whatever}
				end
			end
		end
	end
end
