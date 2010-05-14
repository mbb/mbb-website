require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Private::PrivilegesController do
	it { should route(:get, '/private/privileges').to(:controller => 'private/privileges', :action => :index) }
	
	context 'when not logged in' do
		before :each do
			logout
		end
		
		it 'should prompt the user to log in' do
			get :index
			response.code.should == '302' # Forbidden
		end
		
		it 'should redirect to the login page' do
			get :index
			response.should redirect_to(login_url)
		end
	end
	
	context 'when logged in as an unprivileged member' do
		before :each do
			login({}, {:privileged => false})
		end
		
		it 'should deny access' do
			get :index
			response.code.should == '403' # Forbidden
		end
		
		it 'should not render the page' do
			get :index
			response.should_not render_template('private/privileges/index')
		end
	end
	
	context 'when logged in as a privileged member' do
		before :each do
			login({}, {:privileged => true})
		end
		
		it 'should permit access' do
			get :index
			response.should be_success
		end
		
		it 'should render the page' do
			get :index
			response.should render_template('private/privileges/index')
		end
	end
end
