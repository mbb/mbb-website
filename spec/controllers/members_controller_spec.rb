require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do
	setup :activate_authlogic
	
	it { should route(:get,    '/members'       ).to(:controller => :members, :action => :index            ) }
	it { should route(:get,    '/members/new'   ).to(:controller => :members, :action => :new              ) }
	it { should route(:post,   '/members'       ).to(:controller => :members, :action => :create           ) }
	it { should route(:get,    '/members/1/edit').to(:controller => :members, :action => :edit,    :id => 1) }
	it { should route(:put,    '/members/1'     ).to(:controller => :members, :action => :update,  :id => 1) }
	it { should route(:delete, '/members/1'     ).to(:controller => :members, :action => :destroy, :id => 1) }
	it { should route(:get,    '/members/1'     ).to(:controller => :members, :action => :show,    :id => 1) }
	
	#
	# Privileged members should be able to do just about everything.
	#
	context 'when a privileged member is logged in' do
		fixtures :sections
		before :each do
			login({}, {:privileged => true})
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
	
	#
	# Unprivileged members shouldn't be able to do anything but edit themselves.
	#
	context 'when a normal member is logged in' do
		before :each do
			login({}, {:privileged? => false})
		end
		
		it 'allows him to edit his profile' do
			MembersHelper.stub!(:bad_identifier?).and_return(false)
			Member.stub!(:find).and_return(current_user)
			get :edit, :id => current_user.to_param
			response.should be_success
			response.should render_template('edit')
		end
		
		it 'does not allow him to edit another person\'s profile' do
			MembersHelper.stub!(:bad_identifier?).and_return(false)
			Member.stub!(:find).and_return(current_user)
			someone_else = Factory(:member)
			get :edit, :id => someone_else.to_param
			response.should_not be_success
			response.code.should == '403'
			response.should render_template('private/rosters/show')
		end
	end
	
	describe '#update' do
		context 'when logged out' do
			before { logout }
			
			it 'should redirect to the login page' do
				put :update, :id => :something
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before do
				login({}, {:privileged? => false})
				@the_member = current_user
				Member.stub!(:find).and_return(@the_member)
			end
			
			context 'and addressing some other member' do
				it 'should deny access' do
					put :update, :id => :something
					response.code.should == '403' # Forbidden
				end
				
				it 'should not update any attributes of any model' do
					member = mock_model(Member)
					Member.stub!(:find).and_return(member)
					member.should_not_receive(:update_attributes)
					put :update, :id => :something
				end
			end
			
			context 'and addressing his own information (other than his section or privileged status)' do
				it 'should redirect back to the member profile' do
					@the_member.should_receive(:update_attributes).and_return(true)
					put :update, :id => current_user.id, :member => {}
					response.should redirect_to(member_url(:id => current_user.id))
				end
				
				it 'should update the given features of the member' do
					@the_member.should_receive(:update_attributes).with('these' => 'params').and_return(true)
					put :update, :id => current_user.id, :member => {'these' => 'params'}
				end
			end
			
			context 'and changing his own section' do
				before(:each) do
					def make_request(format = :html)
						put :update, :format => format.to_s, :id => current_user.id, :member => {:section_id => current_user.id}
					end
				end
				
				it 'should not update the member' do
					@the_member.should_not_receive(:update_attributes)
					make_request
				end
				
				it 'should return a forbidden error' do
					make_request
					response.code.should == '403' # Forbidden
				end
			end
			
			context 'and setting his own privileged status' do
				before(:each) do
					def make_request(format = :html)
						put :update, :format => format.to_s, :id => current_user.id, :member => {:privileged => true}
					end
				end
				
				it 'should not update the member' do
					@the_member.should_not_receive(:update_attributes)
					make_request
				end
				
				[:html, :json].each do |format|
					context "(requesting #{format})" do
						it 'should return a forbidden error' do
							make_request
							response.code.should == '403' # Forbidden
						end
					end
				end
			end
		end
		
		context 'when logged in as a privileged member' do
			before do
				login({}, {:privileged? => true})
				@the_member = mock_model(Member, :save => true, :id => :something)
				Member.stub!(:find).and_return(@the_member)
				
				def make_request(format = :html)
					put :update, :format => format.to_s, :id => :something, :member => {}
				end
			end
			
			context 'and submitting invalid changes to a profile' do
				before do
					@the_member.stub!(:update_attributes).and_return(false)
				end
				
				context 'independently of a section change' do
					[:html, :json].each do |format|
						context "(requesting #{format})" do
							it 'should return a 400 error' do
								make_request(format)
								response.code.should == '400'
							end
						end
					end
				end
				
				context 'with a section change' do
					before do
						@old_section = stub_model(Section, :position => 1)
						@new_section = stub_model(Section, :position => 2)
						@the_member.stub!(:section).and_return(@old_section)
						@the_member.stub!(:section_id).and_return(@old_section.id)
						Section.stub!(:find).and_return(@new_section)
					end
					
					context 'but no position setting' do
						before do
							def make_request(format)
								put :update, :format => format.to_s, :id => :something, :member => {:section_id => :something_new}
							end
						end
						
						[:html, :json].each do |format|
							context "(requesting #{format})" do
								it 'should return a 400 error' do
									make_request(format)
									response.code.should == '400'
								end
							end
						end
					end
					
					context 'and a position setting' do
						before do
							@replaced_member = mock_model(Member, :id => :replaced_member_id, :position => 500)
							Member.should_receive(:find).with(@replaced_member.position.to_s).and_return(@replaced_member)
							@the_member.stub!(:insert_at).and_return(true)
							
							def make_request(format = :html)
								put :update, :format => format.to_s, :id => :something, :member => {:section_id => :something_new, :position => @replaced_member.position.to_s}
							end
						end
						
						it 'should not set the member\'s position' do
							@the_member.should_not_receive(:insert_at)
							make_request
						end
						
						[:html, :json].each do |format|
							context "(requesting #{format})" do
								it 'should return a 400 error' do
									make_request(format)
									response.code.should == '400'
								end
							end
						end
					end
				end
			end
			
			context 'and submitting valid changes to a profile' do
				before do
					@the_member = mock_model(Member, :save => true, :id => :something)
					@the_member.stub!(:update_attributes).and_return(true)
					Member.should_receive(:find).and_return(@the_member)
				end
				
				context 'independently of a section change' do
					it 'should redirect back to the member profile' do
						put :update, :id => :something, :member => {}
						response.should redirect_to(member_url(:id => :something))
					end
				
					it 'should update the given features of the member' do
						@the_member.should_receive(:update_attributes).with('these' => 'params').and_return(true)
						put :update, :id => :something, :member => {'these' => 'params'}
					end
					
					context '(requesting html)' do
						it 'should redirect back to the profile' do
							make_request(:html)
							response.should redirect_to(member_path(@the_member))
						end
					end
					
					context '(requesting json)' do
						it 'should return success' do
							make_request(:json)
							response.should be_success
						end
					end
				end
				
				context 'with a section change' do
					before do
						@old_section = mock_model(Section, :position => 1)
						@new_section = mock_model(Section, :position => 2)
						@the_member.stub!(:section).and_return(@old_section)
						@the_member.stub!(:section_id).and_return(@old_section.id)
						Section.stub!(:find).and_return(@new_section)
					end
					
					context 'without a position setting' do
						before do
							def make_request(format = :html)
								put :update, :format => format.to_s, :id => :something, :member => {'section_id' => :something_else}
							end
						end
						
						it 'should commit the section change' do
							@the_member.should_receive(:update_attributes).with('section' => @new_section)
							make_request
						end
					end
					
					context 'with a non-nil position setting' do
						before do
							@replaced_member = mock_model(Member, :id => :replaced_member_id, :position => 500)
							Member.should_receive(:find).with(@replaced_member.position.to_s).and_return(@replaced_member)
							@the_member.stub!(:insert_at).and_return(true)
							
							def make_request(format = :html)
								put :update, :format => format.to_s, :id => :something, :member => {'section_id' => :something_else, :position => @replaced_member.position.to_s}
							end
						end
						
						it 'should commit the section change' do
							@the_member.should_receive(:update_attributes).with('section' => @new_section)
							make_request
						end
						
						it 'should set the new position appropriately' do
							@the_member.should_receive(:insert_at).with(@replaced_member.position).and_return(true)
							make_request
						end
					end
					
					context 'with a nil position setting' do
						before do
							@the_member.stub!(:insert_at).and_return(true)
							
							def make_request(format = :html)
								put :update, :format => format.to_s, :id => :something, :member => {'section_id' => :something_else, :position => false}
							end
						end
						
						context 'where the new section is empty' do
							before { @new_section.stub!(:members).and_return([]) }
							
							it 'should set the new position appropriately' do
								@the_member.should_receive(:insert_at).with(1)
								make_request
							end
						end
						
						context 'where the new section is nonempty' do
							before { @new_section.stub!(:members).and_return([mock_model(Member, :position => 500)]) }
							
							it 'should set the new position appropriately' do
								@the_member.should_receive(:insert_at).with(501)
								make_request
							end
						end
					end
				end
				
				context 'and setting his privileged status' do
					before(:each) do
						def make_request(format = :html)
							put :update, :format => format.to_s, :id => :something, :member => {:privileged => true}
						end
					end
					
					context "(requesting html)" do
						it 'should return successfully' do
							make_request(:html)
							response.code.should == '303'
						end
					end
					
					context "(requesting json)" do
						it 'should return successfully (via 303)' do
							make_request(:json)
							response.should be_success
						end
					end
				end
			end
		end
	end
	
	#
	# The URLs used to be written differently (e.g. /members/Andres_J._Tack instead
	# of /members/andres-j-tack); we try to convert forwards, and for made up URLs
	# handle the error appropriately.
	#
	context 'when a bad id is given' do
		old_slug_styles = {
			'with a period' => 'Some O. Slug',    # Relevant because of extension parsing.
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
