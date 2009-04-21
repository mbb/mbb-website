require File.dirname(__FILE__) + '/../spec_helper'
	
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe Private::MembersController do
	fixtures :members, :sections, :roles

	context 'when a board member is logged in' do
		before :each do
			login_as members(:beaker)
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
				response.should redirect_to(private_members_path)
			end.should change(Member, :count).by(1)
		end
	
		it 'does not require password confirmation on registration' do
			lambda do
				create_member(:password_confirmation => nil)
				assigns[:member].errors.on(:password_confirmation).should be_nil
				response.should redirect_to(private_members_path)
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

describe Private::MembersController do
	describe "route generation" do
		it "should route members's 'index' action correctly" do
			route_for(:controller => 'private/members', :action => 'index').should == "/private/members"
		end
		
		it "should route members's 'new' action correctly" do
			route_for(:controller => 'private/members', :action => 'new').should == "/signup"
		end
		
		it "should route {:controller => 'private/members', :action => 'create'} correctly" do
			route_for(:controller => 'private/members', :action => 'create').should == "/register"
		end
		
		it "should route members's 'show' action correctly" do
			route_for(:controller => 'private/members', :action => 'show', :id => '1').should == "/private/members/1"
		end
		
		it "should route members's 'edit' action correctly" do
			route_for(:controller => 'private/members', :action => 'edit', :id => '1').should == "/private/members/1/edit"
		end
		
		it "should route members's 'update' action correctly" do
			route_for(:controller => 'private/members', :action => 'update', :id => '1').should == {:path => "/private/members/1", :method => :put}
		end
		
		it "should route members's 'destroy' action correctly" do
			route_for(:controller => 'private/members', :action => 'destroy', :id => '1').should ==
				{:path => '/private/members/1', :method => :delete}
		end
	end
	
	describe "route recognition" do
		it "should generate params for members's index action from GET /private/members" do
			params_from(:get, '/private/members').should == {:controller => 'private/members', :action => 'index'}
			params_from(:get, '/private/members.xml').should == {:controller => 'private/members', :action => 'index', :format => 'xml'}
			params_from(:get, '/private/members.json').should == {:controller => 'private/members', :action => 'index', :format => 'json'}
		end
		
		it "should generate params for members's new action from GET /private/members" do
			params_from(:get, '/private/members/new').should == {:controller => 'private/members', :action => 'new'}
			params_from(:get, '/private/members/new.xml').should == {:controller => 'private/members', :action => 'new', :format => 'xml'}
			params_from(:get, '/private/members/new.json').should == {:controller => 'private/members', :action => 'new', :format => 'json'}
		end
		
		it "should generate params for members's create action from POST /private/members" do
			params_from(:post, '/private/members').should == {:controller => 'private/members', :action => 'create'}
			params_from(:post, '/private/members.xml').should == {:controller => 'private/members', :action => 'create', :format => 'xml'}
			params_from(:post, '/private/members.json').should == {:controller => 'private/members', :action => 'create', :format => 'json'}
		end
		
		it "should generate params for members's show action from GET /private/members/1" do
			params_from(:get , '/private/members/1').should == {:controller => 'private/members', :action => 'show', :id => '1'}
			params_from(:get , '/private/members/1.xml').should == {:controller => 'private/members', :action => 'show', :id => '1', :format => 'xml'}
			params_from(:get , '/private/members/1.json').should == {:controller => 'private/members', :action => 'show', :id => '1', :format => 'json'}
		end
		
		it "should generate params for members's edit action from GET /private/members/1/edit" do
			params_from(:get , '/private/members/1/edit').should == {:controller => 'private/members', :action => 'edit', :id => '1'}
		end
		
		it "should generate params {:controller => 'private/members', :action => update', :id => '1'} from PUT /private/members/1" do
			params_from(:put , '/private/members/1').should == {:controller => 'private/members', :action => 'update', :id => '1'}
			params_from(:put , '/private/members/1.xml').should == {:controller => 'private/members', :action => 'update', :id => '1', :format => 'xml'}
			params_from(:put , '/private/members/1.json').should == {:controller => 'private/members', :action => 'update', :id => '1', :format => 'json'}
		end
		
		it "should generate params for members's destroy action from DELETE /private/members/1" do
			params_from(:delete, '/private/members/1').should == {:controller => 'private/members', :action => 'destroy', :id => '1'}
			params_from(:delete, '/private/members/1.xml').should == {:controller => 'private/members', :action => 'destroy', :id => '1', :format => 'xml'}
			params_from(:delete, '/private/members/1.json').should == {:controller => 'private/members', :action => 'destroy', :id => '1', :format => 'json'}
		end
	end
	
	describe "named routing" do
		before(:each) do
			get :new
		end
		
		it "should route members_path() to /private/members" do
			private_members_path().should == "/private/members"
			private_members_path(:format => 'xml').should == "/private/members.xml"
			private_members_path(:format => 'json').should == "/private/members.json"
		end
		
		it "should route new_member_path() to /private/members/new" do
			new_private_member_path().should == "/private/members/new"
			new_private_member_path(:format => 'xml').should == "/private/members/new.xml"
			new_private_member_path(:format => 'json').should == "/private/members/new.json"
		end
		
		it "should route member_(:id => '1') to /private/members/1" do
			private_member_path(:id => '1').should == "/private/members/1"
			private_member_path(:id => '1', :format => 'xml').should == "/private/members/1.xml"
			private_member_path(:id => '1', :format => 'json').should == "/private/members/1.json"
		end
		
		it "should route edit_member_path(:id => '1') to /private/members/1/edit" do
			edit_private_member_path(:id => '1').should == "/private/members/1/edit"
		end
	end
	
end
