require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Private::PrivilegesController do
	it { should route(:get, '/private/privileges/edit').to(:controller => 'private/privileges', :action => :edit) }
	it { should route(:get, '/members/1/privileges').to(:controller => 'private/privileges', :action => :show, :member_id => 1) }
	
	context 'when not logged in' do
		before :each do
			logout
		end
		
		describe '#edit' do
			it 'should redirect to the login page' do
				get :edit
				response.should redirect_to(login_url)
			end
		end
		
		describe '#show' do
			it 'should redirect to the login page' do
				get :edit
				response.should redirect_to(login_url)
			end
		end
	end

	context 'when logged in as an unprivileged member' do
		before :each do
			login({}, {:privileged => false})
		end
		
		describe '#edit' do
			it 'should deny access' do
				get :edit
				response.code.should == '403' # Forbidden
			end
			
			it 'should not render the page' do
				get :edit
				response.should_not render_template('private/privileges/edit')
			end
		end
		
		describe '#show (for himself)' do
			it 'should permit access' do
				get :show, :member_id => current_user.id
				response.should be_success
			end
			
			it 'should render the page' do
				get :show, :member_id => current_user.id
				response.should render_template('private/privileges/show')
			end
		end
		
		describe '#show (for another member)' do
			before :each do
				@other_member = Factory.create(:member)
			end
			
			it 'should deny access' do
				get :show, :member_id => @other_member.id
				response.code.should == '403' # Forbidden
			end
			
			it 'should not render the page' do
				get :show, :member_id => @other_member.id
				response.should_not render_template('private/privileges/show')
			end
		end
	end

	context 'when logged in as a privileged member' do
		before :each do
			login({}, {:privileged => true})
		end
		
		describe '#edit' do
			it 'should permit access' do
				get :edit
				response.should be_success
			end
	
			it 'should render the page' do
				get :edit
				response.should render_template('private/privileges/edit')
			end
		end
		
		describe '#show (for himself)' do
			it 'should permit access' do
				get :show, :member_id => current_user.id
				response.should be_success
			end
			
			it 'should render the page' do
				get :show, :member_id => current_user.id
				response.should render_template('private/privileges/show')
			end
		end
		
		describe '#show (for another member)' do
			before :each do
				@other_member = Factory.create(:member)
			end
			
			it 'should permit access' do
				get :show, :member_id => @other_member.id
				response.should be_success
			end
			
			it 'should render the page' do
				get :show, :member_id => @other_member.id
				response.should render_template('private/privileges/show')
			end
		end
	end
end
