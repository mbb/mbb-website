require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do
  setup :activate_authlogic
  
	it { should route(:get,    '/members'       ).to(:controller => :members, :action => :index) }
	it { should route(:get,    '/members/new'   ).to(:controller => :members, :action => :new) }
	it { should route(:post,   '/members'       ).to(:controller => :members, :action => :create) }
	it { should route(:get,    '/members/1/edit').to(:controller => :members, :action => :edit,    :id => 1) }
	it { should route(:put,    '/members/1'     ).to(:controller => :members, :action => :update,  :id => 1) }
	it { should route(:delete, '/members/1'     ).to(:controller => :members, :action => :destroy, :id => 1) }
	it { should route(:get,    '/members/1'     ).to(:controller => :members, :action => :show,    :id => 1) }
	
	context 'when a Roster Adjustment member is logged in' do
		fixtures :members, :sections, :roles
		before :each do
			login({}, {:roles => [roles(:roster_adjustment)]})
		end
		
		it 'allows registration' do
			lambda do
				create_member
				response.should be_redirect
			end.should change(Member, :count).by(1)
		end

		it 'requires name on registration' do
			lambda do
				create_member(:name => nil)
				assigns[:member].errors.on(:name).should_not be_nil
				response.should be_success
			end.should_not change(Member, :count)
		end
	
		it 'does not require password on registration' do
			lambda do
				create_member(:password => nil)
				assigns[:member].errors.on(:password).should be_nil
				response.should redirect_to(private_roster_path)
			end.should change(Member, :count).by(1)
		end
	
		it 'does not require password confirmation on registration' do
			lambda do
				create_member(:password_confirmation => nil)
				assigns[:member].errors.on(:password_confirmation).should be_nil
				response.should redirect_to(private_roster_path)
			end.should change(Member, :count).by(1)
		end

		it 'requires email on registration' do
			lambda do
				create_member(:email => nil)
				assigns[:member].errors.on(:email).should_not be_nil
				response.should be_success
			end.should_not change(Member, :count)
		end
	
		it 'requires section on registration' do
			lambda do
				create_member(:section => nil)
				assigns[:member].errors.on(:section).should_not be_nil
				response.should be_success
			end.should_not change(Member, :count)
		end
		
		private
			def auth_token(token)
				CGI::Cookie.new('name' => 'auth_token', 'value' => token)
			end

			def cookie_for(user)
				auth_token members(user).reload.remember_token
			end
	
			def create_member(options = {})
				request.cookies["auth_token"] = cookie_for(:beaker)
				post :create, :member => { :name => 'Quire Fox', :email => 'quire@example.com', :section => sections(:eb_bass) }.merge(options)
			end
	end
end
