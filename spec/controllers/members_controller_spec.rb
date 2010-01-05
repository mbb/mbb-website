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
		fixtures :sections, :roles
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
			def create_member(options = {})
				new_member = Factory.build(:member, options)
				Member.stub!(:new).and_return(new_member)
				post :create, :member => {}
			end
	end
	
	context 'when a bad id is given' do
		old_slug_styles = {
			'with a period' => 'Some O. Slug',
			'without a period' => 'Some Old Slug'
		}
		
		old_slug_styles.each do |style, member_name|
			context "(#{style})" do
				before do
					@member = Factory.create(:member, :name => member_name)
					@old_slug = @member.name.gsub(' ', '_')
					@new_slug = @member.friendly_id
					MembersHelper.stub!(:bad_identifier?).and_return(true)
				end
				
				def params_for_slug(s)
					slug_has_period = /(.+)\.([^\.]+)/.match(s)
					if slug_has_period
						id, format = slug_has_period[1..2]
						{:id => id, :format => format}
					else
						{:id => s}
					end
				end

				it 'should return a permanent redirect' do
					get :show, params_for_slug(@old_slug)
					response.code.should == '301'  # Permanent Redirect
				end

				it 'should redirect with the new slug ID' do
					old_slug = 'Some Old Slug'
					get :show, params_for_slug(@old_slug)
					response.should redirect_to(member_url(:id => @new_slug))
				end
			end
		end
	end
	
	context '#show with a good identifier' do
		context 'but no matching member' do
			before do
				@member = Factory.create(:member, :name => 'Some Old Slug')
				@slug = @member.friendly_id
				MembersHelper.stub!(:bad_identifier?).with(@slug).and_return(true)
			end
		
			it 'should return a "Gone" status' do
				get :show, :id => @slug
				response.code.should == '410'  # Gone
			end
		
			it 'should render the members home page' do
				get :show, :id => @slug
				response.should render_template('index')
			end
		end
	end
end
