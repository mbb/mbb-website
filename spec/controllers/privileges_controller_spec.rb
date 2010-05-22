require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Private::PrivilegesController do
	it { should route(:get, '/private/privileges/edit').to(:controller => 'private/privileges', :action => :edit) }
	it { should route(:get, '/members/1/privileges').to(:controller => 'private/privileges', :action => :show, :member_id => 1) }
	
	describe '#edit' do
		context 'when not logged in' do
			before :each do
				logout
			end
			
			it 'should redirect to the login page' do
				get :edit
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before :each do
				login({}, {:privileged => false})
			end
			
			it 'should deny access' do
				get :edit
				response.code.should == '403' # Forbidden
			end
			
			it 'should not render the page' do
				get :edit
				response.should_not render_template('private/privileges/edit')
			end
		end
		
		context 'when logged in as a privileged member' do
			before :each do
				login({}, {:privileged => true})
			end
			
			it 'should permit access' do
				get :edit
				response.should be_success
			end
	
			it 'should render the page' do
				get :edit
				response.should render_template('private/privileges/edit')
			end
		end
	end
	
	describe '#show (for yourself)' do
		context 'when not logged in' do
			before :each do
				logout
			end
			
			it 'should redirect to the login page' do
				get :edit
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before :each do
				login({}, {:privileged => false})
				Member.should_receive(:find).with(current_user.id.to_s).and_return(current_user)
			end
			
			it 'should permit access' do
				get :show, :member_id => current_user.id
				response.should be_success
			end
			
			it 'should render the page' do
				get :show, :member_id => current_user.id
				response.should render_template('private/privileges/show')
			end
			
			it 'should set the :member variable identifying him' do
				Member.stub!(:find).with(current_user.id).and_return(current_user)
				get :show, :member_id => current_user.id
				assigns(:member).should == current_user
			end
		end
		
		context 'when logged in as a privileged member' do
			before :each do
				login({}, {:privileged => true})
				Member.should_receive(:find).with(current_user.id.to_s).and_return(current_user)
			end
			
			it 'should permit access' do
				get :show, :member_id => current_user.id
				response.should be_success
			end
			
			it 'should render the page' do
				get :show, :member_id => current_user.id
				response.should render_template('private/privileges/show')
			end
			
			it 'should set the :member variable identifying him' do
				get :show, :member_id => current_user.id
				assigns(:member).should == current_user
			end
		end
	end
	
	describe '#show (for another member)' do
		before :each do
			@other_member = stub_model(Member)
		end
		
		context 'when not logged in' do
			before :each do
				logout
			end
			
			it 'should redirect to the login page' do
				get :edit
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before :each do
				login({}, :privileged => false)
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
		
		context 'when logged in as a privileged member' do
			before :each do
				login({}, {:privileged => true})
				Member.should_receive(:find).with(@other_member.id.to_s).and_return(@other_member)
			end
			
			it 'should permit access' do
				get :show, :member_id => @other_member.id
				response.should be_success
			end
			
			it 'should render the page' do
				get :show, :member_id => @other_member.id
				response.should render_template('private/privileges/show')
			end
			
			it 'should set the :member variable identifying the target member' do
				get :show, :member_id => @other_member.id
				assigns(:member).should == @other_member
			end
		end
	end
end
